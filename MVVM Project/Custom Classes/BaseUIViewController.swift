//
//  BaseUIViewController.swift
//  MVVM Project
//
//  Created by Nimish Sharma on 21/01/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Can be overridden
    @objc func leftBarButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonTapped(){
        
    }
    
    // MARK: Public Methods
    final func setNavigationBar(title: String = "",
                                largeTitles: Bool = false) {
        self.navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.barTintColor = AppColors.appDarkBlue
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.prefersLargeTitles = largeTitles
  
    }

    func addRightButtonToNavigation(title : String? = nil, titleColor: UIColor = .black, image: UIImage? = nil, font: UIFont? = nil){
        let rightButton = UIButton(type: .custom)
        if let title = title{
            rightButton.setTitle(title, for: .normal)
        }
        rightButton.setTitleColor(titleColor, for: .normal)
        if let providedFont = font {
            rightButton.titleLabel?.font = providedFont
        } else {
            rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        }
        if let image = image{
            rightButton.setImage(image, for: .normal)
        }
        rightButton.addTarget(self, action: #selector(rightBarButtonTapped), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func addLeftButtonToNavigation(title : String? = nil, titleColor: UIColor = .black, image: UIImage? = nil, font: UIFont? = nil){
        let leftButton = UIButton(type: .custom)
        if let title = title{
            leftButton.setTitle(title, for: .normal)
        }
        leftButton.setTitleColor(titleColor, for: .normal)
        if let providedFont = font {
            leftButton.titleLabel?.font = providedFont
        } else {
            leftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        }
        if let image = image{
            leftButton.setImage(image, for: .normal)
        }
        
        if title != nil, image != nil {
            leftButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            leftButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        }
        leftButton.addTarget(self, action: #selector(leftBarButtonTapped), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    

}
