//
//  ResultsCell.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 3/22/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

class ResultsCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var firstImage: UIImageView!
    @IBOutlet var secondImage: UIImageView!
    @IBOutlet var thirdImage: UIImageView!
    @IBOutlet var forthImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
//        let separatorLine = UIView(frame: CGRect(x: 37, y: contentView.frame.size.height - 0.4, width: contentView.frame.size.width, height: 0.4))
//        separatorLine.backgroundColor = UIColor.lightGray
//        contentView.addSubview(separatorLine)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
