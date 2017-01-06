//
//  Constants.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 08/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit
import Foundation


//MARK: -
let _screenSize             = UIScreen.main.bounds.size
let _twitterUrl             = "https://api.twitter.com/1.1/account/verify_credentials.json"
let _twitterFriendsUrl      = "https://api.twitter.com/1.1/friends/list.json"
let _fbMeUrl                = "https://graph.facebook.com/me"
let _googleUrl              = "https://maps.googleapis.com/maps/api/place"

let _fbLoginReadPermissions = ["public_profile","email"]
let _fbUserInfoRequestParam = "email, first_name,  last_name, name, id, gender, picture.type(large)"

let _googleMapAPIKey        = "AIzaSyCMxDUq4wCyis7M-T1Efl5KLEzwuT56ijY" //From Account - vikash@itindia.co.in

let _defaultCenter          = NotificationCenter.default
let _userDefault            = UserDefaults.standard
let _appDelegator           = UIApplication.shared.delegate! as! AppDelegate
let _application            = UIApplication.shared
let _heighRatio             = _screenSize.height/667
let _widthRatio             = _screenSize.width/375

let dateFormator: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "dd/MM/yyyy"
    return df
}()

let serverDateFormator: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "dd/MM/yyyy hh:mm:ss a"
    df.timeZone = TimeZone(identifier: "UTC")
    
    return df
}()

//Shutter action block 
var shutterActionBlock: (Void)-> Void = {_ in}

