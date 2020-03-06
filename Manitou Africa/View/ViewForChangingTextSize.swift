//
//  ViewForChangingTextSize.swift
//  Manitou Africa
//
//  Created by User on 6/5/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

protocol ViewForChangingTextSizeDelegete: class {
    func closeChangeSizeView()
    func changeTextSize(fontSize: Int)
    func changeChoosenSize(size: String?)
}

class ViewForChangingTextSize: UIView {

    @IBOutlet weak var fontSizeView: UIView!
    @IBOutlet weak var fontSizeViewTitle: UILabel!
    @IBOutlet var sizeViews: [UIView]!
    @IBOutlet weak var smallSizeLabel: UILabel!
    @IBOutlet weak var normalSizeLabel: UILabel!
    @IBOutlet weak var largeSizeLabel: UILabel!
    
    weak var delegate: ViewForChangingTextSizeDelegete?
    
    var choosenSize: String?
    private var fontSize = 15

     func configurFontSizeView() {
        smallSizeLabel.text = "small".localized
        normalSizeLabel.text = "normal".localized
        largeSizeLabel.text = "large".localized
        fontSizeViewTitle.text = "chooseSize".localized
        var viewId = ""
        if let size = choosenSize {
            viewId = "\(size)" + "View"
        } else {
            viewId = "normalView"
        }
        for view in sizeViews {
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 1
            view.layer.cornerRadius = view.frame.size.height / 5
            view.alpha = 0.4
            if  view.restorationIdentifier == viewId {
                view.alpha = 1
            }
        }
    }
    
    @IBAction func chooseSize(_ sender: UIButton) {
        choosenSize = sender.restorationIdentifier ?? nil
        switch choosenSize {
        case "normal":
            fontSize = 15
        case "small":
            fontSize = 13
        case "large":
            fontSize = 17
        default:
            fontSize = 15
        }

        delegate?.changeChoosenSize(size: choosenSize)
        delegate?.changeTextSize(fontSize: fontSize)
        delegate?.closeChangeSizeView()
        fontSizeView.alpha = 0
    }
    
    
}
