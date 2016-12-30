//
//  LoginViewController.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 30/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

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
        self.performSegue(withIdentifier: "LoginToHomeSegue", sender: nil)
    }
    
}
