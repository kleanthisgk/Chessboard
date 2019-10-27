//
//  ResultTableViewCell.swift
//  Chessboard
//
//  Created by Marsel Tzatzo on 27/10/2019.
//  Copyright © 2019 Kleanthis Gkergki. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    @IBOutlet weak var resultextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
