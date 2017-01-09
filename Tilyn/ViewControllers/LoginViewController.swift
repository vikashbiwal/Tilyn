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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func facebookLoginBtnTapped(sender: UIButton) {
//        self.performSegue(withIdentifier: "LoginToHomeSegue", sender: nil)
        self.loginWithFacebook()
    }
    
    
}

//MARK: Webservice Calls
extension LoginViewController {
    
    //Take grant from facebook user and get (user informations) parameters from facebook.
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
                        //Login APICall
                        self.loginWithFacebookAPICall(fbInfo: info)
                    } else {
                        /// data not found
                    }
                    
                })
            }
            
            
        })
    }

    //Send user data on Tyli server
    func loginWithFacebookAPICall(fbInfo : [String : Any]) {
       
        let fbID = fbInfo["id"] as! String
        let email = (fbInfo["email"] as? String) ?? ""
        let name = fbInfo["name"] as! String
        
        var imgageUrl = ""
        if let picture = fbInfo["picture"] as? [String : Any]  {
            if let data = picture["data"] as? [String : Any] {
                if let url = data["url"] as? String {
                    imgageUrl = url
                    print(imgageUrl)
                }
            }
        }

        let params = ["vFacebookId" : fbID,
                      "vEmail" : email,
                      "vProfileImage": imgageUrl,
                      "vFullName" : name,
                      "eDeviceType" : "ios"]
        
        wsCall.facebookLogin(param: params) { response in
            if response.isSuccess {
                if let  json = response.json as? [String : Any] {
                    if let data = json["data"] as? [String : Any] {
                        me = User(data)
                        archiveObject(data , key: kLoggedInUserKey)
                       
                        let authToken = RConverter.string(data["vAuthToken"])
                        wsCall.setAccesTokenToHeader(token: authToken)
                        
                        self.performSegue(withIdentifier: "LoginToHomeSegue", sender: nil)
                    }
                }
            } else {
                ShowToastMessage(title: "", message: response.message)
            }
        }
    }
}
