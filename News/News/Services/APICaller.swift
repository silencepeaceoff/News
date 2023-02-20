//
//  APICaller.swift
//  News
//
//  Created by Dmitrii Tikhomirov on 2/10/23.
//

import UIKit
import UserNotifications

final class APICaller {
    //Create notifications
    let notifications = Notifications()
    //Create a singleton
    static let shared = APICaller()
    //Count of news loading first time
    static var numberNews = 20
    //Create function to build URL
    func createURL(number: Int) -> URL? {
        URL(string: "https://newsapi.org/v2/top-headlines?country=us&pageSize=\(number)&apiKey=db7b483fc81341e5b0db3ba5a9cbac62")
    }
    
    private init() {}
    
    //Create publick function to get news
    public func getNews(completion: @escaping (Result<[Article], Error>) -> Void) {
        //Create URL
        guard let url = createURL(number: APICaller.numberNews) else { return }
        //Create task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //Check if there is no error
            guard let response = response as? HTTPURLResponse else {
                self.notifications.sendNotifications(
                    message: "Unknown response received. Check internet connection."
                )
                return
            }
            
            guard let httpStatusCode = HttpStatusCode(rawValue: response.statusCode) else {
                self.notifications.sendNotifications(
                    message: "Unknown http status code."
                )
                return
            }
            
            if !httpStatusCode.isSuccessStatusCode {
                completion(.failure(Error(code: response.statusCode)))
            }
            //Check data is exist
            if let data = data {
                //Try to decode data
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                //Catch error
                catch {
                    completion(.failure(error as! Error))
                }
            }
        }
        //Resume task
        task.resume()
    }
}
