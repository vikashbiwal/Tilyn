//
//  ContainerVC.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 28/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class ContainerVC: ParentViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var containerViewLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var menuViewLeadingSpace: NSLayoutConstraint!
    
    var isShutterOpened = false
    let shutterMaxXValue = 300 * _widthRatio
    var menus : [MenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.setShutterAtionBlock()
        self.setMenuItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //Set Slider Menu items
    func setMenuItems() {
        menus = [MenuItem("Home", imageName: "ic_profile_small", selected : true),
                 MenuItem("Profile", imageName: "ic_profile_small"),
                 MenuItem("Settings", imageName: "ic_Settings"),
                 MenuItem("Log Out", imageName: "ic_Settings")]
    }
}

//MARK: Slider Shutter setup and action
extension ContainerVC {
    //Shutter block initialization
    func setShutterAtionBlock() {
        shutterActioinBlock = {[unowned self] in
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
            _application.statusBarStyle = .default
        } else {
            isShutterOpened = true
            x = shutterMaxXValue
            mx = 0
            _application.statusBarStyle = .lightContent
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
    
    
    
    @IBAction func screenEdgeGestureAction(gesture: UIScreenEdgePanGestureRecognizer) {
        print(gesture)
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
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
