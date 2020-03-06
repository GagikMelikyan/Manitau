//
//  ResultsPageViewController.swift
//  Manitou Africa
//
//  Created by Ruzanna Sedrakyan on 2/26/19.
//  Copyright © 2019 Ruzanna Sedrakyan. All rights reserved.
//

import UIKit

protocol DataDelegate: AnyObject {
    func webViewLoadFunction()
    func updateLabelsText()
}

class ResultsPageViewController: UIPageViewController,UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var viewControllerList: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = storyboard.instantiateViewController(withIdentifier: "MyPoints") as! ResultsMyPoints
        let vc2 = storyboard.instantiateViewController(withIdentifier: "SalesRevenueTarget") as! ResultsSalesRevenueTarget
        let vc3 = storyboard.instantiateViewController(withIdentifier: "ProductsPromotionTarget") as! ResultsProductsPromotionTarget
        let vc4 = storyboard.instantiateViewController(withIdentifier: "MarketingOperationTarget") as! ResultsMarketingOperationTarget
        
        return [vc1, vc2, vc3, vc4]
    }()
    
    weak var dataDelegate: DataDelegate?
    var languageLabel: UILabel?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.lastIndex(of: viewController) else {return nil}

        let previousIndex = vcIndex - 1

        guard previousIndex >= 0 else {return nil}

        guard viewControllerList.count > previousIndex else {return nil}

        return viewControllerList[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}

        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else {return nil}

        guard viewControllerList.count > nextIndex else {return nil}

        return viewControllerList[nextIndex]


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
        let profImage = UIImage(named: "user")!
        let profButton : UIButton = UIButton.init(type: .custom)
        profButton.setImage(profImage, for: .normal)
        profButton.addTarget(self, action: #selector(didTapAccountButton), for: .touchUpInside)
        profButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
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
        self.delegate = self
        self.dataSource = self
        
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)

        }
        
        addShadowToTheNavigationBar()
        setLeftBarButtonItems()
        setRightBarButtonItems()
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
    
    @objc func didTapLanguageSettings(tapGestureRecognizer: UITapGestureRecognizer)  {
        
        if UserDefaults.standard.string(forKey: "language_settings") == "fr" {
            UserDefaults.standard.set("en", forKey: "language_settings")
        } else {
            UserDefaults.standard.set("fr", forKey: "language_settings")
        }
        updateUI()
    }
    
    func updateUI() {
        languageLabel?.text = "flagText".localized
        dataDelegate?.webViewLoadFunction()
        dataDelegate?.updateLabelsText()
    }
    
}

