//
//  SectionHeaderView.swift
//  tableview
//
//  Created by Ақерке Амиртай on 15.11.2025.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "SectionHeaderView"
    
    private let titleLabel = UILabel()
    private let iconLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconLabel)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    func configure(title: String, icon: String) {
        titleLabel.text = title
        iconLabel.text = icon
    }
}
