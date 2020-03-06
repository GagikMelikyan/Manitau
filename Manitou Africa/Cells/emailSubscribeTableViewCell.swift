//
//  emailSubscribeTableViewCell.swift
//  Manitou Africa
//
//  Created by User on 6/3/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

class emailSubscribeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellSwitch.layer.cornerRadius = cellSwitch.frame.height / 2
        cellSwitch.backgroundColor = .red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
