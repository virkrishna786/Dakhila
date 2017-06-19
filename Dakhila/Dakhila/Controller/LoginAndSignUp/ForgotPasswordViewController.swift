//
//  ForgotPasswordViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 18/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        if emailTextField.text == "" {
            parentClass.showAlertWithApiMessage(message: "Please enter your email")
            
        }else {
            self.apiCall()
        }
    }
//    @IBOutlet weak var submitButton: UIButton!{
//        didSet{
//            
//            self.submitButton.layer.cornerRadius = 15
//        }
//    }
    @IBOutlet weak var emailTextField: UITextField!
    var urlString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Your-Email",
                                                                       attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "mesage")
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        
        self.emailTextField.leftView = leftView
        self.emailTextField.leftViewMode = .always
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordViewController.gestureFunction))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    func gestureFunction(){
        self.emailTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func apiCall(){
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            
            self.urlString = "\(baseUrl)/ForgetPassword"
            
            let userString = "\(emailTextField.text!)"
            let  parameter = ["EmailId" : userString
            ]
            
            print("dfd \(parameter)")
            
            Alamofire.request(self.urlString!, method: .post, parameters: parameter)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value)")
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = response.result.value
                        let JSON = result as! NSDictionary
                        
                        let responseCode = JSON["Message"] as! String
                        
                        if responseCode == "Sent OPT in Your Email ID" {
                            hudClass.hide()
                            self.emailTextField.text = ""
                            self.emailTextField.resignFirstResponder()
                            let alertVC = UIAlertController(title: "Alert", message: "An OTP will be sent to your registered email Id.", preferredStyle: .alert)
                            alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.myFunc()}))
                            self.present(alertVC, animated: true, completion: nil)
                            
                            
                        }else if responseCode == "Oh! E-Mail id not registered with us" {
                            hudClass.hide()
                            let alertVC = UIAlertController(title: "Alert", message: "E-Mail id not registered with us", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
                            
                        }else {
                            hudClass.hide()
                            let alertVC = UIAlertController(title: "Alert", message: "Please enter valid email ", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
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
        
        self.performSegue(withIdentifier: "recoveryView", sender: self)
        
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
        emailTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        myScrollView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
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
