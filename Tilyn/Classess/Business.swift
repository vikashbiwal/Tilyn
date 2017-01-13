//
//  Business.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 09/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

//MARK: Business
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
    
    var offers = [Offer]()
    var rewards = [Reward]()
    
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
        
        if let objOffers = info["special_offer"] as? [[String : Any]] {
            offers.removeAll()
            for item in objOffers {
                let offer = Offer(item)
                offers.append(offer)
            }
        }
        
        if let objRewards = info["reward"] as? [[String : Any]] {
            rewards.removeAll()
            for item in objRewards {
                let reward = Reward(item)
                rewards.append(reward)
            }
        }

    }
    
    func setInfo(_ info : [String : Any]) {
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
        
        if let objOffers = info["special_offer"] as? [[String : Any]] {
            offers.removeAll()
            for item in objOffers {
                let offer = Offer(item)
                offers.append(offer)
            }
        }
        
        if let objRewards = info["reward"] as? [[String : Any]] {
            rewards.removeAll()
            for item in objRewards {
                let reward = Reward(item)
                rewards.append(reward)
            }
        }
    }

}


//MARK: Category
class Category {
    var id = ""
    var name = ""
    var imgUrl = ""
    var iconUrl = ""
    
    init(_ info: [String : Any]) {
        id = RConverter.string(info["iCategoryId"])
        name = RConverter.string(info["vName"])
        imgUrl = RConverter.string(info["vImage"])
        iconUrl = RConverter.string(info["vIcon"])
    }
}

