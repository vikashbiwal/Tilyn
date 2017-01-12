//
//  ContainerVC.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 28/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ContainerVC: ParentViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var containerViewLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var menuViewLeadingSpace: NSLayoutConstraint!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var isShutterOpened = false
    let shutterMaxXValue = 300 * _widthRatio
    var menus : [MenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.setShutterActionBlock()
        self.setMenuItems()
        self.setProfileInfo()
    }

    //Set user's profile info
    func setProfileInfo() {
        //lblName.text = me.name
        lblEmail.text = me.email
        imgProfile.kf.setImage(with: URL(string: me.profileImage))
    }


    //Set Slider Menu items
    func setMenuItems() {
        menus = [MenuItem("Home", imageName: "ic_home", selected : true),
                 MenuItem("Settings", imageName: "ic_Settings"),
                 MenuItem("Log Out", imageName: "ic_logout")]
    }
    
    var tabbarController: UITabBarController? {
        for vc in self.childViewControllers {
            if vc is CustomTabbarController {
                return vc as? UITabBarController
            } else {
                return nil
            }
        }
        return nil
    }
}

//MARK: Slider Shutter setup and action
extension ContainerVC : UIGestureRecognizerDelegate {
   
    //Shutter block initialization
    func setShutterActionBlock() {
        shutterActionBlock = {[unowned self] in
            self.openCloseShutter()
        }
    }
    
    //Shutter Actions
    func openCloseShutter() {
        self.view.layoutIfNeeded()
        var x: CGFloat = 0
        var mx: CGFloat = 0 //for menu container x
        if isShutterOpened {
            isShutterOpened = false
            x = 0
            mx = -100 //menu view scroll at leading side
        } else {
            isShutterOpened = true
            x = shutterMaxXValue
            mx = 0
            //tabbarController.view.addSubview(transparentControl)
            
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerViewLeadingSpace.constant = x
            self.menuViewLeadingSpace.constant = mx
            //self.transparentControl.alpha = self.isShutterOpened ? 1 : 0
            self.view.layoutIfNeeded()
        }, completion: { (res) in
            if !self.isShutterOpened {
                //self.transparentControl.removeFromSuperview()
            }
        })
    }
    
    
    //Handle gesture event
    func screenEdgeGestureAction(gesture: UIPanGestureRecognizer) {
        let velocity =  gesture.velocity(in: self.view)
        print("Velocity : \(velocity.x)")
        let translation = gesture.translation(in: self.view)
       print("Translation in x : \(translation.x)")
       
    }
    
    //Gesture Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        print("main \(gestureRecognizer)")
//        print("Other \(otherGestureRecognizer)")
        return true
    }

}


//MARK: TableView DataSource and Delegate

extension ContainerVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let item = menus[indexPath.row]
        cell.lblTitle.text = item.title
        cell.imgView.image = UIImage(named: item.imageName)
        if #available(iOS 10.0, *) {
            cell.backgroundColor = item.selected ? UIColor.black.withAlphaComponent(7) : UIColor(displayP3Red: 48.0/255.0, green: 60.0/255.0, blue: 63.0/255.0, alpha: 1)
        } else {
            // Fallback on earlier versions
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {//Home
            tabbarController?.selectedIndex = 0
            
        }  else if indexPath.row == 1 { //Settings
            tabbarController?.selectedIndex = 2
            
        } else if indexPath.row == 2 { //Log Out
            //Logout
            self.logout_Action()
        }
        
        if indexPath.row != 2 { //not perfom for logout action
            _ = menus.map {(menu) -> MenuItem in
                menu.selected = false
                return menu
            }
            menus[indexPath.row].selected = true
            tableView.reloadData()
        }
        self.openCloseShutter()
    }
    
    @IBAction func profileBtnTapped(sender: UIButton) {
        tabbarController?.selectedIndex = 1
        self.openCloseShutter()
    }
    
}

extension ContainerVC {
    func logout_Action() {
        let alert = UIAlertController(title: _appName, message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {action in })
        let acceptAction = UIAlertAction(title: "Logout", style: .destructive, handler: {action in
            FBSDKLoginManager().logOut()
            _userDefault.removeObject(forKey: kLoggedInUserKey)
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        alert.addAction(cancelAction)
        alert.addAction(acceptAction)
        self.present(alert, animated: true, completion: nil)

    }
}
