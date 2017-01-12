//
//  SearchViewController.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 02/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit


class SearchViewController: ParentViewController {

    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var tableContainerView: UIView!
    
    lazy var categorySelectionBlock : (Category)-> Void = {_ in}
    
    var categories = [Category]()
    var searchResult = [Business]()
    var searchDataTask: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        txtSearch.becomeFirstResponder()
        self.getCategoriesAPICall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}

extension SearchViewController {
    @IBAction func backBtnTapped(sender: UIButton) {
        self.pop(inDirection: kCATransitionFromTop)
    }
    
    @IBAction func searchFieldTextChange(sender: UITextField) {
        let newValue = sender.text!.trimmedString()
        if !newValue.isEmpty {
            searchStoreAPICall(searchText: newValue)
        } else {
            tableContainerView.isHidden = true
        }
        
    }
}


//MARK: CollectionView DataSource and Delegate
extension SearchViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let category = categories[indexPath.row]
        cell.lblTitle.text = category.name
        cell.imgView.kf.setImage(with: URL(string: category.imgUrl))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
        let category = categories[indexPath.row]
        searchStoreAPICall(searchText: category.name)
        txtSearch.text = category.name
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (_screenSize.width  - 50) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
}

//MARK: TableView DataSource and Delegate
extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StoreCell
        let store = searchResult[indexPath.row]
        cell.setStoreInfo(store)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100  * _widthRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO
    }
    
}

//MARK: Webservice Calls
extension SearchViewController {
 
    //get category API call
    func getCategoriesAPICall() {
        wsCall.getCategories { response in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let items = json["data"] as? [[String : Any]] {
                        self.categories.removeAll()
                        for item in items {
                            let reward = Category(item)
                            self.categories.append(reward)
                        }
                        self.collView.reloadData()
                    }
                }

            } else {
                ShowToastErrorMessage("", message: response.message)
            }
        }
    }
    
    //Search store API call
    func searchStoreAPICall(searchText: String) {
        
        let params = ["vLatitude" : "22.975374",
                      "vLongitude" : "72.502384",
                      "radious" : "5",
                      "vSearchText" : searchText]
        searchDataTask?.cancel()
        searchDataTask = wsCall.searchBusinessByCategory(params: params) { response in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let items = json["data"] as? [[String : Any]] {
                        self.searchResult.removeAll()
                        for item in items {
                            let business = Business(item)
                            self.searchResult.append(business)
                        }
                        self.tableContainerView.isHidden = items.isEmpty
                        self.tableView.reloadData()
                    }
                }
                
            } else {
                //ShowToastErrorMessage("", message: response.message)
            }
        }
    }
}


//==================================================================================================================
//====================================================== Cells =====================================================
//==================================================================================================================

