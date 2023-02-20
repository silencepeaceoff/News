//
//  UIViewExt.swift
//  News
//
//  Created by Dmitrii Tikhomirov on 2/10/23.
//

import UIKit

extension UIView {
    
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            topAnchor.constraint(equalTo: superView.topAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }
}
