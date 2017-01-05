//
//  ParentViewController.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 28/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var tableView :UITableView!
    @IBOutlet var lblTitle  :UILabel!

    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?

    override func viewDidLoad() {
        super.viewDidLoad()
        constraintUpdate()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // This will update constaints and shrunk it as device screen goes lower.
    func constraintUpdate() {
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * _widthRatio
                const.constant = v2
            }
        }
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * _heighRatio
                const.constant = v2
            }
        }
    }

}

//MARK: Parent IBActions
extension ParentViewController {
    
    @IBAction func shutterButtonTapped(sender: UIButton?) {
        shutterActionBlock()
    }
    
    @IBAction func parentBackAction(sender: UIButton?) {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func parentDismissAction(sender: UIButton?) {
        self.dismiss(animated: true, completion: nil)
    }
}
