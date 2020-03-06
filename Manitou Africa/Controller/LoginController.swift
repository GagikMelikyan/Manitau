//
//  LoginController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 1/20/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

enum Codes {
    case north
    case east
    case south
    case west
}

class LoginController: UIViewController, UITextFieldDelegate, SuccessMessageDelegate {
    
    @IBOutlet var usernameView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var buttonSeConnecter: UIButton!
    @IBOutlet var buttonChangePassword: UIButton!
    
    var lbl: UILabel?
    var flagImageView: UIImageView?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        startObservingKeyboardChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        usernameTextfield.text = ""
        passwordTextfield.text = ""
        
        updateUI()
    }
    
    @IBAction func signIn(_ sender: UIButton) {
//        if true {
//            let login = Auth(username: "web@data-gest.fr", password: "92130", language: UserDefaults.standard.string(forKey: "language_settings")!)
        if let emailText = usernameTextfield.text {
            guard Validations.isValidEmail(emailText) else {
                return makeAlertAppear(title: "ValidationsEmailAlertTitle".localized, message: "ValidationsEmailAlertMessage".localized, actionTitle: "OK")
            }
            let language = UserDefaults.standard.string(forKey: "language_settings") ?? ""
            let login = Auth(username: emailText, password: passwordTextfield.text!, language: language)
            APIManager.sharedInstance.submitLogin(login: login) { (error, statusCode, jsonResponse) in
                if let error = error {
                    // got an error in getting the data, need to handle it
                    print("error calling POST request")
                    print(error)
                    return
                }
                
                if let jsonResponse = jsonResponse {
                    print("jsonResponse = \(jsonResponse)")
                    if let statusCode = statusCode {
                        print("StatusCode = \(statusCode)")
                        switch statusCode {
                        case 200:
                            if let cgu: Bool = jsonResponse["cgu"] as? Bool {
                                if cgu == false {
                                    DispatchQueue.main.async(execute: {
                                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TermsAndConditionsController") as? TermsAndConditionsController
                                        {
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                    })
                                } else if cgu == true
                                {
                                    DispatchQueue.main.async(execute: {
                                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuSwift") as? SideMenuViewController
                                        {
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                    })
                                }
                            }
                            
                        case 401:
                            if let errorMesssage = jsonResponse["errors"] as? [String:Any] {
                                let message = errorMesssage["message"]
                                let messageTitle = errorMesssage["title"]
                                DispatchQueue.main.async(execute: {
                                    self.makeAlertAppear(title: messageTitle as! String, message: message as! String, actionTitle: "Ok")
                                })
                            }
                        default:
                            print("No status code")
                        }
                    }
                    
                }
                
            }
        }
        
        
    }
    
    // UITextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextfield {
            passwordTextfield.becomeFirstResponder()
        } else if textField == passwordTextfield {
            passwordTextfield.resignFirstResponder()
        }
        return true
    }
    
    // Make view settings
    private func configureView() {
        
        setRightBarButtonItems()
        setGradientBackground()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        usernameView.layoutIfNeeded()
        usernameView.layer.addBorder(edge: .bottom, color: .white, thickness: 1)
        passwordView.layoutIfNeeded()
        passwordView.layer.addBorder(edge: .bottom, color: .white, thickness: 1)
        
        usernameTextfield.delegate = self
        passwordTextfield.delegate = self
        usernameTextfield.setTextfieldTextPlaceholderColor(withString: "email".localized)
        passwordTextfield.setTextfieldTextPlaceholderColor(withString: "password".localized)
        
        buttonSeConnecter.setTitle("loginButton".localized, for: .normal)
        buttonSeConnecter.titleLabel?.textAlignment = .center
        buttonSeConnecter.layer.cornerRadius = 3
        buttonSeConnecter.clipsToBounds = true
        
        buttonChangePassword.setTitle("resetPasswordButton".localized, for: .normal)
        buttonChangePassword.titleLabel?.textAlignment = .center
    }
    
    // Make settings of rightBarButtonItems
    func setRightBarButtonItems() {
        
        //let arrowImage = UIImage(named: "arrow-down")!
        //let arrowButton : UIButton = UIButton.init(type: .custom)
        //arrowButton.setImage(arrowImage, for: .normal)
        //arrowButton.addTarget(self, action: #selector(didTapLanguageSettings), for: .touchUpInside)
        //arrowButton.frame = CGRect(x: 0, y: 0, width: 15, height: 30)
        //let arrowBarButton = UIBarButtonItem(customView: arrowButton)
        
        lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 24, height: 22))
        lbl?.text = "flagText".localized
        lbl?.textColor = .white
        lbl?.font = UIFont(name: "NotoSans", size: 18)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLanguageSettings(tapGestureRecognizer:)))
        lbl?.isUserInteractionEnabled = true
        lbl?.addGestureRecognizer(tapGestureRecognizer)
        let labelLanguage = UIBarButtonItem(customView: lbl!)
        
        //        let flagImage = UIImage.init(named: "flagImageName".localized)
        //        flagImageView = UIImageView.init(image: flagImage)
        //        flagImageView?.frame = CGRect(x: 0, y: 0, width: 28, height: 20)
        //        flagImageView?.contentMode = .scaleAspectFit
        //        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLanguageSettings(tapGestureRecognizer:)))
        //        flagImageView?.isUserInteractionEnabled = true
        //        flagImageView?.addGestureRecognizer(tapGestureRecognizer)
        //        let imageFlag = UIBarButtonItem.init(customView: flagImageView!)
        
        //navigationItem.setRightBarButtonItems([labelFR, imageFlag], animated: false)
        navigationItem.setRightBarButton(labelLanguage, animated: false)
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
    
    // Make alert appear
    private func makeAlertAppear(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func didTapLanguageSettings(tapGestureRecognizer: UITapGestureRecognizer)  {
        
        if UserDefaults.standard.string(forKey: "language_settings") == "fr" {
            UserDefaults.standard.set("en", forKey: "language_settings")
        } else {
            UserDefaults.standard.set("fr", forKey: "language_settings")
        }
        //        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        //        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
        updateUI()
    }
    
    private func updateUI() {
        self.lbl?.text = "flagText".localized
        //flagImageView?.image = UIImage(named: "flagImageName".localized)
        usernameTextfield.setTextfieldTextPlaceholderColor(withString: "email".localized)
        passwordTextfield.setTextfieldTextPlaceholderColor(withString: "password".localized)
        buttonSeConnecter.setTitle("loginButton".localized, for: .normal)
        buttonChangePassword.setTitle("resetPasswordButton".localized, for: .normal)
    }
    @IBAction func resetPasswordBtn(_ sender: Any) {
        performSegue(withIdentifier: "ResetPasswordVCSegueIdentifier", sender: self)
    }
    
    func configureResetPasswordSuccessMessageButtomView (message: String) {
        let messageView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 60, width: self.view.frame.width, height: 60))
        messageView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.88)
        let messageLbl = UILabel(frame: CGRect(x: 16, y: 0, width: messageView.frame.width - 32, height: 60))
        messageLbl.backgroundColor = UIColor.clear
        messageLbl.textColor = UIColor.white
        messageLbl.text = message
        messageLbl.textAlignment = .center
        messageLbl.font = messageLbl.font.withSize(17)
        messageLbl.adjustsFontSizeToFitWidth = true
        messageLbl.minimumScaleFactor = 0.5
        messageView.addSubview(messageLbl)
        //        self.navigationController?.view.addSubview(messageView)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(messageView)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            messageView.removeFromSuperview()
        }
    }
    
    func showSuccessMessage(_ controller: UIViewController, message: String) {
        configureResetPasswordSuccessMessageButtomView(message: message)
        controller.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResetPasswordVCSegueIdentifier" {
            let resetPasswordVC = segue.destination as! ResetPasswordController
            resetPasswordVC.delegate = self
        }
    }
    
}
