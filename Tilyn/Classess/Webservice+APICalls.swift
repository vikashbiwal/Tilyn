//
//  Webservice+APICalls.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 06/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

let _baseUrl = "http://webproject.live/php/codeigniter/tilyn/ws/v1/"//"http://192.168.10.116:8888/tilyn/ws/v1/"

let wsCall = WebService()

struct APIName {
    static var FacebookLogin = "user/fb_login"
    static var DeleteAccount = "user/deleteAccount"
    static var GetNearbyBusiness = "business/listNearByBusiness"
    static var GetBusinessDetails = "business/getBusinessDetails"
    static var GetRewards = "business/listUserRewards"
    static var RedeemReward = "business/redeemPoints"
    static var GetSpecialOffers = "business/listSpecialOffer"
    static var SearchBusiness = "business/searchCategoryListResult"
    static var GetCategories = "category/listCategories"
    
    static var ConnectBeacon = "business/connectBeacon"
    static var AddRewardPoint = "business/addPoint"
    
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

//MARK: Business and Category related APIs
extension WebService {
    
    func getNearbyBusiness(params : [String : Any], block: @escaping ResponseBlock) {
         print("Requested URL : \(_baseUrl + APIName.GetNearbyBusiness)")
        _ = POST_REQUEST(relPath: APIName.GetNearbyBusiness, param: params, block: block)
    }
    
    func getBusinessDetails(params : [String : Any], block: @escaping ResponseBlock) {
        print("Requested URL : \(_baseUrl + APIName.GetBusinessDetails)")
        _ = POST_REQUEST(relPath: APIName.GetBusinessDetails, param: params, block: block)
    }

    func getRewards(params: [String : Any], block : @escaping ResponseBlock) {
        print("Requested URL : \(_baseUrl + APIName.GetRewards)")
        _ = POST_REQUEST(relPath: APIName.GetRewards, param: params, block: block)
    }
    
    func getSpecialOffers(params: [String : Any], block : @escaping ResponseBlock) {
        print("Requested URL : \(_baseUrl + APIName.GetSpecialOffers)")
        _ = POST_REQUEST(relPath: APIName.GetSpecialOffers, param: params, block: block)
    }

    func searchBusinessByCategory(params: [String : Any], block : @escaping ResponseBlock)-> URLSessionTask? {
        print("Requested URL : \(_baseUrl + APIName.SearchBusiness)")
        return  POST_REQUEST(relPath: APIName.SearchBusiness, param: params, block: block)?.task
    }
    
    func getCategories(params: [String : Any]? = nil, block : @escaping ResponseBlock) {
        print("Requested URL : \(_baseUrl + APIName.GetCategories)")
        _ = GET_REQUEST(relPath: APIName.GetCategories, param: params, block: block)
    }
    
    func redeemReward(params: [String : Any], block : @escaping ResponseBlock) {
        print("Requested URL : \(_baseUrl + APIName.GetCategories)")
        _ = POST_REQUEST(relPath: APIName.GetCategories, param: params, block: block)
    }
}

//MARK: Beacon APIs
extension WebService {
   
    func connectBeacon(params: [String : Any], block : @escaping ResponseBlock) {
        print("Requested URL : \(_baseUrl + APIName.ConnectBeacon)")
        _ = POST_REQUEST(relPath: APIName.ConnectBeacon, param: params, block: block)
    }
    
    func addRewardPoint(params: [String : Any], block : @escaping ResponseBlock) {
        print("Requested URL : \(_baseUrl + APIName.AddRewardPoint)")
        _ = POST_REQUEST(relPath: APIName.AddRewardPoint, param: params, block: block)
    }

}
