//
//  CommentsController.swift
//  Manitou Africa
//
//  Created by User on 6/7/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit
import SideMenuSwift

class CommentsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var newCommentTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var languageLabel: UILabel?
    var commentsPath: [String] = []
    var articleTitle: String?
    var articleUrl: String?
    var userData: User?
    
    private var comments = [Comment]()
    
    let UserId = UserDefaults.standard.integer(forKey: "UserIdKey")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        getComment()
        startObservingKeyboardChanges()
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentsController.dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        cell.dateLabel.text = comments[indexPath.row].publishedAt.converteDate()
        cell.contentLabel.text = comments[indexPath.row].content
        var firstLetterOfLastName: String {
            if let firstletter = comments[indexPath.row].author.lastName.first {
                return String(firstletter) + "."
            } else {
                return ""
            }
        }
        
        var country: String {
            if comments[indexPath.row].author.dealershipName == "" {
                return ""
            } else {
                return "- " + "\(comments[indexPath.row].author.dealershipName)"
            }
        }
        cell.authorLabel.text = "\(comments[indexPath.row].author.firstName) " + "\(firstLetterOfLastName ) " + country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 10
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 5
        maskLayer.backgroundColor = UIColor.lightGray.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 10, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        tableView.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    private func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        //        tableView.rowHeight = UITableView.automaticDimension
        //        tableView.estimatedRowHeight = 600
        
        setLeftBarButtonItems()
        setRightBarButtonItems()
        addShadowToTheNavigationBar()
        //        getArticles()
        
    }
    
    // Make settings of leftBarButtonItems
    func setLeftBarButtonItems() {
        let menuImage = UIImage(named: "Menu")!
        let menuBtn: UIButton = UIButton.init(type: .custom)
        menuBtn.setImage(menuImage, for: UIControl.State.normal)
        menuBtn.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let menuBarBtn = UIBarButtonItem(customView: menuBtn)
        
        let logoImage = UIImage.init(named: "manitou-logo-black")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        navigationItem.setLeftBarButtonItems([menuBarBtn, imageItem], animated: false)
    }
    
    // Make settings of rightBarButtonItems
    func setRightBarButtonItems() {
        let profImage = UIImage(named: "User_user")!
        let profButton : UIButton = UIButton.init(type: .custom)
        profButton.setImage(profImage, for: .normal)
        profButton.addTarget(self, action: #selector(didTapAccountButton), for: .touchUpInside)
        profButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let profBarButton = UIBarButtonItem(customView: profButton)
        
        languageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 24, height: 22))
        languageLabel?.text = "flagText".localized
        languageLabel?.textColor = .black
        languageLabel?.font = UIFont(name: "NotoSans", size: 18)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLanguageSettings(tapGestureRecognizer:)))
        languageLabel?.isUserInteractionEnabled = true
        languageLabel?.addGestureRecognizer(tapGestureRecognizer)
        let labelLanguage = UIBarButtonItem(customView: languageLabel!)
        
        navigationItem.setRightBarButtonItems([profBarButton, labelLanguage], animated: false)
    }
    
    @IBAction func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapMenuButton()  {
        sideMenuController?.revealMenu()
        //        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func didTapAccountButton()  {
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountNavigationController") as! AccountNavigationController
        self.present(accountVC, animated: true, completion: nil)
    }
    
    @objc func didTapLanguageSettings(tapGestureRecognizer: UITapGestureRecognizer)  {
        
        if UserDefaults.standard.string(forKey: "language_settings") == "fr" {
            UserDefaults.standard.set("en", forKey: "language_settings")
        } else {
            UserDefaults.standard.set("fr", forKey: "language_settings")
        }
        
        updateUI()
    }
    
    private func updateUI() {
        languageLabel?.text = "flagText".localized
        DispatchQueue.main.async(execute: {
            self.tableView?.reloadData()
        })
        pageTitle.text = articleTitle?.localized
        
        postButton.setTitle("post".localized, for: .normal)
        newCommentTextField.placeholder = "writeComment".localized
        if commentsPath.count < 2 {
            commentsCountLabel.text = "\(commentsPath.count) " + "comment".localized
        } else {
            commentsCountLabel.text = "\(commentsPath.count) " + "comments".localized
        }
    }
    
    private func addShadowToTheNavigationBar() {
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(red: 195/255.0, green: 195/255.0, blue: 195/255.0, alpha: 1).cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
    }
    
    func getComment() {
        comments = []
        for commentPath in commentsPath {
            APIManager.sharedInstance.getCommentData(urlForComment: commentPath) { (comment, error) in
                if let error = error {
                    // got an error in getting the data
                    print(error)
                    return
                }
                guard let comment = comment else {
                    print("error getting all news: result is nil")
                    return
                }
                self.comments.append(comment)
                
            }
        }
    }
    
    // NotificationCenter observers
    private func startObservingKeyboardChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                //                self.view.frame.origin.y -= keyboardSize.height / 2
                self.bottomConstraint.constant += keyboardSize.height + 20
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = 8
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.bottomConstraint.constant = 8
    }
    
    // post comment
    @IBAction func addComment() {
        
        if newCommentTextField.text != "" && articleUrl != nil {
            let commentAuthor = "/v1/users/" + "\(UserId)"
            let content = newCommentTextField.text!
            let parameters = ["author" : commentAuthor, "content" : content, "post" : articleUrl!]
            
            submitPost(post: parameters) { (error) in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    private func submitPost(post: [String: String], completion:((Error?) -> Void)?) {
        
        guard let url = URL(string: "https://api.challengeafrica-manitou.com/v1/comments") else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(post)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion?(responseError!)
                return
            }
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                self.getArticle()
                print("response: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
        
    }
    
    func getArticle() {
        APIManager.sharedInstance.getSingleArticleData(urlForArticle: articleUrl!) { (article, error) in
            if let error = error {
                // got an error in getting the data
                print(error)
                return
            }
            guard let article = article else {
                print("error getting article: result is nil")
                return
            }
            // success :)
            self.commentsPath = article.comments
            self.getComment()
            DispatchQueue.main.async {
                self.newCommentTextField.text = ""
                if self.commentsPath.count < 2 {
                    self.commentsCountLabel.text = "\(self.commentsPath.count) " + "comment".localized
                } else {
                    self.commentsCountLabel.text = "\(self.commentsPath.count) " + "comments".localized
                }
            }
            
        }
    }
    
}
