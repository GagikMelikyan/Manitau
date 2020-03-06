//
//  SalesHistorySecondController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 4/2/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit
import WebKit

class SalesHistorySecondController: BaseWebViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getParentControllers()
        dropDown?.loadDelegate = self
        
        configureView()
    }
    
    @IBAction func actionScrollPreviousPage(_ sender: UIButton) {
        let parentVC = self.parent as! SalesHistoryPageViewController
        parentVC.setViewControllers([parentVC.viewControllerList[0]], direction: .reverse, animated: true, completion: nil)
    }
    
    // Make view settings
    private func configureView() {
        
        firstButton.layer.cornerRadius = 2
        firstButton.layer.masksToBounds = true
        secondButton.layer.cornerRadius = 2
        secondButton.layer.masksToBounds = true
        
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        
        updateLabelsText()
        webViewLoadFunction()
    }
    
    override func webViewLoadFunction() {
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        if let value = UserDefaults.standard.object(forKey: "valuesSalesSecond") ?? UserDefaults.standard.object(forKey: "firstValueDropDownCode") {
            if let url = URL(string: URL_BASE + "/" + API_VERSION + "/sales/2018?cid=\(id)&code=\(value)") {
                print(url)
                wkWebView.load(URLRequest(url: url))
            }
        }
        
    }
    
    override func updateLabelsText() {
        titleLabel.text = "SalesHISTORY".localized
        subtitleLabel.text = "mySales2018".localized
    }
}
