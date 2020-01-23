//
//  AppStoryboard.swift
//  MVVM Project
//
//  Created by Nimish Sharma on 22/01/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import UIKit

enum AppStoryboard : String {
    case Main
}

extension AppStoryboard {
    
    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(_ viewControllerClass : T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}

extension UIViewController {
    
    static var storyboardID : String {
         return "\(self)"
     }
     
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(self)
    }
}
