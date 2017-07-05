//
//  ApiWrapperClass.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 03/07/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiWrapperClass: NSObject {
    
    class func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                hudClass.hide()
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                hudClass.hide()
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                hudClass.hide()
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                hudClass.hide()
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }

}
