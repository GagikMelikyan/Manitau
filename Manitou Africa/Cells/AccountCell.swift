//
//  AccountCell.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 2/14/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {
    
    @IBOutlet var accountImage: UIImageView!
    @IBOutlet var accountTextField: UITextField!
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
