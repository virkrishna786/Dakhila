//
//  SupportTicketViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 23/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit
import  SwiftyJSON
import  Alamofire

class SupportTicketViewController: UIViewController ,UITextFieldDelegate , UITableViewDataSource, UITableViewDelegate ,UITextViewDelegate ,UIGestureRecognizerDelegate,UIScrollViewDelegate {

    @IBOutlet weak var cvategoryTableView: UITableView!
    var boolValue = 0
    @IBAction func refreshButtonAction(_ sender: UIButton) {
        self.categoryTextField.text = ""
        self.nameTextField.text = ""
        self.emailIDTextField.text = ""
        self.mobileTextField.text = ""
        self.queryTextView.text = ""
    }
    @IBAction func submitButtonAction(_ sender: UIButton) {
        if categoryTextField.text == "" && nameTextField.text == "" && emailIDTextField.text == "" && mobileTextField.text == "" && queryTextView.text == ""{
            parentClass.showAlertWithApiMessage(message: "Please enter all the fields")
        }else {
        self.apiCall()
        }
    }
    @IBOutlet weak var queryTextView: UITextView!{
        didSet{
            self.queryTextView.layer.cornerRadius = 1.0
            self.queryTextView.layer.borderWidth = 1
            self.queryTextView.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var myScroolView: UIScrollView!
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
    
    var supportCategoryArray  = [SupporttTickerArrayClass]()
    var schoolId : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cvategoryTableView.isHidden = true
        self.categoryTextField.delegate = self
        self.nameTextField.delegate = self
        self.mobileTextField.delegate = self
        self.emailIDTextField.delegate = self
        self.queryTextView.delegate = self
        self.myScroolView.delegate = self
        
        let userId = defaults.value(forKey: "schoolId") as? String
        self.schoolId = userId
        self.myScroolView.contentSize = CGSize(width: self.view.frame.size.width, height: 2000)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.gestureFunction))
//        tapGesture.delegate = self
//        tapGesture.cancelsTouchesInView = false
//        myScroolView.addGestureRecognizer(tapGesture)
        self.addChildViewController(appDelegate.menuTableViewController)

        // Do any additional setup after loading the view.
    }
    
    func gestureFunction(){
      //  myScroolView.endEditing(true)
      //  self.cvategoryTableView.isHidden = true
    }
    
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        
//        if touch.view  == cvategoryTableView {
//            return false
//        }else {
//            myScroolView.endEditing(true)
//            self.cvategoryTableView.isHidden = true
//            return true
//        }
//    }
    
    func apiCall(){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let urlString = "\(baseUrl)/SchoolSupportTicketInsert"
            let namestring = "\(nameTextField.text!)"
            let mobilestring = "\(mobileTextField.text!)"
            let emailstring = "\(emailIDTextField.text!)"
            let quesryString = "\(queryTextView.text!)"
            let categoryString = "\(categoryTextField.text!)"
            
            let parameter = ["SchoolId" : "\(self.schoolId!)",
                             "Name" : namestring,
                             "Category": categoryString,
                             "MobileNo": mobilestring,
                              "Email" : emailstring,
                              "Query" : quesryString
                
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
                            self.categoryTextField.text = ""
                            self.nameTextField.text = ""
                            self.emailIDTextField.text = ""
                            self.mobileTextField.text = ""
                            self.queryTextView.text = ""
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Thanks! for submitting support ticket.", preferredStyle: .alert)
                            alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.myFunc()}))
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
        nameTextField.resignFirstResponder()
        queryTextView.resignFirstResponder()
        mobileTextField.resignFirstResponder()
        emailIDTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == categoryTextField {
            self.getCategory()
            return false
            
        }else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == nameTextField {
            myScroolView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
  
        }else if textField == mobileTextField {
            myScroolView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
            
        }else if textField == emailIDTextField {
            myScroolView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
 
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        myScroolView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        myScroolView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        myScroolView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    func getCategory(){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let urlString = "\(baseUrl)/SchoolSupportTicketCategory"
            
            Alamofire.request(urlString, method: .post)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value)")
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = JSON(response.result.value!)
                       // let JSON = result as! NSDictionary
                        
                        let responseCode = result["ResponseCode"].string
                        
                        if responseCode == "200" {
                            hudClass.hide()
                            let resposneArray = result["SupportTicketCategory"].array
                            for data in resposneArray! {
                                let dataArrayClass = SupporttTickerArrayClass()
                                dataArrayClass.categoryId = data["categoryId"].string
                                dataArrayClass.categoryName  = data["categoryName"].string
                                self.supportCategoryArray.append(dataArrayClass)
                            }
                            
                            DispatchQueue.main.async {
                                self.cvategoryTableView.reloadData()
                                self.cvategoryTableView.isHidden = false
                            }
                            
                        }else if responseCode == "500"{
                            
                            parentClass.showAlertWithApiMessage(message: "Old Password is not correct.")
                            
                        }else {
                            hudClass.hide()
                            parentClass.showAlertWithApiMessage(message: "Some thing went wrong.")
                        }
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return supportCategoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let eventData = supportCategoryArray[indexPath.row]
        cell.textLabel?.text = eventData.categoryName!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data  = supportCategoryArray[indexPath.row]
        self.categoryTextField.text = data.categoryName!
        self.cvategoryTableView.isHidden = true
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
