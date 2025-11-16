//
//  FavoriteTableViewCell.swift
//  tableview
//
//  Created by Ақерке Амиртай on 15.11.2025.
//
import UIKit

class FavoriteTableViewCell: UITableViewCell {
    static let reuseIdentifier = "FavoriteTableViewCell"
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    func configure(with item: FavoriteItem) {
        itemImageView.image = item.image
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        reviewLabel.text = item.review
    }
}
