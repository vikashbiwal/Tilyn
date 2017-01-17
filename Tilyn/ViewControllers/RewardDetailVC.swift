//
//  RewardDetailVC.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 16/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class RewardDetailVC: ParentViewController {

    @IBOutlet weak var imgvCover:       UIImageView!
    @IBOutlet weak var imgvStore:       UIImageView!
    @IBOutlet weak var lblStoreAddress: UILabel!
    @IBOutlet weak var lblRewardName : UILabel!
    
    var reward: Reward!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareUIWithValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareUIWithValues() {
        lblTitle.text = reward.title
        lblStoreAddress.text = reward.address
        lblRewardName.text = reward.description
        imgvCover.kf.setImage(with: URL(string: reward.imageUrl))
        imgvStore.kf.setImage(with: URL(string : reward.imgBusinessUrl))
    }

}