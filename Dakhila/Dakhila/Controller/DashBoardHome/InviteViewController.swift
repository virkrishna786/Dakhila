//
//  InviteViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 23/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InviteViewController: UIViewController {
    var boolValue = 0
    @IBAction func menuButtonAction(_ sender: UIButton) {
        if boolValue == 0 {
            appDelegate.menuTableViewController.showMenu()
            self.view .addSubview(appDelegate.menuTableViewController.view)
            boolValue = 1
        } else {
            appDelegate.menuTableViewController.hideMenu()
            self.view .addSubview(appDelegate.menuTableViewController.view)
            boolValue = 0
        }
        

    }

    @IBAction func contactListButtonAction(_ sender: UIButton) {
    }
        
    @IBAction func addButtonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var numberTextfield: UITextField!
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        if self.numberTextfield.text == "" && self.messagfeTextfield.text == "" {
            parentClass.showAlertWithApiMessage(message: "Please enter all the fields.")
        }else {
            self.apiCall()
        }
    }
    @IBOutlet weak var messagfeTextfield: UITextField!
    var schoolId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let userId = defaults.value(forKey: "schoolId") as? String
        self.schoolId = userId
        self.addChildViewController(appDelegate.menuTableViewController)

        // Do any additional setup after loading the view.
    }
    
    func apiCall(){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let urlString = "\(baseUrl)/SchoolInviteParent"
            let mobilestring = "\(numberTextfield.text!)"
            let messageString  = "\(messagfeTextfield.text!)"
            
            let parameter = ["SchoolId" : "\(self.schoolId!)",
                "MobileNumber" : mobilestring,
                "Message" : messageString
                
            ]
            
            print("dfd \(parameter)")
            
            Alamofire.request(urlString, method: .post, parameters: parameter)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value)")
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = response.result.value
                        let JSON = result as! NSDictionary
                        let responseCode = JSON["ResponseCode"] as! String
                        if responseCode == "200" {
                            hudClass.hide()
                            self.numberTextfield.text = ""
                            self.messagfeTextfield.text = ""
                            
                            let alertVC = UIAlertController(title: "Alert", message: "You have successfully sent message.", preferredStyle: .alert)
                            alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alertVC, animated: true, completion: nil)
                            
                        }else if responseCode == "500"{
                            
                            parentClass.showAlertWithApiMessage(message: "Support Tciket not generated.")
                            
                        }else {
                            hudClass.hide()
                            parentClass.showAlertWithApiMessage(message: "Some thing went wrong.")
                        }
                        print("json \(JSON)")
                        
                    }else {
                        hudClass.hide()
                        parentClass.showAlertWithApiFailure()
                    }
            }
            
            
        }else {
            hudClass.hide()
            parentClass.showAlert()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
