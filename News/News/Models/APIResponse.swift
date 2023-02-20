//
//  APIResponse.swift
//  News
//
//  Created by Dmitrii Tikhomirov on 2/10/23.
//

import UIKit

struct APIResponse: Codable {
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let urlToImage: String?
    let description: String?
    let publishedAt: String
    let url: String?
}

struct Source: Codable {
    let name: String
}
