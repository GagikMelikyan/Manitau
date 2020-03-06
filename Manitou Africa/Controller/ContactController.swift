//
//  ContactController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 5/10/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

class ContactController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet var emailView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var messageView: UIView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var buttonSend: UIButton!
    
    @IBOutlet var requestMessageView: UIView!
    @IBOutlet var requestMessageLabel: UILabel!
    
    var userData: User?
    var languageLabel: UILabel?
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestMessageView.isHidden = true
        configureView()
        startObservingKeyboardChanges()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        setLayoutSubviews()
    }
    
    
    @IBAction func actionSend(_ sender: Any) {
        messageTextField.resignFirstResponder()
        
        sendPasswordPOSTRecuest(emailAddress: emailTextField.text!, message: messageTextField.text!, name: nameTextField.text!)
        self.buttonSend.isEnabled = false
    }
    
    // UITextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == messageTextField {
            messageTextField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        messageTextField.text = ""
    }
    
    // Make settings of leftBarButtonItems
    func setLeftBarButtonItems() {
        let menuImage = UIImage(named: "Menu")!
        let menuBtn: UIButton = UIButton.init(type: .custom)
        menuBtn.setImage(menuImage, for: UIControl.State.normal)
        menuBtn.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let menuBarBtn = UIBarButtonItem(customView: menuBtn)
        
        let logoImage = UIImage.init(named: "manitou-logo-black")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        navigationItem.setLeftBarButtonItems([menuBarBtn, imageItem], animated: false)
    }
    
    // Make settings of rightBarButtonItems
    func setRightBarButtonItems() {
        let profImage = UIImage(named: "User_user")!
        let profButton : UIButton = UIButton.init(type: .custom)
        profButton.setImage(profImage, for: .normal)
        profButton.addTarget(self, action: #selector(didTapAccountButton), for: .touchUpInside)
        profButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let profBarButton = UIBarButtonItem(customView: profButton)
        
        languageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 24, height: 22))
        languageLabel?.text = "flagText".localized
        languageLabel?.textColor = .black
        languageLabel?.font = UIFont(name: "NotoSans", size: 18)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLanguageSettings(tapGestureRecognizer:)))
        languageLabel?.isUserInteractionEnabled = true
        languageLabel?.addGestureRecognizer(tapGestureRecognizer)
        let labelLanguage = UIBarButtonItem(customView: languageLabel!)
        
        navigationItem.setRightBarButtonItems([profBarButton, labelLanguage], animated: false)
    }
    
    // Make view settings
    private func configureView() {
        
        addShadowToTheNavigationBar()
        setLeftBarButtonItems()
        setRightBarButtonItems()
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        self.showActivityIndicator(show: true)
        
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        getUser(id)
        
        containerView.layer.masksToBounds = true
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        messageTextField.delegate = self
        
        nameTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        
        addBorderAndRadius(view: emailView)
        addBorderAndRadius(view: nameView)
        addBorderAndRadius(view: messageView)
        
        buttonSend.clipsToBounds = true
        messageView.clipsToBounds = true
        updateUI()
    }
    
    
    private func addBorderAndRadius(view: UIView) {
        let borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)
        view.layoutIfNeeded()
        view.layer.borderWidth = 2.5
        view.layer.borderColor = borderColor.cgColor
        view.layer.cornerRadius = 5
    }
    
    // Set layout subviews
    private func setLayoutSubviews() {
        
        containerView.layer.cornerRadius = 5
        buttonSend.layer.cornerRadius = 5
        messageView.layer.borderWidth = 2.5
    }
    
    private func addShadowToTheNavigationBar() {
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(red: 195/255.0, green: 195/255.0, blue: 195/255.0, alpha: 1).cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
    }
    
    @objc func didTapMenuButton()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapAccountButton()  {
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountNavigationController") as! AccountNavigationController
        self.present(accountVC, animated: true, completion: nil)
    }
    
    // MARK: - Activity Indicator
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // NotificationCenter observers
    private func startObservingKeyboardChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(ContactController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    @objc func didTapLanguageSettings(tapGestureRecognizer: UITapGestureRecognizer)  {
        
        if UserDefaults.standard.string(forKey: "language_settings") == "fr" {
            UserDefaults.standard.set("en", forKey: "language_settings")
        } else {
            UserDefaults.standard.set("fr", forKey: "language_settings")
        }
        
        updateUI()
    }
    
    private func updateUI() {
        titleLabel.text = "Contact".localized
        subTitleLabel.text = "sendUsAMessage".localized
        nameLabel.text = "name".localized
        emailLabel.text = "email".localized
        messageLabel.text = "message".localized
        nameTextField.placeholder = "name".localized
        messageTextField.placeholder = "messageTextPlacholder".localized

        languageLabel?.text = "flagText".localized
        buttonSend.setTitle("SendTitle".localized, for: .normal)
    }
    
    private func makeAlertAppear(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func sendPasswordPOSTRecuest (emailAddress: String, message: String, name: String) {
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        var parameters = [String : Any]()
        parameters["email"] = emailAddress
        parameters["message"] = message
        parameters["firstName"] = name
        if UserDefaults.standard.string(forKey: "language_settings") == "fr" {
            parameters["language"] = "fr"
        }
        
        //create the url with URL
        let url = URL(string: "https://api.challengeafrica-manitou.com/v1/contact")! //change the url
        
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
                            self.requestMessageLabel.text = message
                            self.requestMessageLabel.textColor = UIColor.white
//                            self.requestMessageView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.85)
                            self.requestMessageView.isHidden = false
                        }
                    } else if let errors = json["errors"] as? [String : Any] {
                        DispatchQueue.main.async {
                            let title = "Error"
                            let message = errors["message"] as! String
                            self.makeAlertAppear(title: title, message: message, actionTitle: "Ok")
                            self.requestMessageView.isHidden = false
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                        self.requestMessageView.isHidden = true
                        self.buttonSend.isEnabled = true
                    }
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    // Get user info from server
    private func getUser(_ idNumber: Int) {
        APIManager.sharedInstance.getUser(idNumber, completionHandler: { (user, error) in
            
            if let error = error {
                // got an error in getting the data, need to handle it
                print("error calling POST on /todos")
                print(error)
                return
            }
            guard let user = user else {
                print("error getting user: result is nil")
                return
            }
            
            // success :)
            // debugPrint(user)
            self.userData = user
            DispatchQueue.main.async(execute: {
                if let userName = self.userData?.firstName, let userLastname = self.userData?.lastName {
                    self.nameTextField.text = "\(userName) \(userLastname)"
                }
                
                if let email = self.userData?.email {
                    self.emailTextField.text = "\(email)"
                }
                
                self.showActivityIndicator(show: false)
            })
            
        })
    }
}
