//
//  HomeController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 1/22/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit
import SideMenuSwift

var languageLabel: UILabel?
var headerLabel: UILabel?
var authorForFeatured: String?
var authorForNotFeatured: String?

class HomeController: UITableViewController, SuccessMessageDelegate {
    
    var activityIndicator: UIActivityIndicatorView!
    
    var arrayOfFeaturedObjects = [Member] ()
    var arrayOfNotFeaturedObjects = [Member] ()
    var btn = UIButton(type: .custom)
    
    var isPostSuccess = false
    var postSuccessMessage = ""
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        
        view.addSubview(activityIndicator)
        
        self.showActivityIndicator(show: true)
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        floatingButton()
        if self.isPostSuccess {
            configurePostSuccessMessageButtomView(message: postSuccessMessage)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        btn.removeFromSuperview()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrayOfFeaturedObjects.count + arrayOfNotFeaturedObjects.count)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < arrayOfFeaturedObjects.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as! HomeScreenFirstCell
            
            let urlString = URL_BASE_FOR_IMAGES + "\(arrayOfFeaturedObjects[indexPath.row].imageFeatured)"
            let url = URL(string: urlString)
            
            cell.mainImageView.load(url: url!)
            cell.titleLabel.text = arrayOfFeaturedObjects[indexPath.row].title
            cell.contentLabel.text = arrayOfFeaturedObjects[indexPath.row].content.htmlToString
            
            let firstName = arrayOfFeaturedObjects[indexPath.row].author.firstName
            let lastName = arrayOfFeaturedObjects[indexPath.row].author.lastName
            let firstSurnameLetter = lastName.prefix(1)
            let country = arrayOfFeaturedObjects[indexPath.row].author.country
            let authorInfo = "by".localized + " \(firstName) \(firstSurnameLetter). \("-") \(country)"
            cell.authorLabel.text = authorInfo
            
            var convertedDate: String = ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "dateFormat".localized
            
            let dateTime = arrayOfFeaturedObjects[indexPath.row].publishedAt
            let dateComponents = dateTime.components(separatedBy: "T")
            
            let splitDate = dateComponents[0]
            
            if let date = dateFormatter.date(from: splitDate) {
                convertedDate = newDateFormatter.string(from: date)
            }
            cell.dateLabel.text = "on".localized + " \(convertedDate)"
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as! HomeScreenSecondCell
            
            let secondData = arrayOfNotFeaturedObjects[indexPath.row - arrayOfFeaturedObjects.count]
            
            let urlString = URL_BASE_FOR_IMAGES + "\(secondData.imageFeatured)"
            let url = URL(string: urlString)
            
            cell.mainImageView.load(url: url!)
            cell.titleLabel.text = secondData.title
            cell.contentLabel.text = secondData.content.htmlToString
            
            let firstName = secondData.author.firstName
            let lastName = secondData.author.lastName
            let firstSurnameLetter = lastName.prefix(1)
            let country = secondData.author.country
            let authorInfo = "by".localized + " \(firstName) \(firstSurnameLetter). \("-") \(country)"
            cell.authorLabel.text = authorInfo
            
            var convertedDate: String = ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "dateFormat".localized
            
            let dateTime = secondData.publishedAt
            let dateComponents = dateTime.components(separatedBy: "T")
            
            let splitDate = dateComponents[0]
            
            if let date = dateFormatter.date(from: splitDate) {
                convertedDate = newDateFormatter.string(from: date)
            }
            cell.dateLabel.text = "on".localized + " \(convertedDate)"
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 12
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 5
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 10, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        tableView.backgroundColor = UIColor.groupTableViewBackground
        
        self.showActivityIndicator(show: false)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleNVC = self.storyboard?.instantiateViewController(withIdentifier: "ArticleNavigationController") as! ArticleNavigationController
        
        let articleVC = articleNVC.viewControllers.first as! ArticleController
        if indexPath.row < arrayOfFeaturedObjects.count {
            articleVC.urlForArticle = arrayOfFeaturedObjects[indexPath.row].id
        } else {
            let data = arrayOfNotFeaturedObjects[indexPath.row - arrayOfFeaturedObjects.count]
            articleVC.urlForArticle = data.id
        }
        
