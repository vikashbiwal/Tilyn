//
//  LoginViewController.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 30/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import  FBSDKLoginKit

class LoginViewController: ParentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _application.statusBarStyle = .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func facebookLoginBtnTapped(sender: UIButton) {
        //self.performSegue(withIdentifier: "LoginToHomeSegue", sender: nil)
        //loginWithFacebook()
        let params = ["vFacebookId" : "6545456454545",
                      "vEmail" : "vikash@gmail.com",
                      "vProfileImage": "https://static.pexels.com/photos/20974/pexels-photo.jpg",
                      "vFullName" : "Vikash kumar",
                      "eDeviceType" : "ios"]
        wsCall.facebookLogin(param: params) {(res, code) in
         //print(res)
        }
    }
    
    
    func loginWithFacebook() {
        let fbloginManager  = FBSDKLoginManager()
        fbloginManager.logOut()
        fbloginManager.logIn(withReadPermissions: _fbLoginReadPermissions, from: self, handler: {(loginResult, error) in
            if let  _ =  error {
                //login error
                
            } else if loginResult!.isCancelled {
                //cancel.
                
            } else {
                //succes
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : _fbUserInfoRequestParam])
                _ = request?.start(completionHandler: { (con, result, error) in
                    if let _ = error {
                        //error
                    }
                    
                    //getProfile image url from fb data
                    if let info = result as? [String : Any] {
                        print("Facebook Info : \(info)")
                        var imgageUrl = ""
                        if let picture = info["picture"] as? [String : Any]  {
                            if let data = picture["data"] as? [String : Any] {
                                if let url = data["url"] as? String {
                                    imgageUrl = url
                                    print(imgageUrl)
                                }
                            }
                        }

                    }
                    
                    //Login APICall
                })
            }

            
        })
    }
}
