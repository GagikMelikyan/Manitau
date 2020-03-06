//
//  APIManager.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 4/16/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import Foundation
import UIKit

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}

var URL_BASE: String {
    return "https://api.challengeafrica-manitou.com"
}
var URL_BASE_API: String {
    return "https://api.ios.challengeafrica-manitou.com"
}
var API_VERSION: String {
    return "v1"
}

var URL_BASE_FOR_IMAGES: String {
    return URL_BASE + "/medias/images/"
}

class APIManager {
    
    static let sharedInstance = APIManager()
    private init() { }
    
    var statusCode: Int?
    let tokenId = UserDefaults.standard.string(forKey: "accessTokenKey") ?? ""
    
    func getUser(_ id: Int, completionHandler: @escaping (User?, Error?) -> Void) {
        
        guard let url = URL(string: URL_BASE_API + "/" + API_VERSION + "/users/\(id)") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not create URL")
            completionHandler(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["Bearer Token \(tokenId)"] = "Authorization"
        urlRequest.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error!)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: responseData)
                completionHandler(user, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        })
        task.resume()
    }
    
    //completion: ((Error?, _ statusCode: Int?, _ errorMessage: String?) -> Void)?)
    
    func submitLogin(login: Auth, completion: @escaping (Error?, _ statusCode: Int?, _ jsonResponse: [String : Any]? ) -> Void) {
        
        guard let url = URL(string: URL_BASE_API + "/" + API_VERSION + "/login_check") else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(login)
            
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion(error, nil, nil)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            if let error = responseError {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    self.statusCode = response.statusCode
                    //print("statusCode: \(response.statusCode)")
                    //completion(nil, response.statusCode)
                }
            }
            
            do {
                if let stringDict = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String : Any] {
                    
                    completion(nil, self.statusCode, stringDict)
                    let defaults = UserDefaults.standard
                    
                    if let userId: Int = stringDict["cid"] as? Int {
                        defaults.set(userId, forKey: "UserIdKey")
                    }
                    
                    if let accessToken: String = stringDict["token"] as? String {
                        defaults.set(accessToken, forKey: "accessTokenKey")
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        task.resume()
    }
    
    func submitChangedData(_ id: Int, changableData: ChangableData, completion:((Error?, _ statusCode: Int?) -> Void)?) {
        guard let url = URL(string: URL_BASE_API + "/" + API_VERSION + "/users/\(id)") else {
            fatalError("Could not create URL from components")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        headers["Bearer Token \(tokenId)"] = "Authorization"
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(changableData)
            
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error, nil)
        }
        
        // Create and run a URLSession data task with our JSON encoded PUT request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            if let error = responseError {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    completion!(nil, response.statusCode)
                }
            }
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func getFeaturedNews(completionHandler: @escaping (News?, Error?) -> Void) {
        
        guard let url = URL(string: URL_BASE_API + "/" + API_VERSION + "/posts?category=post&isFeatured=true&isPublished=true") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        headers["Bearer Token \(tokenId)"] = "Authorization"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let posts = try decoder.decode(News.self, from: responseData)
                completionHandler(posts, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getNotFeaturedNews(completionHandler: @escaping (News?, Error?) -> Void) {
        
        guard let url = URL(string: URL_BASE_API + "/" + API_VERSION + "/posts?category=post&isFeatured=false&isPublished=true") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        headers["Bearer Token \(tokenId)"] = "Authorization"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let posts = try decoder.decode(News.self, from: responseData)
                completionHandler(posts, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getArticles(completionHandler: @escaping (News?, Error?) -> Void) {
        
        guard let url = URL(string: URL_BASE_API + "/" + API_VERSION + "/posts?category=page&isFeatured=false&isPublished=true") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        headers["Bearer Token \(tokenId)"] = "Authorization"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let posts = try decoder.decode(News.self, from: responseData)
                completionHandler(posts, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getSingleArticleData(urlForArticle: String, completionHandler: @escaping (Article?, Error?) -> Void ) {
        guard let url = URL(string: URL_BASE_API + "\(urlForArticle)") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        headers["Bearer Token \(tokenId)"] = "Authorization"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let article = try decoder.decode(Article.self, from: responseData)
                completionHandler(article, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getSlides(completionHandler: @escaping (Headline?, Error?) -> Void) {
        
        guard let url = URL(string: URL_BASE_API + "/" + API_VERSION + "/posts?isPublished=true&category=slide") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        headers["Bearer Token \(tokenId)"] = "Authorization"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let posts = try decoder.decode(Headline.self, from: responseData)
                completionHandler(posts, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    
    func getCommentData(urlForComment: String, completionHandler: @escaping (Comment?, Error?) -> Void) {
        guard let url = URL(string: URL_BASE_API + "\(urlForComment)") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        headers["Bearer Token \(tokenId)"] = "Authorization"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let comment = try decoder.decode(Comment.self, from: responseData)
                completionHandler(comment, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
                
    func submitTermsAndConditions(cgu: Cgu, _ id: Int, completion: @escaping (Error?, _ statusCode: Int?) -> Void) {
        guard let url = URL(string: URL_BASE_API + "/" + API_VERSION + "/users/\(id)") else {
            fatalError("Could not create URL from components")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        headers["Bearer Token \(tokenId)"] = "Authorization"
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(cgu)
            
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion(error, nil)
        }
        
        // Create and run a URLSession data task with our JSON encoded PUT request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            if let error = responseError {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    completion(nil, response.statusCode)
                }
            }
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    

    func getAllArticles(completionHandler: @escaping (News?, Error?) -> Void) {
        
        guard let url = URL(string: URL_BASE + "/" + API_VERSION + "/posts?isPublished=true") else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        headers["Bearer Token \(tokenId)"] = "Authorization"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let posts = try decoder.decode(News.self, from: responseData)
                completionHandler(posts, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getDropdownValues(url: String, completionHandler: @escaping ([DropdownValue]?, Error?) -> Void) {
        
        guard let urlString = URL(string: url) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: urlString)
        
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        headers["Bearer Token \(tokenId)"] = "Authorization"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let values = try decoder.decode([DropdownValue].self, from: responseData)
                completionHandler(values, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getRankingValues(url: String, completionHandler: @escaping ([RankingValue]?, Error?) -> Void) {
        
        guard let urlString = URL(string: url) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: urlString)
        
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        headers["Bearer Token \(tokenId)"] = "Authorization"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let values = try decoder.decode([RankingValue].self, from: responseData)
                completionHandler(values, nil)
            } catch {
                print("error trying to convert ranking data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
}


