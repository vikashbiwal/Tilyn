//
//  Webservice.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 06/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation
import Alamofire

let kInternetDown       = "Your internet connection seems to be down"
let kHostDown           = "Your host seems to be down"
let kTimeOut            = "The request timed out"
let kTokenExpire        = "Session expired - please login again."
let _appName            = "Tylin"

typealias ResponseBlock = (_ json: Any?, _ flag: Int) -> ()

class WebService {

    let manager: SessionManager
    var networkManager: NetworkReachabilityManager
    var headers: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    
    var paramEncode: ParameterEncoding = URLEncoding.default
   
    typealias WSProgress = (Progress) -> ()?
    typealias WSFileBlock = (_ path: String?, _ success: Bool) -> ()
    
    var successBlock: (String, HTTPURLResponse?, Any?, ResponseBlock) -> Void
    var errorBlock: (String, HTTPURLResponse?, NSError, ResponseBlock) -> Void
    
    
    //MARK : Initializer
    
     init() {
            manager = Alamofire.SessionManager.default
            networkManager = NetworkReachabilityManager()!
            //paramEncode = JSONEncoding.default
            
            // Will be called on success of web service calls.
            successBlock = { (relativePath, res, respObj, block) -> Void in
                // Check for response it should be there as it had come in success block
                if let response = res{
                    jprint("Response Code: \(response.statusCode)")
                    jprint("Response(\(relativePath)): \(respObj)")
                    if response.statusCode == 200 {
                        block(respObj, response.statusCode)
                    } else {
                        block(respObj, response.statusCode)
                    }
                } else {
                    // There might me no case this can get execute
                    block(nil, 404)
                }
            }
            
            // Will be called on Error during web service call
            errorBlock = { (relativePath, res, error, block) -> Void in
                // First check for the response if found check code and make decision
                if let response = res {
                    jprint("Response Code: \(response.statusCode)")
                    jprint("Error Code: \(error.code)")
                    if let data = error.userInfo["com.alamofire.serialization.response.error.data"] as? NSData {
                        let errorDict = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                        if errorDict != nil {
                            jprint("Error(\(relativePath)): \(errorDict!)")
                            block(errorDict!, response.statusCode)
                            if response.statusCode == 423 {
                                //TODO
                            }
                        } else {
                            let code = response.statusCode
                            block(nil, code)
                        }
                    } else {
                        block(nil, response.statusCode)
                    }
                    // If response not found rely on error code to find the issue
                } else if error.code == -1009  {
                    jprint("Error(\(relativePath)): \(error)")
                    block([_appName: kInternetDown], error.code)
                    return
                } else if error.code == -1003  {
                    jprint("Error(\(relativePath)): \(error)")
                    block([_appName: kHostDown], error.code)
                    return
                } else if error.code == -1001  {
                    jprint("Error(\(relativePath)): \(error)")
                    block([_appName: kTimeOut], error.code)
                    return
                } else {
                    jprint("Error(\(relativePath)): \(error)")
                    block(nil, error.code)
                }
            }
            addInterNetListner()
        }
        
        deinit {
            networkManager.stopListening()
        }

    }


// MARK: - Request, ImageUpload and Dowanload methods
extension WebService {
    
    //MARK: GET REQUEST
    func GET_REQUEST(relPath: String, param: [String: Any]?, block: @escaping ResponseBlock)-> DataRequest?{
        do{
            return manager.request(try apiUrl(relPath: relPath), method: HTTPMethod.get, parameters: param, encoding: paramEncode, headers: headers).responseJSON { (resObj) in
                switch resObj.result {
                case .success:
                    if let resData = resObj.data {
                        do {
                            let res = try JSONSerialization.jsonObject(with: resData, options: [])
                            self.successBlock(relPath, resObj.response, res, block)
                        } catch let errParse {
                            jprint(errParse)
                            self.errorBlock(relPath, resObj.response, errParse as NSError, block)
                        }
                    }
                case .failure(let err):
                    jprint(err)
                    self.errorBlock(relPath, resObj.response, err as NSError, block)
                }
            }
        } catch let error {
            jprint(error)
            errorBlock(relPath, nil, error as NSError, block)
            return nil
        }
    }
    
