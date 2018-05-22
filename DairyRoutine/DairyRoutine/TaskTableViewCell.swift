//
//  TaskTableViewCell.swift
//  Hello World
//
//  Created by Qing Zhang on 5/21/18.
//  Copyright © 2018 Qing Zhang. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet weak var nameImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
