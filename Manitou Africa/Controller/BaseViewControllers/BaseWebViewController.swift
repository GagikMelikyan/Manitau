//
//  BaseWebViewController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 7/30/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewController: BaseDropDownController {
    
    @IBOutlet var containerForWebView: UIView!
    
    // instance of WKWebView
    let wkWebView: WKWebView = {
        let v = WKWebView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.scrollView.isScrollEnabled = false
        return v
    }()
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    // Make view settings
    private func configureView() {
        
        wkWebView.scrollView.isScrollEnabled = false
        
        containerForWebView.addSubview(wkWebView)
        
        //pin to all 4 edges
        wkWebView.topAnchor.constraint(equalTo: containerForWebView.topAnchor, constant: 0.0).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: containerForWebView.bottomAnchor, constant: 0.0).isActive = true
        wkWebView.leadingAnchor.constraint(equalTo: containerForWebView.leadingAnchor, constant: 0.0).isActive = true
        wkWebView.trailingAnchor.constraint(equalTo: containerForWebView.trailingAnchor, constant: 0.0).isActive = true
        
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        
        view.addSubview(activityIndicator)
        
        
    }
    
    func getParentControllers() {
        
        if let salesTopVC = UIApplication.getTopViewController() as? SalesHistoryPageViewController {
            print(salesTopVC)
            let parentVC = self.parent as! SalesHistoryPageViewController
            parentVC.dataDelegate = self
        }
        else if let classementTopVC = UIApplication.getTopViewController() as? ClassementPageViewController {
            print(classementTopVC)
            let parentVC = self.parent as! ClassementPageViewController
            parentVC.dataDelegate = self
        }
        else if let resultsTopVC = UIApplication.getTopViewController() as? ResultsPageViewController {
            print(resultsTopVC)
            let parentVC = self.parent as! ResultsPageViewController
            parentVC.dataDelegate = self
        }
    }
    
    func webViewLoadFunction() {
        
    }
    
    func updateLabelsText() {
        
    }
}

extension BaseWebViewController: WKNavigationDelegate, WKUIDelegate, DataDelegate, LoadDelegate {
    
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
}

