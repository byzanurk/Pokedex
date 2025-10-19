//
//  ItemTableViewCell.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 19.10.2025.
//


import UIKit
import Kingfisher

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .default
        accessoryType = .disclosureIndicator
        itemName.font = .pixel14
        itemName.textColor = .white
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemName.text = nil
    }
    
    // Basit configure: başlık ve opsiyonel görsel URL
    func configure(title: String, iconURL: URL?) {
        itemName.text = title
        if let url = iconURL {
            itemImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "shippingbox"))
        } else {
            itemImageView.image = UIImage(systemName: "shippingbox")
        }
    }
}