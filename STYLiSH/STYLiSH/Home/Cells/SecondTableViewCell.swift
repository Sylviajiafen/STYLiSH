//
//  SecondTableViewCell.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/12.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {
    @IBOutlet weak var secondCellImageLeft: UIImageView!
    @IBOutlet weak var secondCellImageMidUp: UIImageView!
    @IBOutlet weak var seconCellImageMidDown: UIImageView!
    @IBOutlet weak var secondCellImageRight: UIImageView!
    @IBOutlet weak var secondCellLabelTitle: UILabel!
    @IBOutlet weak var secondCellLabelContent: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
