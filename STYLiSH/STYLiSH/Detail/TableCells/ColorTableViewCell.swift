//
//  ColorTableViewCell.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/21.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    @IBOutlet weak var colorDescriptLabel: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
