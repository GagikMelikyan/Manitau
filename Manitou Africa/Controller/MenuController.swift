//
//  MenuController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 1/23/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit
import SideMenuSwift

class MenuController: UITableViewController, HeaderDelegate {
    
    @IBOutlet var logoView: UIView!
    
    var data = [Menu(menuName: "headlines".localized, isExpandable: false),
                Menu(menuName: "news".localized, isExpandable: false),
                Menu(menuName: "ranking".localized, isExpandable: false),
                Menu(menuName: "results".localized, isExpandable: false),
                Menu(menuName: "salesHistory".localized, isExpandable: false),
                Menu(menuName: "marketing".localized, isExpandable: false),
                Menu(menuName: "copyright".localized, isExpandable: false),
                Menu(menuName: "contact".localized, isExpandable: false),
                Menu(menuName: "logout".localized, isExpandable: false)]
    
    var sectionItems = ["articles".localized, "mmb".localized, "reduce".localized, "specs".localized]
    let imageNames = ["a_la_une-white", "fil_d_actualite%D5%9B-white", "classement-white", "results-white", "historique-de-ventes-white", "Mes_bonus-white", "reglement-white", "contact-white", "deconnexion-white"]
    let redImageNames = ["a_la_une-red", "fil_d_actualite%D5%9B-red", "classement-red", "results-red", "historique-de-_ventes", "Mes_bonus-red", "reglement-red", "contact-red", "deconnexion-red"]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        updateUI()
    }
    
    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 5) && (data[section].isExpandable) {
            
            return sectionItems.count
            
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.menuTitle.text = sectionItems[indexPath.row]
        cell.menuTitle.font = UIFont(name: "NotoSans", size: 19)
        cell.menuTitle.textColor = .white
        cell.menuTitle?.highlightedTextColor = .black
        //cell .menuImage.highlightedImage = UIImage(named: redImageNames[indexPath.row])
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        let tap = UITapGestureRecognizer(target: self, action:#selector(tapCell))
        //tap.delegate = self
        headerView.addGestureRecognizer(tap)
        
        headerView.delegate = self
        headerView.sectionIndex = section
        headerView.button.setTitle(data[section].menuName, for: .normal)
        headerView.button.titleLabel?.font = UIFont(name: "NotoSans", size: 19)
        
        headerView.menuImage.image = UIImage(named: imageNames[section])
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuCell 
        cell.contentView.backgroundColor = UIColor.white
        
        switch indexPath.row {
        case 0:
            let articlesVC = self.storyboard?.instantiateViewController(withIdentifier: "ArticlesNavigationController") as! ArticlesNavigationController
            self.present(articlesVC, animated: true, completion: nil)
        case 1:
            guard let url = URL(string: "https://mymarketingbox.manitou.com") else { return }
            UIApplication.shared.open(url)
        case 2:
            guard let url = URL(string: "https://www.reduce-program.com") else { return }
            UIApplication.shared.open(url)
        case 3:
            guard let url = URL(string: "https://specs.manitou.com") else { return }
            UIApplication.shared.open(url)
        default:
            print("Good")
        }
    }
    
    // Make view settings
    private func configureView() {
        let menuWidth = view.frame.width - 100
        SideMenuController.preferences.basic.menuWidth = menuWidth
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = GradientView()
        tableView.tableHeaderView = logoView
        tableView.separatorStyle = .none
    }
    
    class GradientView: UIView {
        
        /* Overriding default layer class to use CAGradientLayer */
        override class var layerClass: AnyClass {
            return CAGradientLayer.self
        }
        
        /* Handy accessor to avoid unnecessary casting */
        private var gradientLayer: CAGradientLayer {
            return layer as! CAGradientLayer
        }
        
        /* Public properties to manipulate colors */
        public var fromColor: UIColor = UIColor(red: 226.0/255.0, green: 0/255.0, blue: 26.0/255.0, alpha: 1.0) {
            didSet {
                var currentColors = gradientLayer.colors
                currentColors![0] = fromColor.cgColor
                gradientLayer.colors = currentColors
            }
        }
        
        public var toColor: UIColor = UIColor(red: 194.0/255.0, green: 0/255.0, blue: 22.0/255.0, alpha: 1.0) {
            didSet {
                var currentColors = gradientLayer.colors
                currentColors![1] = toColor.cgColor
                gradientLayer.colors = currentColors
            }
        }
        
        /* Initializers overriding to have appropriately configured layer after creation */
        override init(frame: CGRect) {
            super.init(frame: frame)
            gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
    }
    
    private func updateUI() {
        data = [Menu(menuName: "headlines".localized, isExpandable: false),
                Menu(menuName: "news".localized, isExpandable: false),
                Menu(menuName: "ranking".localized, isExpandable: false),
                Menu(menuName: "results".localized, isExpandable: false),
                Menu(menuName: "salesHistory".localized, isExpandable: false),
                Menu(menuName: "marketing".localized, isExpandable: false),
                Menu(menuName: "copyright".localized, isExpandable: false),
                Menu(menuName: "contact".localized, isExpandable: false),
                Menu(menuName: "logout".localized, isExpandable: false)]
        
        sectionItems = ["articles".localized, "mmb".localized, "reduce".localized, "specs".localized]
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func cellHeader(index: Int) {
        data[index].isExpandable = !data[index].isExpandable
        tableView.reloadSections([index], with: .automatic)
    }
    
    @objc func tapCell(index: Int) {
        
        switch index {
        case 0:
            let headlinesVC = self.storyboard?.instantiateViewController(withIdentifier: "HeadlinesNavigationController") as! HeadlinesNavigationController
            self.present(headlinesVC, animated: true, completion: nil)
        case 1:
            sideMenuController?.hideMenu()
        case 2:
            let resultatsVC = self.storyboard?.instantiateViewController(withIdentifier: "ClassementNavigationController") as! ClassementNavigationController
            self.present(resultatsVC, animated: true, completion: nil)
        case 3:
            let classementVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultsNavigationController") as! ResultsNavigationController
            self.present(classementVC, animated: true, completion: nil)
        case 4:
            let salesHistoryVC = self.storyboard?.instantiateViewController(withIdentifier: "SalesHistoryNavigationController") as! SalesHistoryNavigationController
            self.present(salesHistoryVC, animated: true, completion: nil)
        case 5:
            print("Good")
        case 6:
            guard let url = URL(string: "linkForReglement".localized) else { return }
            UIApplication.shared.open(url)
        case 7:
            let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactNavigationController") as! ContactNavigationController
            self.present(contactVC, animated: true, completion: nil)
        case 8:
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
                (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
            }
        default:
            print("default")
        }
    }
    
}
