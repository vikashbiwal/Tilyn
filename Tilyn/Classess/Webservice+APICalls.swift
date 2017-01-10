//
//  Webservice+APICalls.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 06/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

let _baseUrl = "http://192.168.10.116:8888/tilyn/ws/v1/"

let wsCall = WebService()

struct APIName {
    static var FacebookLogin = "user/fb_login"
    static var DeleteAccount = "user/deleteAccount"
    static var GetNearbyBusiness = "business/listNearByBusiness"
    static var GetRewards   = "business/listUserRewards"
    static var GetSpecialOffers = "business/listSpecialOffer"
}

//MARK: User's APIs
extension WebService {
    
    func facebookLogin(param: [String : Any], block: @escaping ResponseBlock) {
       _ = POST_REQUEST(relPath: APIName.FacebookLogin, param: param, block: block)
    }
    
    func deleteAccount(param: [String : Any], block: @escaping ResponseBlock) {
        _ = POST_REQUEST(relPath: APIName.DeleteAccount, param: param, block: block)
    }
    
}

//MARK: Business related APIs
extension WebService {
    
    func getNearbyBusiness(params : [String : Any], block: @escaping ResponseBlock) {
        _ = POST_REQUEST(relPath: APIName.GetNearbyBusiness, param: params, block: block)
    }
    
    func getRewards(params: [String : Any], block : @escaping ResponseBlock) {
        _ = POST_REQUEST(relPath: APIName.GetRewards, param: params, block: block)
    }
    
    func getSpecialOffers(params: [String : Any], block : @escaping ResponseBlock) {
        _ = POST_REQUEST(relPath: APIName.GetSpecialOffers, param: params, block: block)
    }

}
