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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ContainerCell
        currentMenuType = MenuType.type(with: indexPath.row)
        cell.tableview.reloadData()
        return cell
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//
        if currentMenuType  == MenuType.Rewards {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rewardMenuCell") as! RewardCell
            return cell

        } else if currentMenuType == MenuType.NearYou {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyMenuCell") as! TableViewCell
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


//MARK: ContainerCell
class ContainerCell: CollectionViewCell {
    @IBOutlet var tableview: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
//MARK: NearYouCell
class RestaurantCell : TableViewCell {
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK: Reward Cell
class RewardCell: TableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    var rewardPoints = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5//rewardPoints.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
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
        return UIEdgeInsets(top: 0, left: 85, bottom: 0, right: 85)
    }
    

}



