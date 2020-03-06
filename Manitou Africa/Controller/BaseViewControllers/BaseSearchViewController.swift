//
//  BaseSearchViewController.swift
//  Manitou Africa
//
//  Created by User on 6/18/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

class BaseSearchViewController: UIViewController, SearchViewDelegete {
    
    @IBOutlet weak var changeSizeView: UIView!
    
    final var searchingText: String?
    final var arrayOfArticles = [Member]()
    
    var searchView: SearchView?
    
    func openSearchView() {
        changeSizeView.isHidden = false
        if let searchView = Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)?.first as? SearchView {
            changeSizeView.addSubviewWithLayoutToBounds(subview: searchView)
            searchView.delegate = self
            self.searchView = searchView
        }
    }
    
    func getSearchingArticles(_ text: String) {
        arrayOfArticles = []
        searchingText = text
        
        ArticleRequestController.getAllArticles(text: text) { [weak self] (news) in
            guard let `self` = self else { return }
            if let news = news {
                let articles = news.member
                for article in articles {
                    if article.title.lowercased().contains(text.lowercased()) {
                        self.arrayOfArticles.append(article)
                        self.goToArticlesPage()
                    }
                }
                if self.arrayOfArticles.count == 0 {
                    self.enabledSearchViewButton()
                }
            }
            self.enabledSearchViewButton()
        }
    }
    
    private func goToArticlesPage() {
        
        let articlesNVC = self.storyboard?.instantiateViewController(withIdentifier: "ArticlesNavigationController") as! ArticlesNavigationController
        let articlesVC = articlesNVC.viewControllers.first as! ArticlesController
        articlesVC.searchingText = searchingText
        articlesVC.arrayOfArticles = arrayOfArticles
        //        enabledSearchViewButton()
        DispatchQueue.main.async {
            self.changeSizeView.isHidden = true
            self.present(articlesNVC, animated: true, completion: nil)
        }
        
    }
    
    private func enabledSearchViewButton() {
        searchView!.enabledButton()
        if arrayOfArticles.count == 0 {
            DispatchQueue.main.async {
                self.searchView!.doesntFoundLabel.text = "doesntFound".localized + self.searchView!.searchTextField.text!
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.searchView!.doesntFoundLabel.text = ""
            }
        }
    }
}