    //MARK: POST REQUEST
    func POST_REQUEST(relPath: String, param: [String: Any]?, block: @escaping ResponseBlock)-> DataRequest?{
        do{
            return manager.request(try apiUrl(relPath: relPath), method: HTTPMethod.post, parameters: param, encoding: paramEncode, headers: headers).responseJSON { (resObj) in
                switch resObj.result{
                case .success:
                    if let resData = resObj.data{
                        do {
                            let res = try JSONSerialization.jsonObject(with: resData, options: []) as AnyObject
                            self.successBlock(relPath, resObj.response, res, block)
                        } catch let errParse{
                            jprint(errParse)
                            self.errorBlock(relPath, resObj.response, errParse as NSError, block)
                        }
                    }
                    break
                case .failure(let err):
                    jprint(err)
                    self.errorBlock(relPath, resObj.response, err as NSError, block)
                    break
                }
            }
        }catch let error{
            jprint(error)
            errorBlock(relPath, nil, error as NSError, block)
            return nil
        }
    }
    
    //MARK: UPLOAD IMAGE
    func UPLOAD_IMAGE(relPath: String,img: UIImage,param: [String: String]?, block: @escaping ResponseBlock, progress: WSProgress?){
        do{
            manager.upload(multipartFormData: { (formData) in
                formData.append(UIImageJPEGRepresentation(img, 1.0)!, withName: "keyName", fileName: "image.jpeg", mimeType: "image/jpeg")
                if let _ = param{
                    for (key, value) in param!{
                        formData.append(value.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
            }, to: try apiUrl(relPath: relPath), method: HTTPMethod.post, headers: headers, encodingCompletion: { encoding in
                switch encoding{
                case .success(let req, _, _):
                    req.uploadProgress(closure: { (prog) in
                        progress?(prog)
                    }).responseJSON { (resObj) in
                        switch resObj.result{
                        case .success:
                            if let resData = resObj.data{
                                do {
                                    let res = try JSONSerialization.jsonObject(with: resData, options: [])
                                    self.successBlock(relPath, resObj.response, res, block)
                                } catch let errParse{
                                    jprint(errParse)
                                    self.errorBlock(relPath, resObj.response, errParse as NSError, block)
                                }
                            }
                            break
                        case .failure(let err):
                            jprint(err)
                            self.errorBlock(relPath, resObj.response, err as NSError, block)
                            break
                        }
                    }
                    break
                case .failure(let err):
                    jprint(err)
                    self.errorBlock(relPath, nil, err as NSError, block)
                    break
                }
            })
        }catch let err{
            self.errorBlock(relPath, nil, err as NSError, block)
        }
    }
    
    //MARK: DOWNLOAD FILE
    func DOWNLOAD_FILE(relPath : String, progress: WSProgress?, block: @escaping WSFileBlock){
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("pig.png")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        do{
            manager.download(try apiUrl(relPath: relPath), to: destination).downloadProgress { (prog) in
                progress?(prog)
                }.response { (responce) in
                    if responce.error == nil, let path = responce.destinationURL?.path{
                        block(path, true)
                    }else{
                        block(nil, false)
                    }
                }.resume()
            
        }catch{
            block(nil, false)
        }
    }
}


//MARK: ACCESS TOKEN ADD AND REMOVE
extension WebService {
    
    func setAccesTokenToHeader(token:String){
        manager.adapter = TokenAdapter(token)
    }
    
    func removeAccessTokenFromHeader(){
        manager.adapter = nil
    }
    
    func setClientToken(token: String){
        headers["clientToken"] = token
    }
    
    func removeClientToken(){
        headers.removeValue(forKey: "clientToken")
    }
    
    func apiUrl(relPath : String) throws -> URL{
        do{
            if relPath.lowercased().contains("http") || relPath.lowercased().contains("www"){
                return try relPath.asURL()
            }else{
                return try (_baseUrl+relPath).asURL()
            }
        }catch let err{
            throw err
        }
    }

}

//MARK: TOKEN ADAPTER
class TokenAdapter: RequestAdapter {
    private let token: String
    
    init(_ token: String) {
        self.token = token
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}

// MARK: - INTERNET AVAILABILITY
extension WebService {
    
    func addInterNetListner(){
        networkManager.listener = { (status) in
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable{
                print("No InterNet")
            }else{
                print("Internet Avail")
            }
        }
        networkManager.startListening()
    }
    
    func isInternetAvailable() -> Bool {
        if networkManager.isReachable{
            return true
        }else{
            return false
        }
    }
}


