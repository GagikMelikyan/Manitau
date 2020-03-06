//
//  SingleArticleController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 6/3/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

final class SingleArticleController: BaseSearchViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, ViewForChangingTextSizeDelegete {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var firstTabBarItem: UITabBarItem!
    @IBOutlet var secondTabBarItem: UITabBarItem!
    @IBOutlet var thirdTabBarItem: UITabBarItem!
    
    var articleData: Article?
    var urlForArticle = ""
    var fontSize = 15
    var choosenSize: String?
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    @IBAction func actionBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        
        cell.cellTitle.text = articleData?.title
        cell.cellContent.text = articleData?.content.htmlToString
        cell.cellContent.font = cell.cellContent.font.withSize(CGFloat(fontSize))
        cell.cellTitle.font = cell.cellTitle.font.withSize(CGFloat(fontSize + 5))
        cell.cellDate.font = cell.cellDate.font.withSize(CGFloat(fontSize - 5))
        cell.cellAuthor.font = cell.cellAuthor.font.withSize(CGFloat(fontSize - 5))
        
        if let urlForImage = articleData?.imageFeatured {
            let urlString = URL_BASE_FOR_IMAGES + "\(urlForImage)"
            
            let url = URL(string: urlString)
            cell.cellImage.load(url: url!)
        }
        
        if let firstName = articleData?.author.firstName {
            if let lastName = articleData?.author.lastName {
                let firstSurnameLetter = lastName.prefix(1)
                if let country = articleData?.author.country {
                    let authorInfo = "by".localized + " \(firstName) \(firstSurnameLetter). \("-") \(country)"
                    cell.cellAuthor.text = authorInfo
                }
            }
        }
        
        var convertedDate: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "date".localized
        
        if let dateTime = articleData?.publishedAt {
            let dateComponents = dateTime.components(separatedBy: "T")
            
            let splitDate = dateComponents[0]
            
            if let date = dateFormatter.date(from: splitDate) {
                convertedDate = newDateFormatter.string(from: date)
            }
            
            cell.cellDate.text = "publishedOn".localized + " \(convertedDate)"
        }
        return cell
    }
    
    // MARK: - Tab bar delegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item {
        case firstTabBarItem:
            openChangeSizeView()
        case secondTabBarItem:
            openSearchView()
        case thirdTabBarItem:
            self.dismiss(animated: true, completion: nil)
        default:
            print("Nothing to do")
        }
    }
    
    // Make view settings
    private func configureView() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        getArticle()
        
        self.showActivityIndicator(show: true)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableView.automaticDimension;
        
        createCustomUIBarButtonItem()
        
        tabBar.delegate = self
        
    }
    
    private func createCustomUIBarButtonItem() {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(UIImage(named: "left-arrow-angle"), for: .normal)
        button.addTarget(self, action: #selector(tapCustomItem), for: UIControl.Event.touchUpInside)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        
        let customItem = UIBarButtonItem(customView: button)
        self.navigationItem.setLeftBarButton(customItem, animated: false)
    }
    
    @objc private func tapCustomItem() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Activity Indicator
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func getArticle() {
        APIManager.sharedInstance.getSingleArticleData(urlForArticle: urlForArticle) { (article, error) in
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
            self.articleData = article
            
            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()
                self.showActivityIndicator(show: false)
            })
        }
    }
    
    // search feature
    private func openChangeSizeView() {
        
        changeSizeView.isHidden = false
        if let viewForChangingTextSize = Bundle.main.loadNibNamed("ViewForChangingTextSize", owner: self, options: nil)?.first as? ViewForChangingTextSize {
            viewForChangingTextSize.frame = CGRect(x: 0, y: 0, width: changeSizeView.frame.size.width, height: changeSizeView.frame.size.width / 2)
            changeSizeView.addSubview(viewForChangingTextSize)
            viewForChangingTextSize.choosenSize = choosenSize
            viewForChangingTextSize.configurFontSizeView()
            viewForChangingTextSize.delegate = self
        }
    }
    
    func changeChoosenSize(size: String?) {
        self.choosenSize = size
    }
    
    func closeChangeSizeView() {
        changeSizeView.isHidden = true
    }
    
    func changeTextSize(fontSize: Int) {
        self.fontSize =  fontSize
        tableView.reloadData()
    }
}
