//
//  NewsCell.swift
//  News
//
//  Created by Dmitrii Tikhomirov on 2/10/23.
//
import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let imageURL: URL?
    var imageData: Data?
    var viewsCounter: Int?
    
    init(
        title: String,
        imageURL: URL?
    ) {
        self.title = title
        self.imageURL = imageURL
    }
}
