//
//  ViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 16/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController ,UITextFieldDelegate{
    
@IBOutlet weak var myScrollView: UIScrollView!
@IBAction func signUpButtonAction(_ sender: UIButton) {
    self.performSegue(withIdentifier: "signUp", sender: self)
}

@IBAction func submitButtonAction(_ sender: UIButton) {
    if userNameTextField.text == "" || passwordTextField.text == "" {
        let alertVC = UIAlertController(title: "Alert", message: "Please enter  email and password", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }else{
        self.apiCall()
    }
    
}
//@IBOutlet weak var submitButton: UIButton!{
//    didSet{
//        submitButton.layer.cornerRadius = 15
//    }
//}
@IBOutlet weak var passwordTextField: UITextField!
@IBOutlet weak var userNameTextField: UITextField!


var activeField = UITextField?.self
var userIdString : String? = ""
var tokenIdSting : String!

override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true
    self.userNameTextField.delegate = self
    self.passwordTextField.delegate = self
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.gestureFunction))
    myScrollView.addGestureRecognizer(tapGesture)
    
    self.userNameTextField.attributedPlaceholder = NSAttributedString(string: "UserName",
                                                                      attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
    self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                      attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
    self.userNameTextField.textColor = UIColor.black
    self.passwordTextField.textColor = UIColor.black
    
    let leftImageView = UIImageView()
    leftImageView.image = UIImage(named: "username")
    
    let leftView = UIView()
    leftView.addSubview(leftImageView)
    
    leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
    leftView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    leftImageView.frame = CGRect(x: 5, y: 10, width :20, height: 23)
    
    self.userNameTextField.leftView = leftView
    self.userNameTextField.leftViewMode = .always
    
    let leftImageView1 = UIImageView()
    leftImageView1.image = UIImage(named: "password")
    
    let leftView1 = UIView()
    leftView1.addSubview(leftImageView1)
    
    leftView1.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
    leftView1.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    leftImageView1.frame = CGRect(x: 5, y: 10, width :20, height: 23)
    
    self.passwordTextField.leftView = leftView1
    self.passwordTextField.leftViewMode = .always
    
    let forgetButton = UIButton()
    forgetButton.frame = CGRect(x: 8, y: 0, width: 60, height: 30)
    forgetButton.setTitle("Forget?", for: UIControlState.normal)
    forgetButton.setTitleColor(UIColor.orange, for: UIControlState.normal)
//    forgetButton.backgroundColor = UIColor.red
    forgetButton.titleLabel?.font = UIFont.init(name: "Helvetica", size: 12)
    forgetButton.addTarget(self, action: #selector(ViewController.forgetButtonAction), for: UIControlEvents.touchUpInside)
    let rightView = UIView()
    rightView.frame = CGRect(x: self.passwordTextField.frame.size.width - 80, y: 0, width: 75, height: 30)
    rightView.addSubview(forgetButton)
    self.passwordTextField.rightView = rightView
    self.passwordTextField.rightViewMode = .always
    
    //MARK: -  Naviagtion to HomeView on already logged in
    
    // let nameString =  defaults.value(forKey: "user_name") as? String
    let userdskf = defaults.string(forKey: "SchoolName")
    
    guard let usridsd = userdskf, !usridsd.isEmpty else {
        print("bla bla")
        return
    }
    self.performSegue(withIdentifier: "home", sender: self)
    
    // Do any additional setup after loading the view, typically from a nib.
}
    
    func forgetButtonAction(){
        self.performSegue(withIdentifier: "forgot", sender: self)
    }

override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
}


func gestureFunction(){
    myScrollView.endEditing(true)
}

func apiCall(){
    
    if currentReachabilityStatus != .notReachable {
        hudClass.showInView(view: self.view)
        let  urlString = "\(baseUrl)/SchoolLogin"
        let userString = "\(userNameTextField.text!)"
        let passwordString = "\(passwordTextField.text!)"
        
        
        let  parameter = ["EmailId" : userString,
                          "Password" : passwordString
        ]
        
        print("dfd \(parameter)")
        
        Alamofire.request(urlString, method: .post, parameters: parameter)
            .responseJSON { response in
                print("Success: \(response.result.isSuccess)")
                print("Response String:", response.result.value)
                
                //to get JSON return value
                
                if  response.result.isSuccess {
                    hudClass.hide()
                    let result = response.result.value
                    let JSON = result as! NSDictionary
                    
                    print("result %@",response.result.value! )
                    
                    let responseCode = JSON["ResponseCode"] as! String
                    let responseMessage = JSON["ReturnMessage"] as! String
                    print("response message \(responseCode)")
                    
                    if responseCode == "200" {
                        hudClass.hide()
                        print("success");
                        
                        let schoolId = JSON["Schoolid"] as! String
                        let schoolNameSavedString = JSON["SchoolName"] as! String
                        let SchoolEmailString = JSON["SchoolEmail"] as! String
                        let TypeOfSchool = JSON["TypeOfSchool"] as! String
                        let mobileNumber = JSON["MobileNo"] as! String
                        defaults.set(TypeOfSchool, forKey: "typeOfSchool")
                        defaults.set(schoolId, forKey: "schoolId")
                        defaults.set(schoolNameSavedString, forKey: "school_name")
                        defaults.set(SchoolEmailString, forKey: "school_email")
                        defaults.set(mobileNumber, forKey: "mobileNumber")
                        defaults.synchronize()
                        self.userNameTextField.text = ""
                        self.passwordTextField.text = ""
                        self.performSegue(withIdentifier: "home", sender: self)
                        
                    }else if responseCode == "500" {
                        hudClass.hide()
                        
                        let alertVC = UIAlertController(title: "Alert", message: "Please enter valid email and password", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                        alertVC.addAction(okAction)
                        self.present(alertVC, animated: true, completion: nil)
                    }else {
                        
                        hudClass.hide()
                        parentClass.showAlertWithApiMessage(message: responseMessage)
                        
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
    userNameTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    self.view.endEditing(true)
}

func textFieldDidBeginEditing(_ textField: UITextField)
{
    myScrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
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


}

