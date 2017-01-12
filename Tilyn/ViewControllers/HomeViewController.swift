//
//  HomeViewController.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 29/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import  CoreLocation


class HomeViewController: ParentViewController {

    @IBOutlet var horizontalMenuContainerView: UIView!
    @IBOutlet var horizontalMenuView: HorizontolMenuView!
    
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var lblSearchTitle: UILabel!
    
    var location: CLLocation?
    
    var nearbyStores = [Business]()
    var rewards = [Reward]()
    var offers = [Offer]()

    enum MenuType: Int {
        case Rewards = 0, NearYou = 1, Offers = 2
        
        static func type(with index: Int)-> MenuType {
            let type = MenuType(rawValue: index)!
            return type
        }
    }

    var currentMenuType = MenuType.Rewards
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadHorizontalMenuView()
        self.setupLocationManager()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
            self.collectionViewScroll(toIndex: index)
        }
    }
    
    
    //MARK: Setup LocationManager
    func setupLocationManager() {
        UserLocation.sharedInstance.fetchUserLocationForOnce(self) {(loc, error) in
            if let _ =  error {
                return
            }
            guard let loc = loc else  {return}
            self.location = loc
            
            if self.currentMenuType == .Rewards {
                self.getRewardsAPICall()
            } else if self.currentMenuType == .NearYou {
                self.getNearbyBusinessAPICall()
            } else if self.currentMenuType == .Offers {
                self.getSpecialOffersAPICall()
            }
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
        if [0, 1].contains(indexPath.row) {//Rewards and Nearby items will showing in tableview inside collectionViewCell.
           
            if indexPath.row == 0 { //Rewards
                guard !rewards.isEmpty else {
                    let cell = collView.dequeueReusableCell(withReuseIdentifier: "rewardsNoDataCell", for: indexPath) as! ContainerTableCell
                    cell.viewController = self
                    let selector = indexPath.row == 0 ? #selector(self.getRewardsAPICall) :  #selector(self.getNearbyBusinessAPICall)
                    cell.setRefreshControl(selector: selector)
                    return cell
                }
            } else if indexPath.row == 1 { //NearYou
                guard !nearbyStores.isEmpty else {
                    let cell = collView.dequeueReusableCell(withReuseIdentifier: "storeNoDataCell", for: indexPath) as! ContainerTableCell
                    cell.viewController = self
                    cell.lblTitle.text = "There are no any store available near by you."
                    let selector = indexPath.row == 0 ? #selector(self.getRewardsAPICall) :  #selector(self.getNearbyBusinessAPICall)
                    cell.setRefreshControl(selector: selector)
                    return cell
                }
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "containerTableCell", for: indexPath) as! ContainerTableCell
            cell.viewController = self
            currentMenuType = MenuType.type(with: indexPath.row)
            let selector = indexPath.row == 0 ? #selector(self.getRewardsAPICall) :  #selector(self.getNearbyBusinessAPICall)
            cell.setRefreshControl(selector: selector)
            cell.tableview.reloadData()
            return cell
            
        } else { //Special Offer items will showing in collectionView in side collectionViewCell
            
            guard !offers.isEmpty else {
                let cell = collView.dequeueReusableCell(withReuseIdentifier: "storeNoDataCell", for: indexPath) as! CollectionViewCell
                cell.lblTitle.text = "There are no any offers available."
                return cell
            }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "containerCollViewCell", for: indexPath) as! ContainerCollViewCell
            cell.offers  = offers
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
            
            //Change the current Menu type, when user scroll the collection view
            if index >= 0 && index < collView.numberOfItems(inSection: 0) {
                horizontalMenuView.scrollAtIndexPath(index: index)
                collectionViewScroll(toIndex: index)
            }
        }
    }
    
    func collectionViewScroll(toIndex index: Int) {
        if index == 0 {
            self.currentMenuType = .Rewards
            if self.rewards.isEmpty {
                self.getRewardsAPICall()
            }
            
        } else if index == 1 {
            self.currentMenuType = .NearYou
            if self.nearbyStores.isEmpty {
                self.getNearbyBusinessAPICall()
            }
            
        } else  { //index == 2
            self.currentMenuType = .Offers
            if self.offers.isEmpty {
                self.getSpecialOffersAPICall()
            }
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        collView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

    }
    
}


