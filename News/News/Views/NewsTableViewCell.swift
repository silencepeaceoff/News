//
//  NewsTableViewCell.swift
//  News
//
//  Created by Dmitrii Tikhomirov on 2/10/23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    private let newsImageView = UIImageView()
    private let newsTitleLabel = UILabel()
    var viewsCounter = UILabel()
    
    static let identifier = "NewsTableViewCell"

    private let spacing: CGFloat = 12.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(newsImageView)
        addSubview(newsTitleLabel)
        addSubview(viewsCounter)
        
        configureNewsImageView()
        configureNewsTitleLabel()
        configureNewsViewsCounter()
        
        setNewsImageViewConstraints()
        setNewsTitleLabelConstraints()
        setViewsCounterConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNewsImageView() {
        newsImageView.layer.cornerRadius = 10
        newsImageView.clipsToBounds = true
        newsImageView.layer.masksToBounds = true
        newsImageView.backgroundColor = .secondarySystemBackground
        newsImageView.contentMode = .scaleAspectFill
    }
    
    private func configureNewsTitleLabel() {
        newsTitleLabel.numberOfLines = 0
        newsTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        newsTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func configureNewsViewsCounter() {
        viewsCounter.numberOfLines = 1
        viewsCounter.font = .systemFont(ofSize: 10, weight: .regular)
        viewsCounter.adjustsFontSizeToFitWidth = true
        viewsCounter.textAlignment = NSTextAlignment.right
    }
    
    private func setNewsImageViewConstraints() {
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            newsImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            newsImageView.heightAnchor.constraint(equalToConstant: 90),
            newsImageView.widthAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 16/9)
        ])
    }
    
    private func setNewsTitleLabelConstraints() {
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: spacing),
            newsTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            newsTitleLabel.heightAnchor.constraint(equalToConstant: 78),
            newsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing)
        ])
    }
    
    private func setViewsCounterConstraints() {
        viewsCounter.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewsCounter.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: spacing),
            viewsCounter.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 2),
            viewsCounter.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewsCounter.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
        newsTitleLabel.text = nil
    }
    //MARK: - Save Data to Cache
    private func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let urlRequest = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
    //MARK: - Get Data from Cache
    private func getCachedImage(from url: URL) -> UIImage? {
        let urlRequest = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
    //MARK: - Configure Table Cell
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        //Load Image from Cache
        guard let url = viewModel.imageURL else { return }
        if let cachedImage = getCachedImage(from: url) {
            newsImageView.image = cachedImage
        }
        //Fetch Data
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let response = response, error == nil else {
                return
            }
            
            guard url == response.url else { return }
            DispatchQueue.main.async {
                self?.newsImageView.image = UIImage(data: data)
            }
            
            viewModel.imageData = data
            //Save to cache Image Data
            self?.saveDataToCache(with: data, and: response)
        }
        .resume()
    }
}
