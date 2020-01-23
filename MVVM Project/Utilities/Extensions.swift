//
//  Extensions.swift
//  MVVM Project
//
//  Created by Nimish Sharma on 21/01/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

/**
 A UIView extension that makes adding basic animations, like fades and bounces, simple.
 */
extension UIView {
    
    /**
     Edge of the view's parent that the animation should involve
     - none: involves no edge
     - top: involves the top edge of the parent
     - bottom: involves the bottom edge of the parent
     - left: involves the left edge of the parent
     - right: involves the right edge of the parent
     */
    enum SimpleAnimationEdge {
        case none
        case top
        case bottom
        case left
        case right
    }
    
    
    /**
     Causes the view to shake, either toward a particular edge or in all directions (if "toward" is
     .None).
     - Parameters:
     - toward: the edge to shake toward, or .None to shake in all directions
     - amount: distance to shake, expressed as a fraction of the view's size
     - duration: duration of the animation, in seconds
     - delay: delay before the animation starts, in seconds
     - completion: block executed when the animation ends
     */
    @discardableResult func shake(toward edge: SimpleAnimationEdge = .none,
                                  amount: CGFloat = 0.15,
                                  duration: TimeInterval = 0.6,
                                  delay: TimeInterval = 0,
                                  completion: ((Bool) -> Void)? = nil) -> UIView {
        let steps = 8
        let timeStep = 1.0 / Double(steps)
        var dx: CGFloat, dy: CGFloat
        if edge == .left || edge == .right {
            dx = (edge == .left ? -1 : 1) * self.bounds.size.width * amount;
            dy = 0
        } else {
            dx = 0
            dy = (edge == .top ? -1 : 1) * self.bounds.size.height * amount;
        }
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
                var start = 0.0
                for i in 0..<(steps - 1) {
                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: timeStep) {
                        self.transform = CGAffineTransform(translationX: dx, y: dy)
                    }
                    if (edge == .none && i % 2 == 0) {
                        swap(&dx, &dy)  // Change direction
                        dy *= -1
                    }
                    dx *= -0.85
                    dy *= -0.85
                    start += timeStep
                }
                UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: timeStep) {
                    self.transform = .identity
                }
        }, completion: completion)
        return self
    }
}


extension UITableView {
    ///Register Table View Cell Nib
    func registerCell(with identifier: UITableViewCell.Type)  {
        self.register(UINib(nibName: "\(identifier.self)",bundle:nil),
                      forCellReuseIdentifier: "\(identifier.self)")
        
    }
    
    ///Dequeue Table View Cell
    func dequeueCell <T: UITableViewCell> (with identifier: T.Type, indexPath: IndexPath? = nil) -> T {
        if let index = indexPath {
            return self.dequeueReusableCell(withIdentifier: "\(identifier.self)", for: index) as! T
        } else {
            return self.dequeueReusableCell(withIdentifier: "\(identifier.self)") as! T
        }
    }
}

extension UICollectionView {
    ///Register Collection View Cell Nib
    func registerCell(with identifier: UICollectionViewCell.Type)  {
        self.register(UINib(nibName: "\(identifier.self)", bundle: nil), forCellWithReuseIdentifier: "\(identifier.self)")
    }
    
    ///Dequeue Collection View Cell
    func dequeueCell <T: UICollectionViewCell> (with identifier: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: "\(identifier.self)", for: indexPath) as! T
    }
}

extension UITableViewCell {
    var indexPathInTableView: IndexPath? {
        if let tableView = self.superview as? UITableView, let indexPath = tableView.indexPath(for: self) {
            return indexPath
        }
        return nil
    }
    
}

extension UIAlertAction {
    func setImage(_ image: UIImage) {
        self.setValue(image, forKey: "image")
    }
    
    func setTextAlignment(_ alignment: CATextLayerAlignmentMode) {
        self.setValue(alignment, forKey: "titleTextAlignment")
    }
}
