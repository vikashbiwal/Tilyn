//
//  StoreDetailVC.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 05/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class StoreDetailVC: ParentViewController {

    let kSectionForStoreInfo = 0
    let kSectionForVisitInfo = 1
    let kSectionForOfferInfo = 2
    let kSectionForMapInfo   = 3
    let kSectionForShareInfo = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        return 5
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "storeInfoCell") as! TableViewCell
            return cell
            
        } else if indexPath.section == kSectionForVisitInfo {//visitCountCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "visitCountCell") as! TableViewCell
            return cell
            
        } else if indexPath.section == kSectionForOfferInfo {
            let cell = tableView.dequeueReusableCell(withIdentifier: "specialOfferCell") as! TableViewCell
            return cell
            
        } else if indexPath.section == kSectionForMapInfo { //mapCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell") as! TableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shareCell") as! TableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case kSectionForStoreInfo:
            return 150 * _widthRatio
        case kSectionForVisitInfo :
            return 110 * _widthRatio
        case kSectionForOfferInfo :
            return 150 * _widthRatio
        case kSectionForMapInfo:
            return 200 * _widthRatio
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


//MARK: TableView Cells
//VisitInfoCell
class VisitInfoCell: TableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var pager: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pager.numberOfPages = 5
    }
    
    //MARK: CollectionView DataSource and Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        return cell
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

//MARK: OffeerCell
class OffeerCell: TableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var pager: UIPageControl!

    var rewardPoints = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pager.numberOfPages = 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5//
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
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

//MARK: CollectionView Cell
// StoreVisitCell
class StoreVisitCell: CollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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



