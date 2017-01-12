//
//  MapViewController.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 06/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewController: ParentViewController {
    
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var mapView: GMSMapView!
    
    var location: CLLocation?
    var stores = [Business]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocationManager()
    }

    //MARK: Setup LocationManager
    func setupLocationManager() {
        UserLocation.sharedInstance.fetchUserLocationForOnce(self) {(loc, error) in
            if let _ =  error {
                return
            }
            guard let loc = loc else  {return}
            self.location = loc
            self.getNearbyBusinessAPICall()
        }
        
    }
    
    //MARK: Set marker on map for current store.
    func setMarker(for store: Business) {
        mapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
        marker.title = store.title
        marker.map = mapView
        
        let cameraPosition = GMSCameraPosition(target: marker.position, zoom: 15, bearing: 0, viewingAngle: 0)
        //let update = GMSCameraUpdate.setTarget(marker.position, zoom: 16)
        //mapView.moveCamera(update)
        mapView.animate(to: cameraPosition)
    }
}

//MARK: CollectionView DataSource and Delegate
extension MapViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoreCVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cl = cell as! StoreCVCell
        let store = stores[indexPath.row]
        cl.setStoreInfo(store)
        self.setMarker(for: store)
        print(store.title)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: _screenSize.width, height: 201 * _widthRatio)
    }
}

extension MapViewController {
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
                        self.stores.removeAll()
                        for item in items {
                            let business = Business(item)
                            self.stores.append(business)
                        }
                        self.collView.reloadData()
                    }
                }
                
            } else {
                ShowToastErrorMessage("", message: response.message)
            }
            
            self.hideCentralGraySpinner()
        }
    }
}


//MARK: NearYouCell
class StoreCVCell : CollectionViewCell {
    
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
        
        //img_store?.kf.setImage(with: URL(string: store.iconUrl))
        img_storeCover?.kf.setImage(with: URL(string: store.imageUrl))
    }
}
