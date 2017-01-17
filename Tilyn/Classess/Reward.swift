//
//  Reward.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 10/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation


class Reward {
    //var id = ""
    var title = ""
    var address = ""
    var description = ""
    var userPoints = 0
    var totalPoints = 0
    var visits = 0
    var imageUrl = ""
    var imgBusinessUrl = ""
    
    init(_ info : [String : Any]) {
        //id = RConverter.string(info[""])
        title = RConverter.string(info["vTitle"])
        address = RConverter.string(info["vAddress"])
        description = RConverter.string(info["rewardName"])
        userPoints = RConverter.integer(info["userPoints"])
        totalPoints = RConverter.integer(info["vPoints"])
        visits = RConverter.integer(info["visits"])
        imageUrl = RConverter.string(info["vImage"])
        imgBusinessUrl = RConverter.string(info["vIcon"])

    }
}
