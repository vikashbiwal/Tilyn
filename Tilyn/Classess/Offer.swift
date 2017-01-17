//
//  Offer.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 10/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation


class Offer {
    var id = ""
    var businessId = ""
    var userId = ""
    var title = ""
    var offerImgUrl = ""
    var businessImgUrl = ""
    var businessName  = ""
    var businessAddress = ""
    var businessContactNumber = "7819022814"
    
    var startDate = ""
    var endDate = ""
    var latitude = 0.0
    var longitude = 0.0
    var distance = 0.0
    
    init(_ info: [String : Any]) {
        id = RConverter.string(info["iOfferId"])
        userId = RConverter.string(info["iUserId"])
        title = RConverter.string(info["vTitle"])
        offerImgUrl = RConverter.string(info["vOfferImage"])
        
        businessId = RConverter.string(info["iBusinessId"])
        businessName = RConverter.string(info["businessName"])
        businessAddress = RConverter.string(info["vAddress"])
        businessImgUrl = RConverter.string(info["vImage"])
        
        latitude = RConverter.double(info["vLatitude"])
        longitude = RConverter.double(info["vLongitude"])
        distance = RConverter.double(info["distance"])
        
        startDate = RConverter.string(info["dStartDate"])
        endDate = RConverter.string(info["dEndDate"])
    }
}




