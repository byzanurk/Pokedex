//
//  ItemTableViewCell.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 19.10.2025.
//

import UIKit
import Kingfisher

final class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .default
        accessoryType = .disclosureIndicator
        
        itemNameLabel.font = .pixel14
        itemNameLabel.textColor = .white
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.layer.masksToBounds = true
        
        subtitleLabel.font = .pixel14
        subtitleLabel.textColor = .lightGray
        subtitleLabel.numberOfLines = 0
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemNameLabel.text = nil
        subtitleLabel.text = nil
        subtitleLabel.isHidden = true
    }
    
    func configure(title: String, iconURL: URL?, subtitle: String?) {
        itemNameLabel.text = title
        
        if let url = iconURL {
            itemImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "shippingbox"))
        } else {
            itemImageView.image = UIImage(systemName: "shippingbox")
        }
        
        if let subtitle, !subtitle.isEmpty {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.text = nil
            subtitleLabel.isHidden = true
        }
    }
}
