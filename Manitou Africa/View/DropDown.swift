//
//  DropDown.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 7/12/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

protocol DropDelegate: AnyObject {
    func changeButtonText(text: String)
    func animate(toogle: Bool)
}

protocol LoadDelegate: AnyObject {
    func webViewLoadFunction()
}

enum WebView:String {
    case SalesFirst
    case SalesSecond
    case ClassementFirst
    case ClassementSecond
    case ResultsFirst
    case ResultsSecond
    case ResultsThird
    case ResultsForth
}

class DropDown: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var dropDownValues =  [DropdownValue] ()
    var rankingValues =  [RankingValue] ()
    weak var dropDelegate: DropDelegate?
    weak var loadDelegate: LoadDelegate?
    var urlString: String?
    
    override func awakeFromNib() {
        setUrlForValue()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: -13, bottom: 0, right: 0)
        
        tableView.layer.cornerRadius = 5
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (UIApplication.getTopViewController() as? ClassementPageViewController) != nil {
            return rankingValues.count
        } else {
            return dropDownValues.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if (UIApplication.getTopViewController() as? ClassementPageViewController) != nil {
            cell.textLabel?.text = rankingValues[indexPath.row].title
        } else {
            cell.textLabel?.text = dropDownValues[indexPath.row].title
            
        }
        
        cell.textLabel?.font = UIFont(name: "NotoSans", size: 17)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let defaults = UserDefaults.standard
        if let salesTopVC = UIApplication.getTopViewController() as? SalesHistoryPageViewController {
            dropDelegate?.changeButtonText(text: dropDownValues[indexPath.row].title)
            if let myViewControllers = salesTopVC.viewControllers {
                for viewController in myViewControllers {
                    print(viewController)
                    if viewController is SalesHistoryFirstController {
                        defaults.set(self.dropDownValues[indexPath.row].customerCode, forKey: "valuesSalesFirst")
                        defaults.set(self.dropDownValues[indexPath.row].title, forKey: "titleSalesFirst")
                    } else if viewController is SalesHistorySecondController {
                        defaults.set(self.dropDownValues[indexPath.row].customerCode, forKey: "valuesSalesSecond")
                        defaults.set(self.dropDownValues[indexPath.row].title, forKey: "titleSalesSecond")
                    }
                }
            }
        }
        else if let classementTopVC = UIApplication.getTopViewController() as? ClassementPageViewController {
            dropDelegate?.changeButtonText(text: rankingValues[indexPath.row].title)
            
            if let myViewControllers = classementTopVC.viewControllers {
                for viewController in myViewControllers {
                    print(viewController)
                    if viewController is ClassementFirstController {
                        defaults.set(self.rankingValues[indexPath.row].aid, forKey: "valuesClassementFirst")
                        defaults.set(self.rankingValues[indexPath.row].title, forKey: "titleClassementFirst")
                    } else if viewController is ClassementSecondController {
                        defaults.set(self.rankingValues[indexPath.row].aid, forKey: "valuesClassementSecond")
                        defaults.set(self.rankingValues[indexPath.row].title, forKey: "titleClassementSecond")
                    }
                }
            }
        }
        else if let resultsTopVC = UIApplication.getTopViewController() as? ResultsPageViewController {
            dropDelegate?.changeButtonText(text: dropDownValues[indexPath.row].title)
            if let myViewControllers = resultsTopVC.viewControllers {
                for viewController in myViewControllers {
                    print(viewController)
                    if viewController is ResultsMyPoints {
                        defaults.set(self.dropDownValues[indexPath.row].customerCode, forKey: "valuesResultsFirst")
                        defaults.set(self.dropDownValues[indexPath.row].title, forKey: "titleResultsFirst")
                    } else if viewController is ResultsSalesRevenueTarget {
                        defaults.set(self.dropDownValues[indexPath.row].customerCode, forKey: "valuesResultsSecond")
                        defaults.set(self.dropDownValues[indexPath.row].title, forKey: "titleResultsSecond")
                    } else if viewController is ResultsProductsPromotionTarget {
                        defaults.set(self.dropDownValues[indexPath.row].customerCode, forKey: "valuesResultsThird")
                        defaults.set(self.dropDownValues[indexPath.row].title, forKey: "titleResultsThird")
                    } else if viewController is ResultsMarketingOperationTarget {
                        defaults.set(self.dropDownValues[indexPath.row].customerCode, forKey: "valuesResultsForth")
                        defaults.set(self.dropDownValues[indexPath.row].title, forKey: "titleResultsForth")
                    }
                }
            }
        }
        
        dropDelegate?.animate(toogle: false)
        loadDelegate?.webViewLoadFunction()
        
    }
    
    func setUrlForValue() {
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        if (UIApplication.getTopViewController() as? SalesHistoryPageViewController) != nil {
            urlString = URL_BASE + "/" + API_VERSION + "/dealers?cid=\(id)"
            getDropdownValues()
        }
        else if (UIApplication.getTopViewController() as? ClassementPageViewController) != nil {
            urlString = URL_BASE + "/" + API_VERSION + "/zones?cid=\(id)"
            getValuesForRanking()
        }
        else if (UIApplication.getTopViewController() as? ResultsPageViewController) != nil {
            urlString = URL_BASE + "/" + API_VERSION + "/dealers?cid=\(id)"
            getDropdownValues()
        }
    }
    
    private func getDropdownValues() {
        APIManager.sharedInstance.getDropdownValues(url: urlString! ) { (values, error) in
            if let error = error {
                // got an error in getting the data
                print(error)
                return
            }
            
            guard let values = values else {
                print("error getting values: result is nil")
                return
            }
            
            for value in values {
                self.dropDownValues.append(value)
            }
            
            let defaults = UserDefaults.standard
            defaults.set(self.dropDownValues.first?.customerCode, forKey: "firstValueDropDownCode")
            defaults.set(self.dropDownValues.first?.title, forKey: "firstValueDropDownTitle")
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                
            })
        }
    }
    
    func getValuesForRanking() {
        APIManager.sharedInstance.getRankingValues(url: urlString!) { (values, error) in
            guard let values = values else {
                print("error getting ranking values: result is nil")
                return
            }
            
            for value in values {
                self.rankingValues.append(value)
            }
            let defaults = UserDefaults.standard
            defaults.set(self.rankingValues.first?.title, forKey: "firstValueRankingTitle")
            defaults.set(self.rankingValues.first?.aid, forKey: "firstValueRankingAid")
            
            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()
            })
        }
    }
}
