//
//  ArticlesController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 5/31/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

class ArticlesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchingTextLabel: UILabel!
    @IBOutlet weak var currentSearchTextLabel: UILabel!
    
    var languageLabel: UILabel?
    var arrayOfArticles = [Member] ()
    var searchingText: String?
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlesCell", for: indexPath) as! ArticlesCell
        
        let urlString = URL_BASE_FOR_IMAGES + "\(arrayOfArticles[indexPath.row].imageFeatured)"
        let url = URL(string: urlString)
        
        cell.articleImage.load(url: url!)
        cell.articleTitle.text = arrayOfArticles[indexPath.row].title
        cell.articleContent.text = arrayOfArticles[indexPath.row].content.htmlToString
        
        let firstName = arrayOfArticles[indexPath.row].author.firstName
        let lastName = arrayOfArticles[indexPath.row].author.lastName
        let firstSurnameLetter = lastName.prefix(1)
        let country =  arrayOfArticles[indexPath.row].author.country
        let authorInfo = "by".localized + " \(firstName) \(firstSurnameLetter). \("-") \(country)"
        cell.articleAuthor.text = authorInfo
        
        var convertedDate: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "dateFormat".localized
        
        let dateTime = arrayOfArticles[indexPath.row].publishedAt
        let dateComponents = dateTime.components(separatedBy: "T")
        
        let splitDate = dateComponents[0]
        
        if let date = dateFormatter.date(from: splitDate) {
            convertedDate = newDateFormatter.string(from: date)
        }
        cell.articleDate.text = "on".localized + " \(convertedDate)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchingText != nil ? 0 : 20
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 10
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 5
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 10, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        tableView.backgroundColor = UIColor.groupTableViewBackground
        
        self.showActivityIndicator(show: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notCommentableArticleVC : SingleArticleController = self.storyboard?.instantiateViewController(withIdentifier: "SingleArticleController") as! SingleArticleController
        notCommentableArticleVC.urlForArticle = arrayOfArticles[indexPath.row].id
        
        let commentableArticleVC : ArticleController = self.storyboard?.instantiateViewController(withIdentifier: "ArticleController") as! ArticleController
        commentableArticleVC.urlForArticle = arrayOfArticles[indexPath.row].id
        
        let category = arrayOfArticles[indexPath.row].category
        if category == "page" {
            self.presentOnRoot(with: notCommentableArticleVC)
            
        } else if category == "post" {
            self.presentOnRoot(with: commentableArticleVC)
        }
    }
    
    private func configureView() {
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        self.showActivityIndicator(show: true)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //        tableView.rowHeight = UITableView.automaticDimension
        //        tableView.estimatedRowHeight = 600
        
        setLeftBarButtonItems()
        setRightBarButtonItems()
        addShadowToTheNavigationBar()
        
        if let searchText = searchingText {
            searchViewHeightConstraint.constant = 55
            searchingTextLabel.text = "searchResultsFor".localized
            currentSearchTextLabel.text = searchText
        } else {
            getArticles()
        }
        
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
    
    @objc func didTapMenuButton()  {
        self.dismiss(animated: true, completion: nil)
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
            self.searchingTextLabel.text = "searchResultsFor".localized
            self.tableView?.reloadData()
        })
    }
    
    private func addShadowToTheNavigationBar() {
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(red: 195/255.0, green: 195/255.0, blue: 195/255.0, alpha: 1).cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
    }
    
    // MARK: - Activity Indicator
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func getArticles() {
        APIManager.sharedInstance.getArticles { (news, error) in
            if let error = error {
                // got an error in getting the data
                print(error)
                return
            }
            guard let news = news else {
                print("error getting all news: result is nil")
                return
            }
            
            let articles = news.member
            for article in articles {
                self.arrayOfArticles.append(article)
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()
            })
        }
    }
    
}
