//
//  Validations.swift
//  Manitou Africa
//
//  Created by Karen Madoyan on 6/5/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import Foundation

class Validations {
    
    class func isTextFieldTextEmpty(_ text:String?)->Bool {
        if text != nil || text != "" {
            return text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
        }
        return true
    }
    
    class func isValidEmail(_ testStr:String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidPassword(_ testStr:String?) -> Bool {
        let passRegEx = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%&*()]).{8,}$"
        let passTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passTest.evaluate(with: testStr)
    }
}
