//
//  ParentClass.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/10/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import Foundation
import UIKit


class ParentClass : NSObject {
    
//    func getYCordinateAccordingToScreenSize(getValue: Float) -> Float {
//        return ((getValue * (UIScreen.main.bounds.size.height))/kHeight)
//    }
//    
//    func getXCordinateAccordingToScreenSize(getValue: Float) -> Float {
//        return ((getValue * (UIScreen.main.bounds.size.width))/kWidth)
//    }
//    
//    // MARk :  SETWIDTH
//    
//    func setWidth(width: Float) -> Float {
//        return (width * (UIScreen.main.bounds.size.height))/kHeight
//    }
//    
//    
//    func setHeight(height: Float) -> Float {
//        return (height * (UIScreen.main.bounds.size.height))/kHeight
//    }
//    
//    func setFont(fontSize: Float)-> Float {
//        return (fontSize * (UIScreen.main.bounds.size.width))/kWidth
//    }
    
    //MARK: VALID PHONE NUMBER CHECK
    
    func  noIsValid(phoneNumber : String) -> Bool {
        
        let phoneRegExp = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegExp)
        
        if phoneTest.evaluate(with: phoneNumber){
            
            return true
        }
        return false
    }
    
    func logout() {
        
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "profile_image")
        defaults.removeObject(forKey: "user_name")
        defaults.removeObject(forKey: "eventId")
        defaults.removeObject(forKey: "user_email")
        
        print("logOut")
        
    }
    
    func setBlankView(label : UILabel)  -> UILabel{
        
        var customView = UILabel()
        customView = UILabel(frame: CGRect(x: 50, y: 200, width: 200, height: 30))
        customView.backgroundColor = UIColor.clear
        customView.text = "No Record Found"
        customView.textAlignment = NSTextAlignment.center
        customView.textColor = UIColor.white
        return customView
    }
    
   
        func msg(message: String, title: String = "")
        {
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
        }
    
  
    func showAlert(){
        let Alert = ParentClass()
        Alert.msg(message: "please check the internet connection", title: "Alert")
    }
    
    func showAlertWithApiFailure() {
    let Alert = ParentClass()
      Alert.msg(message: "Some thing went wrong" ,title:  "Alert")
}
    
    func showAlertWithApiMessage(message: String){
        let Alert = ParentClass()
        Alert.msg(message: message ,title:  "Alert")
        
    }
    
    func setSideMenu(customView:UIView) -> UIView{
        let customView = UIView()
        let screenSize: CGRect = UIScreen.main.bounds
        
       // let screenwidth = screenSize.width
        let screenheight = screenSize.height
          print("sdsfgds",screenheight)
        
        if (screenheight == 568) {
            customView.frame = CGRect(x: 200, y: 61, width: 300, height: 734)
   
        }else if (screenheight == 667) {
            customView.frame = CGRect(x: 200, y: 61, width: 300, height: 734)
        }else {
          
            customView.frame = CGRect(x: 200, y: 61, width: 300, height: 734)

        }
        
        customView.backgroundColor = UIColor.clear
        return customView
    }
    
    //MARK: - validate emai
    
    func validateEmailAddress(yourEmail:String)-> Bool{
        let emailRegex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        let email:NSPredicate = NSPredicate(format: "SELF MATCHES %@",emailRegex);
        return email.evaluate(with: yourEmail);
    }
    
    //MARK: - check phone 
    
    
    func validatePhone(yourNumber:NSString)->Bool
    {
        NSLog("%@",yourNumber);
        
        let PHONE_REGEX = "[0-9]{6,14}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        let result =  phoneTest.evaluate(with: yourNumber)
        
        return result
    }
    //MARK: CHECK INTERNET CONNECTION
    
//    func checkInternetConnection() -> Bool {
//        
//        let  reachability: Reachability
//        do {
//            reachability = try Reachability.NetworkStatus
//            //  try reachability.startNotifier()
//            
//        } catch {
//            print("Unable to create Reachability")
//            return false
//        }
//        
//        
//        //       NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(CommonClass.checkForReachability(_:)), name: ReachabilityChangedNotification, object: nil);
//        if(reachability.currentReachabilityStatus ==  .NotReachable)
//        {
//            return false
//        }
//        else
//        {
//            return true
//        }
//        
//    }
//    

    
}


