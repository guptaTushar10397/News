//
//  HomeTableViewCell.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // API date format
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetUIElements()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetUIElements()
    }
}

private extension HomeTableViewCell {
    
    func resetUIElements() {
        iconImageView.image = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
    }
}

extension HomeTableViewCell {
    
    func configureDataWithModel(_ modelData: Docs) {
        // Description
        descriptionLabel.text = modelData.abstract
    
        // Date
        if let pubDate = modelData.pubDate, 
            !pubDate.isEmpty,
           let date = DateFormatterProvider.pubDateFormatter.date(from: pubDate) {
            dateLabel.text = date.monthYearFormatted
        }
        
        // Image
        if let urlString = modelData.multimedia?.first?.url,
           let url = URL(string: baseURL + "/\(urlString)") {
            iconImageView.setImage(withURL: url)
        }
    }
}
