//
//  User.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 4/16/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var firstName: String
    var lastName: String
    var email: String
    var dealershipName: String
    var city: String
    var area: String
    var address: String
    var zip: String
    var password: String
    var gender: String
    var phone: String
    var newsletter: Bool
    var country: String
    
    enum CodingKeys : String, CodingKey {
        case firstName, lastName, email, dealershipName, city, area, address, zip, password, phone, newsletter, country
        case gender = "Civility"
    }
    
}
