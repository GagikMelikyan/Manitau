//
//  NewPostController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 5/28/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

typealias Parameters = [String: String]

class NewPostController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var ContentTextField: UITextField!
    @IBOutlet var postButton: UIButton!
    @IBOutlet var titleView: UIView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var illustrationImageView: UIImageView!
    @IBOutlet var addPostimageBtn: UIButton!
    
    var languageLabel: UILabel?
    weak var delegate: SuccessMessageDelegate?
    
    let imagePicker = UIImagePickerController()
    var imageUrl: URL?
    var imageData: Data?
    
    lazy var indicator: IndikatorView = {
        let activityIndicator = IndikatorView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        return activityIndicator
    }()
    
    //    var indicator = IndikatorView()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        indicator = IndikatorView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        configureView()
        startObservingKeyboardChanges()
        
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        setLayoutSubviews()
    }
    
    // UITextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            ContentTextField.becomeFirstResponder()
        } else if textField == ContentTextField {
            ContentTextField.resignFirstResponder()
        }
        return true
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
        
        containerView.layer.masksToBounds = true
        
        titleTextField.delegate = self
        ContentTextField.delegate = self
        
        let borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        
        titleView.layer.borderColor = borderColor.cgColor
        contentView.layer.borderColor = borderColor.cgColor
        
        postButton.clipsToBounds = true
        titleTextField.clipsToBounds = true
        ContentTextField.clipsToBounds = true
        
    }
    
    // Set layout subviews
    private func setLayoutSubviews() {
        
        containerView.layer.cornerRadius = 5
        postButton.layer.cornerRadius = 5
        titleView.layer.cornerRadius = 5
        titleView.layer.borderWidth = 2.5
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 2.5
    }
    
    private func addShadowToTheNavigationBar() {
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(red: 195/255.0, green: 195/255.0, blue: 195/255.0, alpha: 1).cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
    }
    
    @objc func didTapMenuButton()  {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapAccountButton()  {
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountNavigationController") as! AccountNavigationController
        self.present(accountVC, animated: true, completion: nil)
    }
    
    // NotificationCenter observers
    private func startObservingKeyboardChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(NewPostController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewPostController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        languageLabel?.text = "flagText".localized
        self.addPostimageBtn.setTitle("addPostimageBtn".localized, for: .normal)
    }
    
    private func makeAlertAppear(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func addiIllustrationImageBtn(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtn(_ sender: Any) {
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        let userID = "\(id)"
        var imageFeatured = UIImage()
        if let image = self.illustrationImageView.image {
            imageFeatured = image
        }
        self.postAPostAPIPOSTRecuest(title: titleTextField.text ?? "", content: ContentTextField.text ?? "", userID: userID, imageFeatured: imageFeatured)
        self.view.addSubview(self.indicator)
    }
    
    private func postAPostAPIPOSTRecuest (title: String, content: String, userID: String, imageFeatured: UIImage) {
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        let parameters = ["title": title,
                          "author": userID,
                          "content": content]
        
        
        guard let mediaImage = Media(withImage: imageFeatured, forKey: "imageFeatured") else { return }
        //create the url with URL
        let urlAPI = URL(string: "\(URL_BASE_API)/\(API_VERSION)/media_objects")
        guard let url = urlAPI else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
        let tokenId  = UserDefaults.standard.string(forKey: "accessTokenKey")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer Token \(tokenId!)", forHTTPHeaderField: "Authorization")
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        DispatchQueue.main.async {
                            self.indicator.removeFromSuperview()
                            let title = json["hydra:title"] as? String
                            if let message = json["hydra:description"] as? String {
                                self.makeAlertAppear(title: title ?? "", message: message, actionTitle: "OK")
                            } else {
                                self.delegate?.showSuccessMessage(self, message: "postResponseSuccess".localized)
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}


