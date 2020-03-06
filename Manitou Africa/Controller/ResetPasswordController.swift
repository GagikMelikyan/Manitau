//
//  ResetPasswordController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 1/27/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

class ResetPasswordController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var buttonReinitialoser: UIButton!
    @IBOutlet var firstWarningLabel: UILabel!
    @IBOutlet var secondWarningLabel: UILabel!
    @IBOutlet var thirdWarningLabel: UILabel!
    
//    @IBOutlet var responseMessageReturnLbl: UILabel!
//    @IBOutlet var responseMessageReturnView: UIView!
    
    @IBOutlet var firstWarningLabelWidth: NSLayoutConstraint!
    @IBOutlet var secondWarningLabelWidth: NSLayoutConstraint!
    @IBOutlet var thirdWarningLabelWidth: NSLayoutConstraint!
    
    weak var delegate: SuccessMessageDelegate?
    var languageLabel: UILabel?
    var flagImageView: UIImageView?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        startObservingKeyboardChanges()
    }
    
    @IBAction func resetBtn (_ sender: UIButton) {
        if let emailText = emailTextField.text {
            
            guard Validations.isValidEmail(emailText) else {
                return makeAlertAppear(title: "ValidationsEmailAlertTitle".localized, message: "ValidationsEmailAlertMessage".localized, actionTitle: "OK")
            }
            
            emailTextField.resignFirstResponder()
            
            resetPasswordPOSTRecuest(emailAddress: emailText)
        }
    }
    
    // UITextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
        }
        return true
    }
    
    // Make view settings
    func configureView() {
        
        setGradientBackground()
        setRightBarButtonItems()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationController?.navigationBar.tintColor = .white
        
        emailView.layoutIfNeeded()
        emailView.layer.addBorder(edge: .bottom, color: .white, thickness: 1)
        
        emailTextField.delegate = self
        emailTextField.setTextfieldTextPlaceholderColor(withString: "email".localized)
        
        buttonReinitialoser.layer.cornerRadius = 3
        buttonReinitialoser.clipsToBounds = true
        buttonReinitialoser.setTitle("resetPassword".localized, for: .normal)
        buttonReinitialoser.titleLabel?.textAlignment = .center
        
        firstWarningLabel.text = "firstWarningText".localized
        secondWarningLabel.text = "secondWarningText".localized
        thirdWarningLabel.text = "thirdWarningLabel".localized
    }
    
    //Make view background gradient
    func setGradientBackground() {
        let colorTop =  UIColor(red: 226.0/255.0, green: 0/255.0, blue: 26.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 194.0/255.0, green: 0/255.0, blue: 22.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // Make settings of rightBarButtonItems
    func setRightBarButtonItems() {
        
        languageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 24, height: 22))
        languageLabel?.text = "flagText".localized
        languageLabel?.textColor = .white
        languageLabel?.font = UIFont(name: "NotoSans", size: 18)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLanguageSettings(tapGestureRecognizer:)))
        languageLabel?.isUserInteractionEnabled = true
        languageLabel?.addGestureRecognizer(tapGestureRecognizer)
        let labelLanguage = UIBarButtonItem(customView: languageLabel!)
        
        //        let flagImage = UIImage.init(named: "flagImageName".localized)
        //        flagImageView = UIImageView.init(image: flagImage)
        //        //flagImageView.frame = CGRect(x: 0, y: 0, width: 15, height: 30)
        //        flagImageView?.frame = CGRect(x: 0, y: 0, width: 28, height: 20)
        //        flagImageView?.contentMode = .scaleAspectFit
        //        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLanguageSettings(tapGestureRecognizer:)))
        //        flagImageView?.isUserInteractionEnabled = true
        //        flagImageView?.addGestureRecognizer(tapGestureRecognizer)
        //        let imageFlag = UIBarButtonItem.init(customView: flagImageView!)
        
        //navigationItem.setRightBarButtonItems([labelFR, imageFlag], animated: false)
        navigationItem.setRightBarButton(labelLanguage, animated: false)
    }
    
    @objc func didTapLanguageSettings(tapGestureRecognizer: UITapGestureRecognizer)  {
        
        if UserDefaults.standard.string(forKey: "language_settings") == "fr" {
            UserDefaults.standard.set("en", forKey: "language_settings")
        } else {
            UserDefaults.standard.set("fr", forKey: "language_settings")
        }
        
        updateUI()
    }
    
    // NotificationCenter observers
    private func startObservingKeyboardChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height / 2
            }
        }
    }
    
    private func updateUI() {
        self.languageLabel?.text = "flagText".localized
        flagImageView?.image = UIImage(named: "flagImageName".localized)
        emailTextField.setTextfieldTextPlaceholderColor(withString: "email".localized)
        buttonReinitialoser.setTitle("resetPassword".localized, for: .normal)
        firstWarningLabel.text = "firstWarningText".localized
        secondWarningLabel.text = "secondWarningText".localized
        thirdWarningLabel.text = "thirdWarningLabel".localized
        
    }
    
    private func makeAlertAppear(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func resetPasswordPOSTRecuest (emailAddress: String) {
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        var parameters = [String : Any]()
        parameters["email"] = emailAddress
        if UserDefaults.standard.string(forKey: "language_settings") == "fr" {
            parameters["language"] = "fr"
        }
        //create the url with URL
        let url = URL(string: "\(URL_BASE_API)/\(API_VERSION)/password")! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let message = json["message"] as? String {
                        DispatchQueue.main.async {
                        self.delegate?.showSuccessMessage(self, message: message)
                        }
                    } else if let errors = json["errors"] as? [String : Any] {
                        DispatchQueue.main.async {
                            let title = errors["title"] as! String
                            let message = errors["message"] as! String
                            self.makeAlertAppear(title: title, message: message, actionTitle: "Ok")
                        }
                    }
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
