//
//  SearchView.swift
//  Manitou Africa
//
//  Created by User on 6/10/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

protocol SearchViewDelegete: class {
    func getSearchingArticles(_ text: String)
}

class SearchView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var searchViewTitle: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var doesntFoundLabel: UILabel!
    
    weak var delegate: SearchViewDelegete?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchButton.layer.cornerRadius = 5
        searchTextField.layer.cornerRadius = 5
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.red.cgColor
        searchTextField.delegate = self
    }
    
    @IBAction func searchNews() {
        if let text = searchTextField.text {
            searchButton.isEnabled = false
            searchButton.alpha = 0.5
            delegate?.getSearchingArticles(text)
            searchTextField.resignFirstResponder()
        }
    }
    
    // UITextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchTextField.resignFirstResponder()
        }
        return true
    }
    
    func enabledButton() {
        DispatchQueue.main.async {
            self.searchButton.isEnabled = true
            self.searchButton.alpha = 1
        }
        
    }
}
