//
//  UIImageView+Extension.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import UIKit

extension UIImageView {
    
    func setImage(withURL url: URL) {
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
        
        
        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            self.image = cachedImage
            activityIndicator.stopAnimating()
            self.backgroundColor = .clear
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    self.backgroundColor = .clear
                }
                return
            }
            
            ImageCache.shared.save(image, forKey: url.absoluteString)
            
            DispatchQueue.main.async {
                self.image = image
                activityIndicator.stopAnimating()
                self.backgroundColor = .clear
            }
        }
    }
}
