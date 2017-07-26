//
//  ChangePasswordViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 23/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var myScrollView: UIScrollView!
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
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var schoolId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.otpTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.gestureFunction))
        myScrollView.addGestureRecognizer(tapGesture)

        let userId = defaults.value(forKey: "schoolId") as? String
        self.schoolId = userId
        self.addChildViewController(appDelegate.menuTableViewController)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        if otpTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" {
            parentClass.showAlertWithApiMessage(message: "Please enter all fields")
        }else {
            
            self.apiCall()
        }
    }
    
    func gestureFunction(){
        myScrollView.endEditing(true)
    }

    // 11864
    func apiCall(){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let urlString = "\(baseUrl)/SchoolChangePassword"
            
            let otpString = "\(otpTextField.text!)"
            let passwordString = "\(passwordTextField.text!)"
            let newPasswordString = "\(confirmPasswordTextField.text!)"
            
            let parameter = ["Oldpassword" : "\(otpString)",
                "newpassword" :"\(passwordString)",
                "ConfirmPassword" : "\(newPasswordString)",
                "SchoolId" : "\(self.schoolId!)"
            ]
            
            // newPasswordString
            print("dfd \(parameter)")
            
            Alamofire.request(urlString, method: .post, parameters: parameter)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                   // print("Response String: \(response.result.value)")
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = response.result.value
                        let JSON = result as! NSDictionary
                        
                        let responseCode = JSON["ResponseCode"] as! String
                        
                        if responseCode == "200" {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Your Password have been Updated.", preferredStyle: .alert)
                            self.otpTextField.text = ""
                            self.passwordTextField.text = ""
                            self.confirmPasswordTextField.text = ""

                            alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.myFunc()}))
                            self.present(alertVC, animated: true, completion: nil)
                            
                        }else if responseCode == "500"{
                            
                            parentClass.showAlertWithApiMessage(message: "Old Password is not correct.")
                            
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

    func myFunc(){
        
    }

    //MARK: - HANDLE KEYBOARD
    func handleKeyBoardWillShow(notification: NSNotification) {
        
        let dictionary = notification.userInfo
        let value = dictionary?[UIKeyboardFrameBeginUserInfoKey]
        let keyboardSize = (value as AnyObject).cgRectValue.size
        
        let inset = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height) + 30, 0.0)
        myScrollView.contentInset = inset
        myScrollView.scrollIndicatorInsets = inset
        
    }
    
    //MARK: HANDLE KEYBOARD
    func handleKeyBoardWillHide(sender: NSNotification) {
        
        let inset1 = UIEdgeInsets.zero
        myScrollView.contentInset = inset1
        myScrollView.scrollIndicatorInsets = inset1
        myScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //myScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        otpTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == otpTextField) {
            myScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
        }else {
            myScrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        myScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
