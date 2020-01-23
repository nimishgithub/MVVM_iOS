//
//  CommonFunctions.swift
//  MVVM Project
//
//  Created by Nimish Sharma on 23/01/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import UIKit


struct CommonFunctions {
    
    /// Show Action Sheet With Actions Array
    static func showActionSheetWithActionArray(_ title: String? = nil, message: String? = nil,
                                              viewController: UIViewController,
                                              alertActionArray : [UIAlertAction],
                                              preferredStyle: UIAlertController.Style)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alertActionArray.forEach{ alert.addAction($0) }
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    // Native alert with one Button
    static func showAlert(_ title: String, _ msg : String, onVC: BaseUIViewController, completion : (() -> Swift.Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: AppTexts.ok, style: UIAlertAction.Style.default) { (action : UIAlertAction) -> Void in
            completion?()
            
            alertViewController.dismiss(animated: true, completion: nil)
        }
        alertViewController.addAction(okAction)
        onVC.present(alertViewController, animated: true, completion: nil)
    }
    
}
