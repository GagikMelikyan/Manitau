//
//  News.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 4/24/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import Foundation
import UIKit

struct News: Codable {
    
    let member: [Member]
    
    private enum CodingKeys : String, CodingKey {
        case member = "hydra:member"
    }
}

struct Member: Codable {
    let id: String
    let title: String
    let content: String
    let imageFeatured: String
    let author: User
    let category: String
    let publishedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "@id"
        case title, content, imageFeatured, author, category, publishedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        imageFeatured = try container.decode(String.self, forKey: .imageFeatured)
        author = try container.decode(User.self, forKey: .author)
        category = try container.decode(String.self, forKey: .category)
        publishedAt = try container.decode(String.self, forKey: .publishedAt)
    }
}
