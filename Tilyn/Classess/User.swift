//
//  User.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 09/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation


class User {
    var id = ""
    var name = ""
    var email = ""
    var profileImage = ""
    
    init(_ info: [String : Any]) {
        id = RConverter.string(info["iUserId"])
        name = RConverter.string(info["vFullName"])
        email = RConverter.string(info["vEmail"])
        profileImage = RConverter.string(info["vProfileImage"])
    }
}
