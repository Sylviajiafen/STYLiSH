//
//  DetailTableViewCell.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/20.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var textureLabel: UILabel!
    @IBOutlet weak var laundryLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
