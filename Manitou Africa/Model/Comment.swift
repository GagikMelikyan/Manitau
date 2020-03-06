//
//  Comment.swift
//  Manitou Africa
//
//  Created by Karen Madoyan on 6/12/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import Foundation

struct Comment: Codable {
    
    let author: User
    let publishedAt: String
    let content: String
}
