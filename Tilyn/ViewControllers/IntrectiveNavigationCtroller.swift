//
//  IntrectiveNavigationCtroller.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 05/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class IntrectiveNavigationCtroller: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf: IntrectiveNavigationCtroller? = self
        self.interactivePopGestureRecognizer?.delegate = weakSelf!
        self.delegate = weakSelf!
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        if self.viewControllers.count > 1{
            return true
        }else{
            return false
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Add every non interactive view controller so controller dont go back automatically.
         //Currently ManUpTabBarController should not be back interactive
                if viewController is ContainerVC {
                    self.interactivePopGestureRecognizer!.isEnabled = false
                }else{
                    self.interactivePopGestureRecognizer!.isEnabled = true
                }
    }

}
