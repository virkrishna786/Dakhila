//
//  AdmissionAlertViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 23/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit
import  Alamofire
import  SwiftyJSON

class AdmissionAlertViewController: UIViewController {
    
    var flagValue : Bool?
    @IBAction func validToButtonAction(_ sender: UIButton) {
            self.datePicker.isHidden = false
    }
    @IBOutlet weak var myScroolView: UIScrollView!
    @IBAction func datePickerViewAction(_ sender: UIDatePicker) {
        self.setDate()

    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func refreshButtonAction(_ sender: UIButton) {
    }

    @IBAction func submitButton(_ sender: UIButton) {
    }
    @IBOutlet weak var descriptionTextView: UITextView!{
        didSet{
            self.descriptionTextView.layer.cornerRadius = 1.0
            self.descriptionTextView.layer.borderColor = UIColor.black.cgColor
            self.descriptionTextView.layer.borderWidth = 1.0
        }
    }
    
    let dateFormatter = DateFormatter()
 
    func setDate() {
        datePicker.minimumDate = NSDate() as Date
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "YYYY-MM-dd"
       // self.timeLimitForOfferTextField.text = dateFormatter.string(from: datePicker.date)
        self.validToButton.setTitle(dateFormatter.string(from: datePicker.date), for: UIControlState.normal)
        self.datePicker.isHidden = true
        
    }

    @IBOutlet weak var validToButton: UIButton!
    @IBAction func validFromButtonAction(_ sender: UIButton) {
        self.datePicker.isHidden = false
    }
    @IBOutlet weak var validFronButton: UIButton!
    @IBOutlet weak var newsTitleTextField: UITextField!
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
    
    var schoolId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.datePicker.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.gestureFunction))
        myScroolView.addGestureRecognizer(tapGesture)
        let userId = defaults.value(forKey: "schoolId") as? String
        self.schoolId = userId
        self.addChildViewController(appDelegate.menuTableViewController)

        // Do any additional setup after loading the view.
    }
    
    func gestureFunction(){
        myScroolView.endEditing(true)
    }
    
    
    func apiCall(){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let urlString = "\(baseUrl)/ChangePassword"
            let newPasswordString = "\(newsTitleTextField.text!)"
            let parameter = ["OldPassword" : "",
                "NewPassword" :"\(newPasswordString)",
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
                        
                        let responseCode = JSON["res_code"] as! String
                        
                        if responseCode == "200" {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Your password has been changed successfully", preferredStyle: .alert)
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
        myScroolView.contentInset = inset
        myScroolView.scrollIndicatorInsets = inset
        
    }
    
    //MARK: HANDLE KEYBOARD
    func handleKeyBoardWillHide(sender: NSNotification) {
        
        let inset1 = UIEdgeInsets.zero
        myScroolView.contentInset = inset1
        myScroolView.scrollIndicatorInsets = inset1
        myScroolView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //myScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        newsTitleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        self.view.endEditing(true)
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
