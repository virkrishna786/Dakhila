//
//  SignUpViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 18/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class SignUpViewController: UIViewController ,UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var pickerView: UIPickerView!
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    var checkTextField : Int!
    
    
    var schoolTypeText : String?
    var schoolTypeValue : String?
    @IBOutlet weak var myScroolView: UIScrollView!
    @IBOutlet weak var playSchoolButton: UIButton!
    var pickerArray = [String]()
    var stateArray = [StateArrayClass]()
    var cityArray = [CityArrayClass]()
    var localityArray = [Locality]()
    var stateIdString : Int?
    var cityIdString : Int?
    var localityIdString : Int?
    
    @IBOutlet weak var daySchoolButton: UIButton!
    
    @IBOutlet weak var daysBoardingSchoolButotn: UIButton!
    
    @IBOutlet weak var resedentailSchoolButton: UIButton!
    
    @IBOutlet weak var schoolNameTextField: UITextField!
    
    @IBOutlet weak var schoolEmailIdTextField: UITextField!
    
    @IBOutlet weak var schoolCOntactNumberTextField: UITextField!
    
    @IBOutlet weak var stateTextField: UITextField!
   
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var localityTextField: UITextField!
    @IBAction func playSchoolButttonAction(_ sender: UIButton) {
        self.playSchoolButton.setImage(UIImage(named:"radioFilledButton"), for: UIControlState.normal)
         self.daySchoolButton.setImage(UIImage(named:"radioBlankButton"), for: UIControlState.normal)
         self.resedentailSchoolButton.setImage(UIImage(named:"radioBlankButton"), for: UIControlState.normal)
        self.schoolTypeText = "Play School"
        self.schoolTypeValue = "1"
    }
    
    @IBAction func dayschoolButtonAction(_ sender: UIButton) {
         self.daySchoolButton.setImage(UIImage(named:"radioFilledButton"), for: UIControlState.normal)
        self.playSchoolButton.setImage(UIImage(named:"radioBlankButton"), for: UIControlState.normal)
        self.daysBoardingSchoolButotn.setImage(UIImage(named:"radioBlankButton"), for: UIControlState.normal)
        self.resedentailSchoolButton.setImage(UIImage(named:"radioBlankButton"), for: UIControlState.normal)
        self.schoolTypeText = "Day School"
        self.schoolTypeValue = "2"

    }
    
    @IBAction func dayBoardingSchoolButtonAction(_ sender: UIButton) {
         self.daysBoardingSchoolButotn.setImage(UIImage(named:"radioFilledButton"), for: UIControlState.normal)
        self.daySchoolButton.setImage(UIImage(named:"radioBlankButton"), for: UIControlState.normal)
        self.playSchoolButton.setImage(UIImage(named:"radioBlankButton"), for: UIControlState.normal)
        self.resedentailSchoolButton.setImage(UIImage(named:"radioBlankButton"), for: UIControlState.normal)
        self.schoolTypeText = "Day Boarding  School"
        self.schoolTypeValue = "3"

    }
    
    
    @IBAction func resedentailSchoolButtonAction(_ sender: UIButton) {
         self.resedentailSchoolButton.setImage(UIImage(named:"radioFilledButton"), for: UIControlState.normal)
        self.daySchoolButton.setImage(UIImage(named:"radioBlankButton"), for: UIControlState.normal)
        self.playSchoolButton.setImage(UIImage(named:"radioBlankButton"), for: UIControlState.normal)
        self.daysBoardingSchoolButotn.setImage(UIImage(named:"radioBlankButton"), for: UIControlState.normal)
        self.schoolTypeText = "Resedential School"
        self.schoolTypeValue = "4"

        
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        if self.schoolNameTextField.text == "" || self.schoolEmailIdTextField.text == "" || self.schoolCOntactNumberTextField.text == "" {
            
            let alertVC = UIAlertController(title: "Alert", message: "Please enter all fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }else if self.stateTextField.text == "" ||  self.cityTextField.text == "" || self.localityTextField.text == "" {
            let alertVC = UIAlertController(title: "Alert", message: "Please enter all fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            
        }else {
        self.apiCall()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.schoolNameTextField.delegate = self
        self.schoolEmailIdTextField.delegate = self
        self.schoolCOntactNumberTextField.delegate = self
        self.stateTextField.delegate = self
        self.cityTextField.delegate = self
        self.localityTextField.delegate = self
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.gestureFunction))
        myScroolView.addGestureRecognizer(tapGesture)
        
//        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.gestureFunction1))
//        self.view.addGestureRecognizer(tapGesture1)

        
        self.schoolNameTextField.attributedPlaceholder = NSAttributedString(string: "School Name",
                                                                          attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.schoolEmailIdTextField.attributedPlaceholder = NSAttributedString(string: "School Email",
                                                                          attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.schoolCOntactNumberTextField.attributedPlaceholder = NSAttributedString(string: "School Contact No.",
                                                                               attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.stateTextField.attributedPlaceholder = NSAttributedString(string: "Please Select State",
                                                                               attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.cityTextField.attributedPlaceholder = NSAttributedString(string: "Please Select City",
                                                                               attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.localityTextField.attributedPlaceholder = NSAttributedString(string: "Please Select Locality",
                                                                               attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "schoolName")
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        leftView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftImageView.frame = CGRect(x: 5, y: 10, width :20, height: 23)
        
        self.schoolNameTextField.leftView = leftView
        self.schoolNameTextField.leftViewMode = .always
        
        let leftImageView1 = UIImageView()
        leftImageView1.image = UIImage(named: "email")
        
        let leftView1 = UIView()
        leftView1.addSubview(leftImageView1)
        
        leftView1.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        leftView1.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftImageView1.frame = CGRect(x: 5, y: 10, width :20, height: 23)
        
        self.schoolEmailIdTextField.leftView = leftView1
        self.schoolEmailIdTextField.leftViewMode = .always
        
        
        let leftImageView2 = UIImageView()
        leftImageView2.image = UIImage(named: "phone")
        
        let leftView2 = UIView()
        leftView2.addSubview(leftImageView2)
        
        leftView2.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        leftView2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftImageView2.frame = CGRect(x: 5, y: 10, width :20, height: 23)
        
        self.schoolCOntactNumberTextField.leftView = leftView2
        self.schoolCOntactNumberTextField.leftViewMode = .always
        
        
        let leftImageView3 = UIImageView()
        leftImageView3.image = UIImage(named: "state")
        
        let leftView3 = UIView()
        leftView3.addSubview(leftImageView3)
        
        leftView3.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        leftView3.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftImageView3.frame = CGRect(x: 5, y: 10, width :20, height: 23)
        
        self.stateTextField.leftView = leftView3
        self.stateTextField.leftViewMode = .always

        
        let rightImageView1 = UIImageView()
        rightImageView1.image = UIImage(named:"username")
        rightImageView1.frame = CGRect(x: 8, y: 0, width: 30, height: 30)
        let rightView = UIView()
        rightView.frame = CGRect(x: self.stateTextField.frame.size.width - 60, y: 10, width: 40, height: 40)
        rightView.addSubview(rightImageView1)
        self.stateTextField.rightView = rightView
        self.stateTextField.rightViewMode = .always
        
        let leftImageView4 = UIImageView()
        leftImageView4.image = UIImage(named: "city")
        
        let leftView4 = UIView()
        leftView4.addSubview(leftImageView4)
        
        leftView4.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        leftView4.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftImageView4.frame = CGRect(x: 5, y: 10, width :20, height: 23)
        
        self.cityTextField.leftView = leftView4
        self.cityTextField.leftViewMode = .always
        
        
        let rightImageView4 = UIImageView()
        rightImageView4.image = UIImage(named:"username")
        rightImageView4.frame = CGRect(x: 8, y: 0, width: 30, height: 30)
        let rightView4 = UIView()
        rightView4.frame = CGRect(x: self.cityTextField.frame.size.width - 60, y: 10, width: 40, height:  40)
        rightView4.addSubview(rightImageView4)
        self.cityTextField.rightView = rightView4
        self.cityTextField.rightViewMode = .always
        
        let leftImageView5 = UIImageView()
        leftImageView5.image = UIImage(named: "locality")
        
        let leftView5 = UIView()
        leftView5.addSubview(leftImageView5)
        
        leftView5.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        leftView5.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftImageView5.frame = CGRect(x: 5, y: 10, width :20, height: 23)
        
        self.localityTextField.leftView = leftView5
        self.localityTextField.leftViewMode = .always
        
        
        let rightImageView5 = UIImageView()
        rightImageView5.image = UIImage(named:"username")
        rightImageView5.frame = CGRect(x: 8, y: 0, width: 30, height: 30)
        let rightView5 = UIView()
        rightView5.frame = CGRect(x: self.localityTextField.frame.size.width - 60, y: 10, width: 40, height: 40)
        rightView5.addSubview(rightImageView5)
        self.localityTextField.rightView = rightView5
        self.localityTextField.rightViewMode = .always

      // self.selectDropDownMenu()

        // Do any additional setup after loading the view.
    }
    
    // MARK:- gesture function
    
    func gestureFunction(){
        self.schoolNameTextField.resignFirstResponder()
        self.schoolEmailIdTextField.resignFirstResponder()
        self.schoolCOntactNumberTextField.resignFirstResponder()
        self.stateTextField.resignFirstResponder()
        self.cityTextField.resignFirstResponder()
        self.localityTextField.resignFirstResponder()
        self.pickerView.isHidden = true
        
    }
    
//    func gestureFunction1(){
//        self.schoolNameTextField.resignFirstResponder()
//        self.schoolEmailIdTextField.resignFirstResponder()
//        self.schoolCOntactNumberTextField.resignFirstResponder()
//        self.stateTextField.resignFirstResponder()
//        self.cityTextField.resignFirstResponder()
//        self.localityTextField.resignFirstResponder()
//        self.pickerView.isHidden = true
//        
//    }

    //MARK : Seclect State Api
    func selectDropDownMenu(){
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let  urlString = "\(baseUrl)/SchoolState"
            
            Alamofire.request(urlString, method: .post)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = JSON(response.result.value!)
                        print("result %@",response.result.value! )
                        let responseCode = result["ResponseCode"].string
                        print("response message \(responseCode!)")
                        if responseCode! == "200" {
                            hudClass.hide()
                            self.stateArray  = []
                            self.cityArray = []
                            self.localityArray = []
                            let dataArray  = result["State"].array
                            
                            for data in dataArray! {
                                let stateDataArray = StateArrayClass()
                                stateDataArray.stateId = data["StateId"].int
                                stateDataArray.stateName = data["StateName"].string
                                self.stateArray.append(stateDataArray)
                            }

                            DispatchQueue.main.async {
                                self.pickerView.reloadAllComponents()
                                self.pickerView.isHidden = false
                            }
                            print("success");
                            
                        }else if responseCode! == "500" {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Soem thing went wrong", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
                        }else {
                            
                            hudClass.hide()
                            parentClass.showAlertWithApiMessage(message: "Some thing went worng")
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

  
    // Slect city in state Api
    
    func selectCityInStateAPi(stateId : Int){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let  urlString = "\(baseUrl)/SchoolCity"
            
            let parameter = ["stateId" : stateId]
            
            Alamofire.request(urlString, method: .post , parameters : parameter)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    // print("Response String:", response.result.value)
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = JSON(response.result.value!)
                        //  let JSON = result as! NSDictionary
                        
                        print("result %@",response.result.value! )
                        
                        let responseCode = result["ResponseCode"].string
                        print("response message \(responseCode!)")
                        
                        if responseCode! == "200" {
                            hudClass.hide()
                            self.cityArray = []
                            self.localityArray = []
                            
                            let dataArray  = result["City"].array
                            
                            for data in dataArray! {
                                let stateDataArray = CityArrayClass()
                                stateDataArray.cityId = data["CityId"].int
                                stateDataArray.cityName = data["CityName"].string
                                self.cityArray.append(stateDataArray)
                            }
                            
                            DispatchQueue.main.async {
                                self.pickerView.reloadAllComponents()
                                self.pickerView.isHidden = false
                            }
                            print("success");
                            
                            
                        }else if responseCode! == "500" {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Soem thing went wrong", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
                        }else {
                            
                            hudClass.hide()
                            parentClass.showAlertWithApiMessage(message: "Some thing went worng")
                            
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
//MARK : -  select localit api
    
    func selectLocalityInCityAPi(cityId : Int){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let  urlString = "\(baseUrl)/SchoolLocality"
            
            let parameter = ["CityId" : cityId]
            
            Alamofire.request(urlString, method: .post , parameters : parameter)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = JSON(response.result.value!)
                        print("result %@",response.result.value! )
                        let responseCode = result["ResponseCode"].string
                        print("response message \(responseCode!)")
                        
                        if responseCode! == "200" {
                            hudClass.hide()
                            self.localityArray = []
                            let dataArray  = result["Locality"].array
                            
                            for data in dataArray! {
                                let stateDataArray = Locality()
                                stateDataArray.localityId = data["LocalityId"].int
                                stateDataArray.localityName = data["LocalityName"].string
                                self.localityArray.append(stateDataArray)
                            }
                            
                            DispatchQueue.main.async {
                                self.pickerView.reloadAllComponents()
                                self.pickerView.isHidden = false
                            }
                            print("success");
                            
                            
                        }else if responseCode! == "500" {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Soem thing went wrong", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
                        }else {
                            
                            hudClass.hide()
                            parentClass.showAlertWithApiMessage(message: "Some thing went worng")
                            
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

   // Picker View Delegate and data Source Methods
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if stateArray.count > 0 {
            if cityArray.count > 0 {
                if localityArray.count > 0 {
                  return   localityArray.count
                }else {
                    return   cityArray.count
                }
                
            }else {
                
               return  stateArray.count
            }
        }else {
           return 0
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if stateArray.count > 0 {
            if cityArray.count > 0 {
                if localityArray.count > 0 {
                    return   localityArray[row].localityName!
                }else {
                    return   cityArray[row].cityName!
                }
                
            }else {
                
                return  stateArray[row].stateName!
            }
        }else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if checkTextField == 1{
            self.stateTextField.text = stateArray[row].stateName!
            self.stateIdString = stateArray[row].stateId!
        }else if checkTextField == 2 {
            self.cityTextField.text = cityArray[row].cityName!
            self.cityIdString = cityArray[row].cityId!
        }else if checkTextField == 3 {
            self.localityTextField.text = localityArray[row].localityName!
            self.localityIdString = localityArray[row].localityId!
        }
        self.pickerView.isHidden = true
    }
    
    // TextField Delegate method 
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == stateTextField {
            self.checkTextField = 1
            self.cityTextField.text = ""
            self.localityTextField.text = ""

            self.selectDropDownMenu()
            return false

        }else if textField == cityTextField {
            
            let data = "\(stateTextField.text!)"
            print("data", data)
            
            if data == "" {
                return false
              }else {
             self.checkTextField = 2
            self.localityTextField.text = ""
            self.selectCityInStateAPi(stateId: self.stateIdString!)
            return false
            }

        }else if textField == localityTextField {
            let localityData = "\(cityTextField.text!)"
            if localityData == "" {
                return false
            }else {
            self.checkTextField = 3
            self.selectLocalityInCityAPi(cityId: self.cityIdString!)
            print("Krishna")
            return false
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == schoolEmailIdTextField {
            myScroolView.setContentOffset(CGPoint(x: 0, y: 10), animated: true)
        }else if textField ==  schoolCOntactNumberTextField{
            myScroolView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }else if textField == stateTextField || textField == cityTextField{
          //  myScroolView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }else if textField == localityTextField {
           // myScroolView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        }

    }
    
    // Sign UP api call
    
    func apiCall(){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let  urlString = "\(baseUrl)/SchoolRegistration"
            let schoolNameString = "\(schoolNameTextField.text!)"
            let schoolEmailString = "\(schoolEmailIdTextField.text!)"
            let schoolContactNumebr = "\(schoolCOntactNumberTextField.text!)"
            let stateIdString = "\(self.stateIdString!)"
            let cityIdString = "\(self.cityIdString!)"
            let localityString = "\(self.localityIdString!)"
            
            
            let  parameter = ["schoolTypeValu" : self.schoolTypeValue!,
                              "schoolTypeText" : self.schoolTypeText!,
                              "Name" : schoolNameString,
                              "EmailId" : schoolEmailString,
                              "Mobile" : schoolContactNumebr,
                              "State" : stateIdString,
                               "city" :  cityIdString,
                               "locality" : localityString
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
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Thank you We welcome you to school advantage.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: {UIAlertAction in
                            _ = self.navigationController?.popViewController(animated: true)
                            })
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
//                            let schoolId = JSON["Schoolid"] as! String
//                            let schoolNameSavedString = JSON["SchoolName"] as! String
//                            let SchoolEmailString = JSON["SchoolEmail"] as! String
//                            let TypeOfSchool = JSON["TypeOfSchool"] as! String
//                            let mobileNumber = JSON["MobileNo"] as! String
//                            defaults.set(TypeOfSchool, forKey: "typeOfSchool")
//                            defaults.set(schoolId, forKey: "schoolId")
//                            defaults.set(schoolNameSavedString, forKey: "school_name")
//                            defaults.set(SchoolEmailString, forKey: "school_email")
//                            defaults.set(mobileNumber, forKey: "mobileNumber")
//                            defaults.synchronize()
//                            self.performSegue(withIdentifier: "home", sender: self)
                            
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

    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        myScroolView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

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
