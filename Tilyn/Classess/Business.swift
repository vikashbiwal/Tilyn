//
//  Business.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 09/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

class Business {
    var id = ""
    var title = ""
    var description = ""
    var iconUrl = ""
    var imageUrl = ""
    
    var address = ""
    var latitude: Double  = 0
    var longitude: Double = 0
    var cityId = ""
    var distance: Double = 0
    
    var phone = ""
    var website = ""
    
    var userId = ""
    
    var minor = ""
    var major = ""
    
    var categoryId = ""
    
    init(_ info : [String : Any]) {
        id = RConverter.string(info["iBusinessId"])
        title = RConverter.string(info["vTitle"])
        description = RConverter.string(info["txtDescription"])
        iconUrl = RConverter.string(info["vIcon"])
        imageUrl = RConverter.string(info["vImage"])

        address = RConverter.string(info["vAddress"])
        latitude = RConverter.double(info["vLatitude"])
        longitude = RConverter.double(info["vLongitude"])
        cityId = RConverter.string(info["iCityId"])
        
        
        phone = RConverter.string(info["vPhone"])
        website = RConverter.string(info["vWebsite"])
        minor = RConverter.string(info["vMinor"])
        major = RConverter.string(info[""])//not found in response
        
        categoryId = RConverter.string(info["iCategoryId"])
        distance = RConverter.double(info["distance"])
    }
}
