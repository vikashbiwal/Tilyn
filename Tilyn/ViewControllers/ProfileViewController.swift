//
//  ProfileViewController.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 04/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileViewController: ParentViewController {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setProfileInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Set user's profile info
    func setProfileInfo() {
        lblName.text = me.name
        lblEmail.text = me.email
        imgProfile.kf.setImage(with: URL(string: me.profileImage))
    }

    //MARK: IBAction
    @IBAction func deleteAccountBtnTapped(sender: UIButton) {
       let alert = UIAlertController(title: _appName, message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {action in
            self.deleteAccountAPICall()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: APICall
    func deleteAccountAPICall() {
        let param = ["iUserId" : me.id]
        wsCall.deleteAccount(param: param) { response in
            if response.isSuccess {
                 FBSDKLoginManager().logOut()
                _userDefault.removeObject(forKey: kLoggedInUserKey)
                _ = self.navigationController?.popToRootViewController(animated: true)
            } else {
                ShowToastErrorMessage("", message: response.message)
            }
        }
    }
}
