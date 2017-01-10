//
//  HomeViewController.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 29/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

enum MenuType: Int {
    case Rewards = 0, NearYou = 1, Offers = 2
    
    static func type(with index: Int)-> MenuType {
      return MenuType(rawValue: index)!
    }
}

class HomeViewController: ParentViewController {

    @IBOutlet var horizontalMenuContainerView: UIView!
    @IBOutlet var horizontalMenuView: HorizontolMenuView!
    
    @IBOutlet var collView: UICollectionView!
    
    var currentMenuType = MenuType.Rewards
    
    var nearbyStores = [Business]()
    var rewards = [Reward]()
    var offers = [Offer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadHorizontalMenuView()
       
        self.getNearbyBusinessAPICall()
        self.getRewardsAPICall()
        self.getSpecialOffersAPICall()
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
        
        horizontalMenuView =  HorizontolMenuView.loadFromNib()
        horizontalMenuView.menuItems = menuItems
        horizontalMenuView.frame = horizontalMenuContainerView.bounds
        self.horizontalMenuContainerView.addSubview(horizontalMenuView)
        
        horizontalMenuView.actionBlock = {[unowned self](index) in
            if index == 0 {
                self.currentMenuType = .Rewards
                
            } else if index == 1 {
                self.currentMenuType = .NearYou
                
            } else if index == 2 {
                self.currentMenuType = .Offers
                
            }
            self.collectionViewScrollToIndex(index)
        }
    }
    
}

//MARK: IBActions
extension HomeViewController {
    //Top Search button clicked
    @IBAction func searchBtnTapped(sender: UIButton) {
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SBID_SearchVC") as! SearchViewController
        self.push(controller: searchVC, inDirection: kCATransitionFromBottom)
    }
    
    @IBAction func mapButtonTapped(sender: UIButton) {
        self.performSegue(withIdentifier: "mapViewSegue", sender: nil)
    }
}

//MARK: CollectionView DataSource and Delegate
extension HomeViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if [0, 1].contains(indexPath.row) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "containerTableCell", for: indexPath) as! ContainerTableCell
            cell.viewController = self
            currentMenuType = MenuType.type(with: indexPath.row)
            cell.tableview.reloadData()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "containerCollViewCell", for: indexPath) as! ContainerCollViewCell
            cell.collView.reloadData()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375  * _widthRatio, height: 558 * _widthRatio)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collView {
            let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            
            if index >= 0 && index < collView.numberOfItems(inSection: 0) {
                print(index)
                currentMenuType = MenuType(rawValue: index)!
                horizontalMenuView.scrollAtIndexPath(index: index)
            }
        }
    }
    
    func collectionViewScrollToIndex(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}

//MARK: TableView (In side CollectionView Cell) DataSource and Delegate
extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return rewards.count
        } else if section == 1 {
            return nearbyStores.count
        } else if section == 2 {
            return offers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//
        if currentMenuType  == MenuType.Rewards {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rewardMenuCell") as! RewardCell
            let reward = rewards[indexPath.row]
            cell.setRewardInfo(reward)
            return cell

        } else if currentMenuType == MenuType.NearYou {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyMenuCell") as! StoreCell
            let store = nearbyStores[indexPath.row]
            cell.setStoreInfo(store)
            return cell

        } else {//Offers
            let cell = tableView.dequeueReusableCell(withIdentifier: "rewardMenuCell") as! RewardCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "StoreDetailSegue", sender: nil)
    }
    
}

//MARK: Webservice Calls 
extension HomeViewController {
    
    //Get Rewards ApI Call
    func getRewardsAPICall() {
        let params = ["iUserId" : "8"]
        wsCall.getRewards(params: params) { response in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let items = json["data"] as? [[String : Any]] {
                       self.rewards.removeAll()
                        for item in items {
                            let reward = Reward(item)
                            self.rewards.append(reward)
                        }
                        if self.currentMenuType == MenuType.Rewards {
                            self.collView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                        }
                    }
                }
            } else {
                ShowToastErrorMessage("", message: response.message)
            }
        }
    }

    //Get Nearby Business API Call
    func getNearbyBusinessAPICall() {
        let params = ["vLatitude" : "22.975374",
                      "vLongitude" : "72.502384",
                      "radious" : "5"]
        wsCall.getNearbyBusiness(params: params) { response in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let items = json["data"] as? [[String : Any]] {
                       self.nearbyStores.removeAll()
                        for item in items {
                            let business = Business(item)
                            self.nearbyStores.append(business)
                        }
                        if self.currentMenuType == MenuType.NearYou {
                            self.collView.reloadItems(at: [IndexPath(item: 1, section: 0)])
                        }
                    }
                }
                
            } else {
                ShowToastErrorMessage("", message: response.message)
            }
        }
    }
    
    //Get Special offers API Call
    func getSpecialOffersAPICall() {
        let params = ["vLatitude" : "22.975374",
                      "vLongitude" : "72.502384",
                      "radious" : "5"]
        
        wsCall.getSpecialOffers(params: params) { response in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let items = json["data"] as? [[String : Any]] {
                        self.offers.removeAll()
                        for item in items {
                            let offer = Offer(item)
                            self.offers.append(offer)
                        }
                        if self.currentMenuType == MenuType.Offers {
                            self.collView.reloadItems(at: [IndexPath(item: 2, section: 0)])
                        }
                    }
                }
                
            } else {
                ShowToastErrorMessage("", message: response.message)
            }

        }
    }
}


//==================================================================================================================
//====================================================== Cells =====================================================
//==================================================================================================================

//MARK: ContainerCell
class ContainerTableCell: CollectionViewCell {
    @IBOutlet var tableview: UITableView!
    weak var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

class  ContainerCollViewCell: CollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 165 * _widthRatio
        let height = 256 * _widthRatio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }


}


//MARK: NearYouCell
class StoreCell : TableViewCell {
   
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lbldistance: UILabel!
    @IBOutlet var img_store: UIImageView!
    @IBOutlet var img_storeCover: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //Set store info
    func setStoreInfo(_ store: Business) {
        lblTitle.text = store.title
        lblAddress.text = store.address
        lbldistance.text = String(format: "%.2fKM Away", store.distance)
        
        img_store.kf.setImage(with: URL(string: store.iconUrl))
        img_storeCover.kf.setImage(with: URL(string: store.imageUrl))
    }
}

//MARK: Reward Cell
class RewardCell: TableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var lblMessage: UILabel!
    
    var rewardPoint : (total : Int, userPoints : Int) = (0, 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //Set Reward info
    func setRewardInfo(_ reward: Reward) {
        self.rewardPoint = (reward.totalPoints, reward.userPoints)
        self.lblTitle.text = reward.title
        self.lblSubTitle.text = reward.address
        self.lblMessage.text = reward.description
        self.imgView.kf.setImage(with: URL(string: reward.imageUrl), placeholder: UIImage(named: "img_storeBack"))
        self.collView.reloadData()
    }
    
    //CollectionView DataSource and Delegate
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


class OfferCollectionViewCell: CollectionViewCell {
    @IBOutlet var lblTimeUpdated: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setOfferInfo(_ offer: Offer) {
        
    }
}


