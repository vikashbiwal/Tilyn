//
//  OfferDetailVC.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 16/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class OfferDetailVC: ParentViewController {

    @IBOutlet weak var imgvCover:       UIImageView!
    @IBOutlet weak var imgvStore:       UIImageView!
    @IBOutlet weak var lblOfferTitle:   UILabel!
    @IBOutlet weak var lblOfferTime:    UILabel!
    @IBOutlet weak var lblStoreAddress: UILabel!
    
    var offer: Offer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUIWithValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func prepareUIWithValues() {
        lblOfferTitle.text = offer.title
        lblOfferTime.text = offer.startDate
        lblTitle.text = offer.businessName
        lblStoreAddress.text = offer.businessAddress
        
        imgvCover.kf.setImage(with: URL(string: offer.offerImgUrl))
        imgvStore.kf.setImage(with: URL(string : offer.businessImgUrl))
    }
    
    //MARK: IBActions
    
    @IBAction func callBtnClicked(sender: UIButton) {
        self.makeACall(at: offer.businessContactNumber)
    }
    
    @IBAction func shareBtnClicked(sender: UIButton) {
        let shareItems = [offer.title]
        self.showShareView(for: shareItems)
    }
    
    func makeACall(at number: String) {
        if UIApplication.shared.canOpenURL(URL(string: "tel://")!) {
            UIApplication.shared.openURL(URL(string: "tel://\(number)")!)
        }
    }
}

