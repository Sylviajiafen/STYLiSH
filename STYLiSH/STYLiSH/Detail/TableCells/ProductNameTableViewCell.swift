//
//  ProductNameTableViewCell.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/20.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class ProductNameTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
