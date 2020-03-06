//
//  ArticlesCell.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 5/31/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

class ArticlesCell: UITableViewCell {

    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var articleAuthor: UILabel!
    @IBOutlet var articleContent: UILabel!
    @IBOutlet var articleDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
