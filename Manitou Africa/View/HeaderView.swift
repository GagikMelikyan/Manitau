//
//  HeaderView.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 5/28/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

protocol HeaderDelegate {
    func cellHeader(index: Int)
    func tapCell(index: Int)
}

class HeaderView: UIView {
    
    var delegate: HeaderDelegate?
    var sectionIndex: Int?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.addSubview(menuImage)
        self.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 155, y: 5
            , width: 180 , height: self.frame.height))
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(expandAndCollapseCell), for: .touchUpInside)
        
        return button
    }()
    
    lazy var menuImage: UIImageView = {
        let menuImage = UIImageView(frame: CGRect(x: 120, y: 10, width: 25, height: 25))
        
        return menuImage
    }()
    
    @objc func expandAndCollapseCell() {
        if let index = sectionIndex {
            delegate?.cellHeader(index: index)
            delegate?.tapCell(index: index)
            self.backgroundColor = .white
        }
    }
    
    
}
