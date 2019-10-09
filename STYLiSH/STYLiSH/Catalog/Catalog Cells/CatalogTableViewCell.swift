//
//  CatalogTableViewCell.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/16.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class CatalogTableViewCell: UITableViewCell {

    @IBOutlet weak var catalogImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
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
