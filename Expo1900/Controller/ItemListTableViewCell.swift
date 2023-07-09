//
//  ItemListTableViewCell.swift
//  Expo1900
//
//  Created by 1 on 2023/07/03.
//

import UIKit

class ItemListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var shortDescriptionLabel: UILabel!
    
    func setModel(_ items: Item) {
        itemImageView.image = UIImage(named: items.imageName)
        titleLabel.text = items.name
        shortDescriptionLabel.text = items.shortDescription
    }
}
