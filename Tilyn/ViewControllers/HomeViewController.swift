//
//  HomeViewController.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 29/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class HomeViewController: ParentViewController {

    @IBOutlet var horizontalMenuContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHorizontalMenuView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Load Horizontal Menu view
    func loadHorizontalMenuView() {
        let menuItems = [MenuItem("REWARDS", selected: true),
                         MenuItem("NEAR YOU"),
                         MenuItem("SPECIAL OFFERS")]
        
        let hview =  HorizontolMenuView.loadFromNib()
        hview.menuItems = menuItems
        hview.frame = horizontalMenuContainerView.bounds
        self.horizontalMenuContainerView.addSubview(hview)
    }
}
