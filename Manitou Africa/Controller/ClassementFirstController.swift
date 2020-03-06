//
//  ClassementFirstController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 2/20/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit
import WebKit

class ClassementFirstController: BaseWebViewController{
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var redButton: UIButton!
    @IBOutlet var grayButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    @IBAction func actionGrayButton(_ sender: UIButton) {
        let parentVC = self.parent as! ClassementPageViewController
        parentVC.setViewControllers([parentVC.viewControllerList[1]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func actionScrollNext(_ sender: UIButton) {
        let parentVC = self.parent as! ClassementPageViewController
        parentVC.setViewControllers([parentVC.viewControllerList[1]], direction: .forward, animated: true, completion: nil)
    }
    
    // Make view settings
    private func configureView() {
        getParentControllers()
        dropDown?.loadDelegate = self
        
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        
        redButton.layer.cornerRadius = 2
        redButton.clipsToBounds = true
        
        grayButton.layer.cornerRadius = 2
        grayButton.clipsToBounds = true
        
        updateLabelsText()
        webViewLoadFunction()
    }
    
    override func webViewLoadFunction() {
        
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        if let value = UserDefaults.standard.object(forKey: "valuesClassementFirst") ?? UserDefaults.standard.object(forKey: "firstValueRankingAid") {
            
            if let url = URL(string: URL_BASE + "/" + API_VERSION + "/ranking/position?cid=\(id)&lang=\("Language".localized)&aid=\(value)") {
                print(url)
                wkWebView.load(URLRequest(url: url))
            }
        }
        
    }
    
    override func updateLabelsText() {
        titleLabel.text = "RANKING".localized
        subtitleLabel.text = "myPosition".localized
    }
}
