//
//  ClassementSecondController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 2/20/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit
import WebKit

class ClassementSecondController: BaseWebViewController, UIScrollViewDelegate {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var redButton: UIButton!
    @IBOutlet var grayButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        let parentVC = self.parent as! ClassementPageViewController
        parentVC.setViewControllers([parentVC.viewControllerList[0]], direction: .reverse, animated: true, completion: nil)
    }
    
    @IBAction func actionBackForGrayButton(_ sender: UIButton) {
        let parentVC = self.parent as! ClassementPageViewController
        parentVC.setViewControllers([parentVC.viewControllerList[0]], direction: .reverse, animated: true, completion: nil)
    }
    
    // Make view settings
    private func configureView() {
        getParentControllers()
        dropDown?.loadDelegate = self
        
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        
        wkWebView.scrollView.isScrollEnabled = true
        
        redButton.layer.cornerRadius = 2
        redButton.clipsToBounds = true
        
        grayButton.layer.cornerRadius = 2
        grayButton.clipsToBounds = true
        
        wkWebView.scrollView.delegate = self
        wkWebView.scrollView.showsHorizontalScrollIndicator = false
        
        webViewLoadFunction()
        updateLabelsText()
    }
    
    override func webViewLoadFunction() {
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        if let value = UserDefaults.standard.object(forKey: "valuesClassementSecond") ?? UserDefaults.standard.object(forKey: "firstValueRankingAid") {
            if let url = URL(string: URL_BASE + "/" + API_VERSION + "/ranking/zone?cid=\(id)&lang=\("Language".localized)&aid=\(value)") {
                print(url)
                wkWebView.load(URLRequest(url: url))
            }
        }
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        wkWebView.scrollView.showsHorizontalScrollIndicator = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0){
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
    
    override func updateLabelsText() {
        titleLabel.text = "RANKING".localized
        subtitleLabel.text = "classementSecondSubtitle".localized
    }
}
