//
//  OrderCell.swift
//  GroupOrdersEricApp1
//
//  Created by user on 2020/8/28.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var mixinLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var picImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
