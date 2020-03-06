//
//  Article.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 5/7/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import Foundation
import UIKit

struct Article: Codable {
    
    let title: String
    let content: String
    let author: User
    let imageFeatured: String
    let publishedAt: String
    let comments: [String]
}
