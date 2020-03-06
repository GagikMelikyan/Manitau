//
//  Headline.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 6/4/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import Foundation

struct Headline: Codable {
    
    let member: [HeadlineMember]
    
    private enum CodingKeys : String, CodingKey {
        case member = "hydra:member"
    }
}

struct HeadlineMember: Codable {    
    let imageFeatured: String
}
