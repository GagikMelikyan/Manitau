//
//  ResultsMyPoints.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 2/26/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit
import WebKit


class ResultsMyPoints: BaseWebViewController  {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var redButton: UIButton!
    @IBOutlet var firstGrayButton: UIButton!
    @IBOutlet var secondGrayButton: UIButton!
    @IBOutlet var thirdGrayButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    @IBAction func actionGoToNextPage(_ sender: UIButton) {
        let parentVC = self.parent as! ResultsPageViewController
        parentVC.setViewControllers([parentVC.viewControllerList[1]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func actionForRedButton(_ sender: UIButton) {
        let parentVC = self.parent as! ResultsPageViewController
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
        firstGrayButton.layer.cornerRadius = 2
        firstGrayButton.clipsToBounds = true
        secondGrayButton.layer.cornerRadius = 2
        secondGrayButton.clipsToBounds = true
        thirdGrayButton.layer.cornerRadius = 2
        thirdGrayButton.clipsToBounds = true
        
        updateLabelsText()
        webViewLoadFunction()
    }
    
    override func webViewLoadFunction() {
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        if let value = UserDefaults.standard.object(forKey: "valuesResultsFirst") ?? UserDefaults.standard.object(forKey: "firstValueDropDownCode") {
            print("First value = \(value)")
            if let url = URL(string: URL_BASE + "/" + API_VERSION + "/results/points?cid=\(id)&lang=\("Language".localized)&code=\(value)") {
                print(url)
                wkWebView.load(URLRequest(url: url))
            }
        }
    }
    
    override func updateLabelsText() {
        titleLabel.text = "RESULTS".localized
        subtitleLabel.text = "myPoints".localized
    }
}
