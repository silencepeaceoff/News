//
//  ViewController.swift
//  News
//
//  Created by Dmitrii Tikhomirov on 2/10/23.
//

import UIKit

class NewsViewController: UIViewController {
    private var newsTableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()
    //Dictionary save & load to file
    private var titleClickDict: [String: String] = [:]
    //Max number of news to see in table view for this API
    private var totalResults = 37
    //Get the URL for the UserClicks plist file in the app's Documents directory
    private let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("UserClicks")
        .appendingPathExtension("plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load UserClicks from file
        titleClickDict = loadFromFile()
        configureNavTabBar()
        configureNewsTableView()
        fetchNews()
        pullToRefresh()
    }
    //MARK: - Configure Navigation Tab Bar
    private func configureNavTabBar() {
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        navBarAppearance.backgroundColor = .systemYellow
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    //MARK: - Configure News Table View
    private func configureNewsTableView() {
        view.addSubview(newsTableView)
        setNewsTableViewDelegate()
        newsTableView.rowHeight = 102
        newsTableView.pin(to: view)
        newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    //MARK: - Set Table View Delegate & Data Source
    private func setNewsTableViewDelegate() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
    }
    //MARK: - Fetch News Data
    private func fetchNews() {
        APICaller.shared.getNews { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.newsTableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorAlert(message: error.errorDescription ?? "some error")
                }
            }
        }
    }
    //MARK: - Create Pull to Refresh func
    private func pullToRefresh() {
        newsTableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching News...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        fetchNews()
    }
}
//MARK: - Configure Table
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    //MARK: - Configure Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        
        let news = viewModels[indexPath.row]
        cell.configure(with: news)
        //Write dictionary keys & update cell count values
        cell.viewsCounter.text = titleClickDict[news.title]

        return cell
    }
    //MARK: - Select News in a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Transit data to Detail News
        let detailNewsVC = DetailNewsViewController()
        detailNewsVC.article = articles[indexPath[1]]
        detailNewsVC.imageData = viewModels[indexPath[1]]
        //Count click on news & save to file
        if let title = detailNewsVC.article?.title {
            if let numberClicks = titleClickDict[title] {
                titleClickDict[title] = String((Int(numberClicks) ?? 0) + 1)
            } else {
                titleClickDict[title] = String(Int(1))
            }
            saveToFile(dict: titleClickDict)
        }
        //Open Detail News with image and description
        detailNewsVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailNewsVC, animated: true)
    }
    //MARK: - Create function adding 20 News
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row >= APICaller.numberNews - 1) && (viewModels.count < totalResults) {
            APICaller.numberNews += 20
            fetchNews()
        }
    }
    //MARK: - Create Error Alert
    func errorAlert(message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    //MARK: - Create Save&Load function for User Transitions to File
    func loadFromFile() -> [String: String] {
        if let url = fileURL {
            guard let data = try? Data(contentsOf: url) else { return [:] }
            guard let dict = try? PropertyListDecoder().decode([String: String].self, from: data) else { return [:] }
            return dict
        }
        return [:]
    }
    
    func saveToFile(dict: [String: String]) {
        if let url = fileURL {
            var dictFromFile = loadFromFile()
            dictFromFile = dictFromFile.merging(dict, uniquingKeysWith: { (_, last) in last } )
            guard let data = try? PropertyListEncoder().encode(dictFromFile) else {
                return
            }
            try? data.write(to: url, options: .noFileProtection)
        }
    }
}
