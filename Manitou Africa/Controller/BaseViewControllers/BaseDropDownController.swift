//
//  BaseDropDownController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 7/12/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

class BaseDropDownController: UIViewController, DropDelegate  {
    
    @IBOutlet weak var containerForDropDown: UIView!
    @IBOutlet weak var dropButton: UIButton!
    @IBOutlet weak var dropArrowImage: UIImageView!
    @IBOutlet weak var containerForDropButton: UIView!
    
    var dropDown: DropDown?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        if id > 5 {
            containerForDropButton.isHidden = true
        }
        
        containerForDropDown.isHidden = true
        makeDropDown()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        changeButtonText()
    }
    
    @IBAction func onClickDropButton(_ sender: UIButton) {
        if containerForDropDown.isHidden {
            animate(toogle: true)
        } else {
            animate(toogle: false)
        }
    }
    
    private func makeDropDown() {
        if let dropDown = Bundle.main.loadNibNamed("DropDown", owner: self, options: nil)?.first as? DropDown {
            containerForDropDown.addSubviewWithLayoutToBounds(subview: dropDown)
            dropDown.dropDelegate = self
            self.dropDown = dropDown
        }
    }
    
    func changeButtonText() {
        
        let defaults = UserDefaults.standard
        if let salesTopVC = UIApplication.getTopViewController() as? SalesHistoryPageViewController {
            if let myViewControllers = salesTopVC.viewControllers {
                for viewController in myViewControllers {
                    print(viewController)
                    if viewController is SalesHistoryFirstController {
                        if let buttonValue = defaults.object(forKey: "titleSalesFirst") as? String {
                            dropButton.setTitle(buttonValue, for: .normal)
                        } else {
                            
                            if let firstValue = defaults.object(forKey: "firstValueDropDownTitle") as? String {
                                dropButton.setTitle(firstValue, for: .normal)
                            }
                        }
                    } else if viewController is SalesHistorySecondController {
                        if let buttonValue = defaults.object(forKey: "titleSalesSecond") as? String {
                            dropButton.setTitle(buttonValue, for: .normal)
                        } else {
                            
                            if let firstValue = defaults.object(forKey: "firstValueDropDownTitle") as? String {
                                dropButton.setTitle(firstValue, for: .normal)
                            }
                        }
                    }
                }
            }
        }
        else if let resultsTopVC = UIApplication.getTopViewController() as? ResultsPageViewController {
            if let myViewControllers = resultsTopVC.viewControllers {
                for viewController in myViewControllers {
                    print(viewController)
                    if viewController is ResultsMyPoints {
                        if let buttonValue = defaults.object(forKey: "titleResultsFirst") as? String {
                            dropButton.setTitle(buttonValue, for: .normal)
                        } else {
                            if let firstValue = defaults.object(forKey: "firstValueDropDownTitle") as? String {
                                dropButton.setTitle(firstValue, for: .normal)
                            }
                        }
                    }
                    else if viewController is ResultsSalesRevenueTarget {
                        if let buttonValue = defaults.object(forKey: "titleResultsSecond") as? String {
                            dropButton.setTitle(buttonValue, for: .normal)
                        } else {
                            if let firstValue = defaults.object(forKey: "firstValueDropDownTitle") as? String {
                                print("FirstValue = \(firstValue)")
                                dropButton.setTitle(firstValue, for: .normal)
                            }
                        }
                    } else if viewController is ResultsProductsPromotionTarget {
                        if let buttonValue = defaults.object(forKey: "titleResultsThird") as? String {
                            dropButton.setTitle(buttonValue, for: .normal)
                        } else {
                            
                            if let firstValue = defaults.object(forKey: "firstValueDropDownTitle") as? String {
                                dropButton.setTitle(firstValue, for: .normal)
                            }
                        }
                    } else if viewController is ResultsMarketingOperationTarget {
                        if let buttonValue = defaults.object(forKey: "titleResultsForth") as? String {
                            
                            dropButton.setTitle(buttonValue, for: .normal)
                        } else {
                            if let firstValue = defaults.object(forKey: "firstValueDropDownTitle") as? String {
                                dropButton.setTitle(firstValue, for: .normal)
                            }
                        }
                    }
                }
            }
        }
            
        else if let classementTopVC = UIApplication.getTopViewController() as? ClassementPageViewController {
            if let myViewControllers = classementTopVC.viewControllers {
                for viewController in myViewControllers {
                    print(viewController)
                    if viewController is ClassementFirstController {
                        if let buttonValue = defaults.object(forKey: "titleClassementFirst") as? String {
                            dropButton.setTitle(buttonValue, for: .normal)
                        } else {
                            if let firstValue = defaults.object(forKey: "firstValueRankingTitle") as? String {
                                print("FirstValue = \(firstValue)")
                                dropButton.setTitle(firstValue, for: .normal)
                            }
                        }
                    } else if viewController is ClassementSecondController {
                        if let buttonValue = defaults.object(forKey: "titleClassementSecond") as? String {
                            
                            dropButton.setTitle(buttonValue, for: .normal)
                        } else {
                            
                            if let firstValue = defaults.object(forKey: "firstValueRankingTitle") as? String {
                                dropButton.setTitle(firstValue, for: .normal)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func animate(toogle: Bool) {
        if toogle {
            UIView.animate(withDuration: 0.3) {
                
                self.containerForDropDown.isHidden = false
                UIView.animate(withDuration: 0.4, animations: {
                    self.dropArrowImage.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                })
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                
                self.containerForDropDown.isHidden = true
                UIView.animate(withDuration: 0.4, animations: {
                    self.dropArrowImage.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
                })
            }
        }
    }
    
    func changeButtonText(text: String) {
        dropButton.setTitle(text, for: .normal)
    }
    
}
