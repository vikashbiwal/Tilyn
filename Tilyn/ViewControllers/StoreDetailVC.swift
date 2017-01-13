//
//  StoreDetailVC.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 05/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import  GoogleMaps

class StoreDetailVC: ParentViewController {

    //Constats
    let kSectionForStoreInfo = 0
    let kSectionForVisitInfo = 1
    let kSectionForOfferInfo = 2
    let kSectionForMapInfo   = 3
    let kSectionForShareInfo = 4
    
    //Variables
    var store : Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = store.title
        self.getStoreDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//MARK: IBActions
extension StoreDetailVC {
    
    @IBAction func shareBtnTapped(sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: ["Hi friends"], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
}
//MARK: TableView DataSource and Delegate
extension StoreDetailVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case kSectionForStoreInfo :
            return 1
        case kSectionForVisitInfo :
            return 1
        case kSectionForOfferInfo :
            return 1
        case kSectionForMapInfo :
            return 1
        case kSectionForShareInfo :
            return 1

        default :
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == kSectionForStoreInfo {
            let cell = tableView.dequeueReusableCell(withIdentifier: "storeInfoCell") as! StoreInfoCell
            cell.setInfo(for: store)
            return cell
            
        } else if indexPath.section == kSectionForVisitInfo {//visitCountCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "visitCountCell") as! VisitInfoCell
            cell.rewards = store.rewards
            cell.collView.reloadData()
            return cell
            
        } else if indexPath.section == kSectionForOfferInfo {
            let cell = tableView.dequeueReusableCell(withIdentifier: "specialOfferCell") as! OffeerCell
            cell.lblTitle.text = "Today's Special Offers"
            cell.offers = store.offers
            cell.collView.reloadData()
            return cell
            
        } else if indexPath.section == kSectionForMapInfo { //mapCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell") as! MapInfoCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shareCell") as! TableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == kSectionForMapInfo {
            let cl = cell as! MapInfoCell
            cl.setMapInfo(for: store)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case kSectionForStoreInfo:
            return 150 * _widthRatio
        case kSectionForVisitInfo :
            return  store.rewards.isEmpty ? 0 : 110 * _widthRatio
        case kSectionForOfferInfo :
            return store.offers.isEmpty ? 0 : 150 * _widthRatio
        case kSectionForMapInfo:
            return 300 * _widthRatio
        case kSectionForShareInfo:
            return 40 * _widthRatio
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}

//MARK: Webservice Calls
extension StoreDetailVC {
    
    func getStoreDetails() {
        self.showCentralGraySpinner()
        let params = ["iUserId" : me.id,
                      "iBusinessId" : store.id]
        wsCall.getBusinessDetails(params: params) { response in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let obj = json["data"] as? [String : Any] {
                      self.store.setInfo(obj)
                        self.tableView.reloadData()
                    }
                }
            } else {
                ShowToastErrorMessage("", message: response.message)
            }
            
            self.hideCentralGraySpinner()
        }
    }
    
}


//==================================================================================================================
//====================================================== Cells =====================================================
//==================================================================================================================

//MARK: TableView Cells

class StoreInfoCell : TableViewCell {
    @IBOutlet var imgvCover: UIImageView!
    
    override func awakeFromNib() {
         super.awakeFromNib()
    }
    
    func setInfo(for store: Business) {
        self.lblTitle.text = store.description
        self.lblSubTitle.text = store.website
        self.imgView.kf.setImage(with: URL(string: store.iconUrl))
        self.imgvCover.kf.setImage(with: URL(string : store.imageUrl))
    }
}
//VisitInfoCell
class VisitInfoCell: TableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var pager: UIPageControl!
    
    var rewards = [Reward] ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pager.numberOfPages = rewards.count
    }
    
    //MARK: CollectionView DataSource and Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rewards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RewardCVCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cl = cell as! RewardCVCell
        let reward = rewards[indexPath.row]
        cl.rewardPoint = (reward.totalPoints, reward.userPoints)
        cl.lblTitle.text = reward.title
        cl.collView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 355 * _widthRatio, height: 80 * _widthRatio)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if index >= 0 && index < collView.numberOfItems(inSection: 0) {
            pager.currentPage = index
        }
        
    }

}

//MARK: OffeerCell
class OffeerCell: TableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var pager: UIPageControl!

    var offers = [Offer]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pager.numberOfPages = offers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let offer = offers[indexPath.row]
        let cl = cell as! CollectionViewCell
        cl.lblTitle.text = offer.title
        cl.lblSubTitle.text = "Updated 3h ago"
        cl.imgView.kf.setImage(with: URL(string: offer.imageUrl))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 355 * _widthRatio, height: 90 * _widthRatio)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if index >= 0 && index < collView.numberOfItems(inSection: 0) {
            pager.currentPage = index
        }
        
    }

}

//MapViewCell
class MapInfoCell : TableViewCell {

    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var mapView: GMSMapView!
    var cameraPosition : GMSCameraPosition!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setMapInfo(for store: Business) {
        mapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
        marker.title = store.title
        marker.map = mapView
        
        cameraPosition = GMSCameraPosition(target: marker.position, zoom: 0, bearing: 0, viewingAngle: 0)
         mapView.camera = cameraPosition
        self.perform(#selector(self.updateCameraPostion), with: nil, afterDelay: 0.5)
        
        lblTitle.text = "Location"
        lblAddress.text = store.address
        lblSubTitle.text = "3.8 KM AWAY"
        
        //self.mapView.animate(to: cameraPosition)
    }
    
    func updateCameraPostion() {
        CATransaction.begin()
        CATransaction.setValue(NSNumber(value: 1.0), forKey: kCATransactionAnimationDuration)
        mapView.animate(toZoom: 14)
        CATransaction.commit()
    }
}

//MARK: CollectionView Cell
// StoreVisitCell
class RewardCVCell: CollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var rewardPoint : (total : Int, userPoints : Int) = (0, 0)
    @IBOutlet var collView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rewardPoint.total
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let imageName = indexPath.row < rewardPoint.userPoints ? "ic_reward_Active" : "ic_reward_Inactive"
        cell.imgView.image = UIImage(named: imageName)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = 30 * _widthRatio
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth = 30
        let cellSpacing: CGFloat = 5
        let contentWidth = CGFloat(cellWidth * rewardPoint.total) * _widthRatio + CGFloat(rewardPoint.total - 1) * cellSpacing
        
        let collViewWidth = collectionView.frame.size.width
        var paddingValue: CGFloat = 0
        if contentWidth < collViewWidth {
            let diff = collViewWidth - contentWidth
            paddingValue = diff / 2
        }
        
        return UIEdgeInsets(top: 0, left: paddingValue, bottom: 0, right: paddingValue)
    }
    
    

}



