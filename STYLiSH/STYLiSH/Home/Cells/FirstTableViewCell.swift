//
//  FirstTableViewCell.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/12.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class FirstTableViewCell: UITableViewCell {

    @IBOutlet weak var firstCellImage: UIImageView!
    @IBOutlet weak var firstCellLabelTitle: UILabel!
    @IBOutlet weak var firstCellLabelContent: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
