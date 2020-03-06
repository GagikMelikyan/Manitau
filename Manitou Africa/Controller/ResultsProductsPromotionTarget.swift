//
//  ResultsProductsPromotionTarget.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 3/23/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit
import WebKit

class ResultsProductsPromotionTarget: BaseWebViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var thirdButton: UIButton!
    @IBOutlet var forthButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        configureView()
    }
    
    
    @IBAction func actionScrollNextPage(_ sender: UIButton) {
        let parentVC = self.parent as! ResultsPageViewController
        parentVC.setViewControllers([parentVC.viewControllerList[3]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func actionScrollPreviousPage(_ sender: UIButton) {
        let parentVC = self.parent as! ResultsPageViewController
        parentVC.setViewControllers([parentVC.viewControllerList[1]], direction: .reverse, animated: true, completion: nil)
    }
    
    // Make view settings
    private func configureView() {
        getParentControllers()
        dropDown?.loadDelegate = self
        
        firstButton.layer.cornerRadius = 2
        firstButton.layer.masksToBounds = true
        secondButton.layer.cornerRadius = 2
        secondButton.layer.masksToBounds = true
        thirdButton.layer.cornerRadius = 2
        thirdButton.layer.masksToBounds = true
        forthButton.layer.cornerRadius = 2
        forthButton.layer.masksToBounds = true
        
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        
        updateLabelsText()
        webViewLoadFunction()
    }
    
    override func webViewLoadFunction() {
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        if let value = UserDefaults.standard.object(forKey: "valuesResultsThird") ?? UserDefaults.standard.object(forKey: "firstValueDropDownCode") {
            print("Third value = \(value)")
            if let url = URL(string: URL_BASE + "/" + API_VERSION + "/results/promotion?cid=\(id)&lang=\("Language".localized)&code=\(value)") {
                print(url)
                wkWebView.load(URLRequest(url: url))
            }
        }
    }
    
    override func updateLabelsText() {
        titleLabel.text = "RESULTS".localized
        subtitleLabel.text = "productsPromotionTarget".localized
    }
}

