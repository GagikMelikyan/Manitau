//
//  ArticleRequestController.swift
//  Manitou Africa
//
//  Created by User on 6/18/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import Foundation

final class ArticleRequestController {
    static func getAllArticles(text: String, completion: @escaping ((News?) -> Void)) {
        APIManager.sharedInstance.getAllArticles { (news, error) in
            if error != nil {
                completion(nil)
            } else {
                completion(news)
            }
        }
    }
    
}
