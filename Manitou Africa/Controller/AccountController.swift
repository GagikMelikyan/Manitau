//
//  AccountController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 2/14/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

class AccountController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var nsLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var buttonEnregistrer: UIButton!
    
    let imageNames = [["Padlock_red", "Envelope_red"], ["Envelope_red", "Civility_red", "Name_red", "Surname_red", "Addres_red", "Company_red", "Addres_red", "PostalCode_red", "area_red", "Country_red"]]
   
    let cellTitles = [["accountPass", "subscribe"], ["accountEmail", "accountGender", "accountFirstName", "accountLastName", "Phone", "accountCompany", "accountAddress", "accountPostCode", "accountArea", "accountCountry"]]
   
    var userData: User?
    var password: String?
    var switchON : Bool = false
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        setLayoutSubviews()
    }
    
    // Make alert appear
    private func makeAlertAppear(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func actionBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionSaveData(_ sender: UIButton) {
        
//        //Check this Part
        let indexPathAccount = IndexPath(row: 0, section: 0)
        let accountcell = tableView.cellForRow(at: indexPathAccount) as! AccountCell
        password = accountcell.accountTextField.text
        
        let indexPathNewsLetter = IndexPath(row: 1, section: 0)
        let emailSubscribeTableViewCell = tableView.cellForRow(at: indexPathNewsLetter) as! emailSubscribeTableViewCell
                    if emailSubscribeTableViewCell.cellSwitch.isOn {
                         switchON = true
                    } else if emailSubscribeTableViewCell.cellSwitch.isOn == false{
                        switchON = false
                    }
        
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        let changableData = ChangableData(password: password!, newsletter: switchON)
        APIManager.sharedInstance.submitChangedData(id, changableData: changableData) { (error, statusCode) in
            if let error = error {
                // got an error in getting the data, need to handle it
                print("error calling POST request")
                print(error)
                return
            }
            
            if let statusCode = statusCode {
                switch statusCode {
                case 200:
                    print("Good")
                default:
                    print ("No status code")
                }
            }
        }
        
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1)
        headerView.layer.addBorder(edge: .top, color: #colorLiteral(red: 0.9448053837, green: 0.9411252141, blue: 0.9496806264, alpha: 1), thickness: 0.5)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userInfo = self.userData
        
         if indexPath.section == 0 && indexPath.row == 1 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "emailSubscribeTableViewCell", for: indexPath) as! emailSubscribeTableViewCell
             cell.icon.image = UIImage(named:  imageNames[indexPath.section][indexPath.item])?.withRenderingMode(.alwaysTemplate)
             cell.icon.tintColor = .red
             cell.cellTitle.text = cellTitles[indexPath.section][indexPath.row].localized
            let switchState = userInfo?.newsletter
            if switchState == true {
                cell.cellSwitch.setOn(true, animated: true)
            } else if switchState == false {
                cell.cellSwitch.setOn(false, animated: true)
            }
             return cell
         }
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
         cell.accountImage.image = UIImage(named:  imageNames[indexPath.section][indexPath.item])?.withRenderingMode(.alwaysTemplate)
         cell.cellTitle.text = cellTitles[indexPath.section][indexPath.row].localized
        
        switch indexPath.section {
        case 0:
            cell.accountTextField.isEnabled = true
            switch indexPath.row {
            case 0:
                cell.accountTextField.isSecureTextEntry = true
                cell.accountTextField.text = userInfo?.password
            default:
                print("Don't find")
            }
        case 1:
            cell.accountTextField.textColor = .gray
            cell.cellTitle.textColor = .lightGray
            cell.accountTextField.isEnabled = false
            switch indexPath.row {
            case 0:
                cell.accountTextField.text = userInfo?.email
            case 1:
                cell.accountTextField.text = userInfo?.gender
            case 2:
                cell.accountTextField.text = userInfo?.firstName
            case 3:
                cell.accountTextField.text = userInfo?.lastName
            case 4:
                cell.accountTextField.text = userInfo?.phone
            case 5:
                cell.accountTextField.text = userInfo?.dealershipName
            case 6:
                cell.accountTextField.text = userInfo?.address
            case 7:
                cell.accountTextField.text = userInfo?.zip
            case 8:
                cell.accountTextField.text = userInfo?.area
            case 9:
                cell.accountTextField.text = userInfo?.city
            case 10:
                cell.accountTextField.text = userInfo?.dealershipName
            default:
                print("")
            }
        default:
            print("Don't find")
        }
        
        return cell
    }
    
    // Make view settings
    private func configureView() {
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        self.showActivityIndicator(show: true)
        
        let id = UserDefaults.standard.integer(forKey: "UserIdKey")
        getUser(id)
        
        nsLabel.layer.masksToBounds = true
        nsLabel.layer.borderColor = UIColor.white.cgColor
        
        buttonEnregistrer.clipsToBounds = true
        buttonEnregistrer.setTitle("saveButton".localized, for: .normal)
        buttonEnregistrer.titleLabel?.textAlignment = .center
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "emailSubscribeTableViewCell", bundle: nil), forCellReuseIdentifier: "emailSubscribeTableViewCell")
    }
    
    // Set layout subviews
    private func setLayoutSubviews() {
        nsLabel.layer.cornerRadius = nsLabel.frame.width / 2
        nsLabel.layer.borderWidth = 2
        buttonEnregistrer.layer.cornerRadius = 15
    }
    
    // MARK: - Activity Indicator
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
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
//            debugPrint(user)
            self.userData = user
            self.takeFirstLettersOfUserName()
            
            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()
                 self.showActivityIndicator(show: false)
            })
        })
    }
    
    private func takeFirstLettersOfUserName() {
        let firstName = self.userData?.firstName
        let lastname = self.userData?.lastName
        
        if let firstNameLetter = firstName?.prefix(1) {
            if let firstSurnameLetter = lastname?.prefix(1) {
                
                DispatchQueue.main.async(execute: {
                    self.nsLabel.text = "\(firstNameLetter)\(firstSurnameLetter)"
                })
            }
        }
        
    }
}
