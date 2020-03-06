//
//  TermsAndConditionsController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 6/6/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

class TermsAndConditionsController: UIViewController {
    
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var termsLabel: UILabel!
    @IBOutlet var termsButton: UIButton!
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var rejectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        setLayoutSubviews()
    }
    
    @IBAction func readTermsAndConditions(_ sender: UIButton) {
        guard let url = URL(string: "linkForTermsAndConditions".localized) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func submitTermsAndConditions(_ sender: UIButton) {
        
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        let userCgu = Cgu(cgu: true)
        APIManager.sharedInstance.submitTermsAndConditions(cgu: userCgu, id) { (error, statusCode) in
            if let error = error {
                // got an error in getting the data, need to handle it
                print("error calling PUT request")
                print(error)
                return
            }
            
            if let statusCode = statusCode {
                print(statusCode)
                switch statusCode {
                case 200:
                    DispatchQueue.main.async(execute: {
                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuSwift") as? SideMenuViewController
                        {
                            self.present(vc, animated: true, completion: nil)
                        }
                    })
                default:
                    print("No status code")
                }
            }
        }
        
    }
    
    @IBAction func rejectTermsAndConditions(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureView() {
        
        acceptButton.clipsToBounds = true
        acceptButton.setTitle("agreeButton".localized, for: .normal)
        acceptButton.titleLabel?.textAlignment = .center
        
        rejectButton.clipsToBounds = true
        rejectButton.setTitle("rejectButton".localized, for: .normal)
        rejectButton.titleLabel?.textAlignment = .center
        
        termsButton.clipsToBounds = true
        termsButton.setTitle("termsButton".localized, for: .normal)
        termsButton.titleLabel?.textAlignment = .center
        
        welcomeLabel.text = "welcomeLabel".localized
        termsLabel.text = "termsLabel".localized
    }
    
    // Set layout subviewss
    private func setLayoutSubviews() {
        acceptButton.layer.cornerRadius = 15
    }
    
}
