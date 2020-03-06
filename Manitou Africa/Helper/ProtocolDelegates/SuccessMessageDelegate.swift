//
//  SuccessMessageDelegate.swift
//  Manitou Africa
//
//  Created by Karen Madoyan on 6/18/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import Foundation
import UIKit

protocol SuccessMessageDelegate : class {
    func showSuccessMessage(_ controller: UIViewController, message: String)
}