//MARK: TableView (In side CollectionView Cell) DataSource and Delegate
extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentMenuType == .Rewards {
            return rewards.count
        } else if currentMenuType == .NearYou {
            return nearbyStores.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//
        if currentMenuType  == MenuType.Rewards {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rewardMenuCell") as! RewardCell
            let reward = rewards[indexPath.row]
            cell.setRewardInfo(reward)
            return cell

        } else  { //if currentMenuType == MenuType.NearYou
            let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyMenuCell") as! StoreCell
            let store = nearbyStores[indexPath.row]
            cell.setStoreInfo(store)
            return cell

        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentMenuType == .NearYou {
            self.performSegue(withIdentifier: "StoreDetailSegue", sender: nil)
        }
    }
    
}


//MARK: Webservice Calls 
extension HomeViewController {
    
    //Get Rewards ApI Call
    func getRewardsAPICall() {
        self.showCentralGraySpinner()
        let params = ["iUserId" : me.id]
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
            
            if let cell = self.collView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ContainerTableCell {
                cell.refreshControl?.endRefreshing()
            }
            self.hideCentralGraySpinner()
        }
    }

    //Get Nearby Business API Call
    func getNearbyBusinessAPICall() {
        self.showCentralGraySpinner()
        let params = ["vLatitude" : location?.coordinate.latitude.ToString() ?? "",
                      "vLongitude" : location?.coordinate.longitude.ToString() ?? "",
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
            
            if let cell = self.collView.cellForItem(at: IndexPath(item: 1, section: 0)) as? ContainerTableCell {
                cell.refreshControl?.endRefreshing()
            }

            self.hideCentralGraySpinner()
        }
    }
    
    
    //Get Special offers API Call
    func getSpecialOffersAPICall() {
        self.showCentralGraySpinner()
        let params = ["vLatitude" : location?.coordinate.latitude.ToString() ?? "",
                      "vLongitude" : location?.coordinate.longitude.ToString() ?? "",
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
            self.hideCentralGraySpinner()
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
    var refreshControl: UIRefreshControl?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //tableview.tableFooterView = nil
    }
    
    //Set tableview Refresh Controller with given selector action
    func setRefreshControl(selector:Selector) {
        if let _ = refreshControl {
            refreshControl!.removeTarget(viewController!, action: selector, for: .valueChanged)
        } else {
            refreshControl = UIRefreshControl()
        }
        refreshControl!.addTarget(viewController!, action: selector, for: .valueChanged)
        tableview.addSubview(refreshControl!)

    }
    
}

class  ContainerCollViewCell: CollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    var offers = [Offer] ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let refreshControll = UIRefreshControl()
//        collView.addSubview(refreshControll)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OfferCollectionViewCell
        let offer = offers[indexPath.row]
        cell.setOfferInfo(offer)
         cell.backgroundColor   = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = ((_screenSize.width - 45) / 2) * _widthRatio
        let cellHeigh = ((collectionView.frame.size.height - 45) / 2) * _widthRatio
        return CGSize(width: cellWidth, height: cellHeigh)
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
        lblTitle?.text = store.title
        lblAddress?.text = store.address
        lbldistance?.text = String(format: "%.1fKM Away", store.distance)
        
        img_store?.kf.setImage(with: URL(string: store.iconUrl))
        img_storeCover?.kf.setImage(with: URL(string: store.imageUrl))
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

//MARK: Offer - Collection view cell
class OfferCollectionViewCell: CollectionViewCell {
    @IBOutlet var lblTimeUpdated: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //Set offer info
    func setOfferInfo(_ offer: Offer) {
        lblTitle.text = offer.title
        lblSubTitle.text = offer.businessName
        lblTimeUpdated.text = "Updated 5h ago"
        imgView.kf.setImage(with: URL(string: offer.imageUrl))
    }
}


