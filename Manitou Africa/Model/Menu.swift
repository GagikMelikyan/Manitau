//
//  Menu.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 5/28/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import Foundation
import UIKit

struct Menu {
    
    var menuName: String?
    var isExpandable: Bool = false
    
    
    init(menuName: String, isExpandable: Bool) {
        self.menuName = menuName
        self.isExpandable = isExpandable
    }
}
