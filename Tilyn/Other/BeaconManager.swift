//
//  BeaconManager.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 17/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconManager :  NSObject {
    var locationManager: CLLocationManager!
    
    static let shared = BeaconManager()
    var rangingBlock: (CLBeacon)-> Void = {_ in}
    
    override init() {
        super.init()
        initLocationManager()
    }
    
    //Beacon proximity with string value
    func proximity(_ proxi : CLProximity) -> String {
        switch proxi {
        case .immediate:
            return "Immediate"
        case .near:
            return "Near"
        case .far:
            return "Far"
        case .unknown:
            return "Unknown"
        }
    }

    //Add Beacon for monitoring region
    func addBeaconForMonitoring(uuid: String, identifier: String) {
        if let uID = UUID(uuidString: uuid) {
            let bRegion  = CLBeaconRegion(proximityUUID: uID, identifier: "testBeacon")
            
            locationManager.startMonitoring(for: bRegion)
            locationManager.startRangingBeacons(in: bRegion)
        } else {
            print("UUID is not correct")
        }
    }
    
}

//MARK: Location Manager setup and Delegate
extension BeaconManager:  CLLocationManagerDelegate {
   
    //Initialize Location manager
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }

    //Ranging beacon device
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            if let beacon = beacons.first {
                print(beacon)
                _ = beacon.proximityUUID.uuidString
                _ = "Major : \(beacon.major.stringValue)"
                _ = "Minor : \(beacon.minor.stringValue)"
                _ = "Proximity : \(proximity(beacon.proximity))"
                _ = "Accurecy : \(beacon.accuracy) m."
                _ = "Rssi : \(beacon.rssi)"
                
                let notification = UILocalNotification()
                notification.alertBody = "Ranging did started."
                notification.soundName = "Default"
                UIApplication.shared.presentLocalNotificationNow(notification)

                self.rangingBlock(beacon)
            }
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter in region \(region.identifier)")
        let rg = region as! CLBeaconRegion
        print("Major : \(rg.major)\nMinor : \(rg.minor)")
        
        let notification = UILocalNotification()
        notification.alertBody = "Entering Beacon region."
        notification.soundName = "Default"
        UIApplication.shared.presentLocalNotificationNow(notification)
        if let beaconRegion = region as? CLBeaconRegion {
            manager.startRangingBeacons(in: beaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit  region \(region.identifier)")
        
        let notification = UILocalNotification()
        notification.alertBody = "User Did exit beacon region"
        notification.soundName = "Default"
        UIApplication.shared.presentLocalNotificationNow(notification)
    }

}