        self.present(articleNVC, animated: true, completion: nil)
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
        sideMenuController?.revealMenu()
    }
    
    @objc func didTapAccountButton()  {
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountNavigationController") as! AccountNavigationController
        self.present(accountVC, animated: true, completion: nil)
    }
    
    // Click on label and push to View Controller
    func tapFunction() {
        let bottomMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "ArticleNavigationController") as! ArticleNavigationController
        self.present(bottomMenuVC, animated: true, completion: nil)
        
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
        
        //flagImageView?.image = UIImage(named: "flagImageName".localized)
    }
    
    // Make view settings
    private func configureView() {
        setLeftBarButtonItems()
        setRightBarButtonItems()
        addShadowToTheNavigationBar()
        getFeaturedPosts()
        getNotFeaturedPosts()
    }
    
    func floatingButton(){
        let image = UIImage(named: "pencil-icon") as UIImage?
        
        btn.frame = CGRect(x: self.view.frame.size.width - 70, y: self.view.frame.size.height - 60, width: 50, height: 50)
        btn.setImage(image, for: .normal)
        btn.backgroundColor = UIColor(red: 226/255.0, green: 0/255.0, blue: 26/255.0, alpha: 1)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = btn.layer.frame.size.width/2
        btn.addTarget(self,action: #selector(floatingButtonWasTapped), for: UIControl.Event.touchUpInside)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(btn)
        }
    }
    
    @objc private func floatingButtonWasTapped() {
        //        let newPostVC = self.storyboard?.instantiateViewController(withIdentifier: "NewPostNavigationController") as! NewPostNavigationController
        //        self.navigationController?.pushViewController(newPostVC, animated: true)
        performSegue(withIdentifier: "NewPostVCSegueIdentifier", sender: self)
    }
    
    private func addShadowToTheNavigationBar() {
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(red: 195/255.0, green: 195/255.0, blue: 195/255.0, alpha: 1).cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
    }
    
    func getFeaturedPosts() {
        APIManager.sharedInstance.getFeaturedNews { (posts, error) in
            if let error = error {
                // got an error in getting the data
                print(error)
                return
            }
            guard let posts = posts else {
                print("error getting all posts: result is nil")
                return
            }
            
            // success :)
            // debugPrint(posts)
            
            let featuredPosts = posts.member
            for featuredPost in featuredPosts {
                self.arrayOfFeaturedObjects.append(featuredPost)
                
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()
            })
        }
        
    }
    
    func getNotFeaturedPosts() {
        APIManager.sharedInstance.getNotFeaturedNews { (posts, error) in
            if let error = error {
                // got an error in getting the data
                print(error)
                return
            }
            guard let posts = posts else {
                print("error getting all posts: result is nil")
                return
            }
            
            // success :)
            // debugPrint(posts)
            
            let notFeaturedPosts = posts.member
            for notFeaturedPost in notFeaturedPosts {
                self.arrayOfNotFeaturedObjects.append(notFeaturedPost)
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()
            })
        }
        
    }
    
    func configurePostSuccessMessageButtomView (message: String) {
        let messageView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 60, width: self.view.frame.width, height: 60))
        messageView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.88)
        let messageLbl = UILabel(frame: CGRect(x: 16, y: 0, width: messageView.frame.width - 32, height: 60))
        messageLbl.backgroundColor = UIColor.clear
        messageLbl.textColor = UIColor.white
        messageLbl.text = message
        messageLbl.textAlignment = .center
        messageLbl.font = messageLbl.font.withSize(17)
        messageLbl.adjustsFontSizeToFitWidth = true
        messageLbl.minimumScaleFactor = 0.5
        messageView.addSubview(messageLbl)
        //        self.navigationController?.view.addSubview(messageView)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(messageView)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            messageView.removeFromSuperview()
            self.isPostSuccess = false
        }
    }
    
    func showSuccessMessage(_ controller: UIViewController, message: String) {
        self.isPostSuccess = true
        self.postSuccessMessage = message
        //        configurePostSuccessMessageButtomView(message: message)
        controller.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Activity Indicator
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewPostVCSegueIdentifier" {
            let newPostVC = segue.destination as! NewPostController
            newPostVC.delegate = self
        }
    }
}
