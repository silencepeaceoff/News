//
//  DetailNewsViewController.swift
//  News
//
//  Created by Dmitrii Tikhomirov on 2/11/23.
//

import UIKit
import WebKit

class DetailNewsViewController: UIViewController {
    //Create subView for Detail View
    private let newsTitleLabel = UILabel()
    private let newsImageView = UIImageView()
    private let newsDescription = UILabel()
    private let newsDatePublication = UILabel()
    private let newsSourcePublication = UILabel()
    private let newsUrl = UILabel()
    private let webView = WKWebView()
    
    var article: Article?
    var imageData: NewsTableViewCellViewModel?
    //Create space for leading & trailing
    private let spacing: CGFloat = 12.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Summary"
        configureDetailNewsViewController()
    }
    //MARK: - Create Detail News View
    private func configureDetailNewsViewController() {
        //MARK: - Create News Title Label
        view.addSubview(newsTitleLabel)
        newsTitleLabel.numberOfLines = 0
        newsTitleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        newsTitleLabel.text = article?.title
        //Make constraints
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            newsTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            newsTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
        //MARK: - Create News Image View
        view.addSubview(newsImageView)
        newsImageView.layer.cornerRadius = 10
        newsImageView.clipsToBounds = true
        newsImageView.layer.masksToBounds = true
        newsImageView.backgroundColor = .secondarySystemBackground
        newsImageView.contentMode = .scaleAspectFill
        if let data = imageData?.imageData {
            newsImageView.image = UIImage(data: data)
        }
        //Make constraints
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            newsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            newsImageView.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: spacing),
            newsImageView.heightAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 9/16)
        ])
        //MARK: - Create News Description Label
        view.addSubview(newsDescription)
        newsDescription.numberOfLines = 0
        newsDescription.font = .systemFont(ofSize: 16, weight: .regular)
        newsDescription.text = article?.description
        //Make constraints
        newsDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            newsDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            newsDescription.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: spacing),
            
        ])
        //MARK: - Create Date Publication Label
        view.addSubview(newsDatePublication)
        newsDatePublication.numberOfLines = 1
        newsDatePublication.font = .systemFont(ofSize: 16, weight: .regular)
        newsDatePublication.text = "Date publication: \(article?.publishedAt ?? "00.00.00")"
        //Make constraints
        newsDatePublication.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsDatePublication.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            newsDatePublication.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            newsDatePublication.topAnchor.constraint(equalTo: newsDescription.bottomAnchor, constant: spacing),
            
        ])
        //MARK: - Create Source Label
        view.addSubview(newsSourcePublication)
        newsSourcePublication.numberOfLines = 1
        newsSourcePublication.font = .systemFont(ofSize: 16, weight: .regular)
        newsSourcePublication.text = "Source: \(article?.source.name ?? "undefined")"
        //Make constraints
        newsSourcePublication.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsSourcePublication.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            newsSourcePublication.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            newsSourcePublication.topAnchor.constraint(equalTo: newsDatePublication.bottomAnchor, constant: spacing),
        ])
        //MARK: - Create URL Label
        newsUrl.text = article?.url
        newsUrl.isUserInteractionEnabled = true
        newsUrl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        view.addSubview(newsUrl)
        newsUrl.numberOfLines = 0
        newsUrl.textColor = .systemBlue
        newsUrl.font = .italicSystemFont(ofSize: 16)
        //Make constraints
        newsUrl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsUrl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            newsUrl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            newsUrl.topAnchor.constraint(equalTo: newsSourcePublication.bottomAnchor, constant: spacing),
        ])
    }
    //MARK: - Jump to Source URL
    @objc func tap() {
        guard let url = URL(string: newsUrl.text ?? "") else { return }
        let request = URLRequest(url: url)
        let webView = NewsWebView()
        webView.request = request
        navigationController?.pushViewController(webView, animated: true)
    }
}
