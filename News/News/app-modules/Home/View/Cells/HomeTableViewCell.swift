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
        descriptionLabel.text = modelData.abstract
        guard let urlString = modelData.multimedia?.first?.url,
        let url = URL(string: baseURL + "/\(urlString)") else { return }
        
        iconImageView.setImage(withURL: url)
    }
}
