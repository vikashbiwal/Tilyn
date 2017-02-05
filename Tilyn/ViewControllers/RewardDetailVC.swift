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

    //MARK: IBActions
    @IBAction func redeemBtnTapped(sender: UIButton) {
        self.redeemRewardAPICall()
    }
    
}

extension RewardDetailVC {
    func redeemRewardAPICall() {
        self.showCentralGraySpinner()
        let param = ["iRewardId" : reward.id,
                     "iUserId" : me.id,
                     "iRedeemFlag" : "1"]
        wsCall.redeemReward(params: param) { response in
            if response.isSuccess {
//                if let json = response.json as? [String : Any] {
//                    
//                
//                }
                
            } else {
                ShowToastErrorMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
}
