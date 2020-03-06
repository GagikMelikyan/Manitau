//
//  ResultsMarketingOperationTarget.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 3/20/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit
import WebKit

class ResultsMarketingOperationTarget: BaseWebViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var thirdButton: UIButton!
    @IBOutlet var forthButton: UIButton!
    
    var urlString: String = ""
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    
    @IBAction func actionScrollPreviousPage(_ sender: UIButton) {
        let parentVC = self.parent as! ResultsPageViewController
        parentVC.setViewControllers([parentVC.viewControllerList[2]], direction: .reverse, animated: true, completion: nil)
    }
    
    // Make view settings
    private func configureView() {
        getParentControllers()
        dropDown?.loadDelegate = self
        
        
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        
        firstButton.layer.cornerRadius = 2
        firstButton.layer.masksToBounds = true
        secondButton.layer.cornerRadius = 2
        secondButton.layer.masksToBounds = true
        thirdButton.layer.cornerRadius = 2
        thirdButton.layer.masksToBounds = true
        forthButton.layer.cornerRadius = 2
        forthButton.layer.masksToBounds = true
        
        updateLabelsText()
        webViewLoadFunction()
    }
    
    override func webViewLoadFunction() {
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        if let value = UserDefaults.standard.object(forKey: "valuesResultsForth") ?? UserDefaults.standard.object(forKey: "firstValueDropDownCode") {
            print("Forth value = \(value)")
            if let url = URL(string:URL_BASE + "/" + API_VERSION + "/results/marketing?cid=\(id)&lang=\("Language".localized)&code=\(value)") {
                print(url)
                wkWebView.load(URLRequest(url: url))
            }
        }
    }
    
    override func updateLabelsText() {
        titleLabel.text = "RESULTS".localized
        subtitleLabel.text = "marketingOperationTarget".localized
    }
}
