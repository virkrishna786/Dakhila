//
//  SignUpViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 18/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController ,UITextFieldDelegate {

    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var myScroolView: UIScrollView!
    @IBOutlet weak var playSchoolButton: UIButton!
    
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
    }
    
    @IBAction func dayschoolButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func dayBoardingSchoolButtonAction(_ sender: UIButton) {
    }
    
    
    @IBAction func resedentailSchoolButtonAction(_ sender: UIButton) {
    }
    
   
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.schoolNameTextField.delegate = self
        self.schoolEmailIdTextField.delegate = self
        self.schoolCOntactNumberTextField.delegate = self
        self.stateTextField.delegate = self
        self.cityTextField.delegate = self
        self.localityTextField.delegate = self
       // self.myScroolView.delegate = self
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.gestureFunction))
//        myScroolView.addGestureRecognizer(tapGesture)
        
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
        self.localityTextField.attributedPlaceholder = NSAttributedString(string: "Please Select locality",
                                                                               attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "username")
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        leftView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftImageView.frame = CGRect(x: 5, y: 10, width :20, height: 23)
        
        self.schoolNameTextField.leftView = leftView
        self.schoolNameTextField.leftViewMode = .always
        
        let leftImageView1 = UIImageView()
        leftImageView1.image = UIImage(named: "username")
        
        let leftView1 = UIView()
        leftView1.addSubview(leftImageView1)
        
        leftView1.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        leftView1.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftImageView1.frame = CGRect(x: 5, y: 10, width :20, height: 23)
        
        self.schoolEmailIdTextField.leftView = leftView1
        self.schoolEmailIdTextField.leftViewMode = .always
        
        
        let leftImageView2 = UIImageView()
        leftImageView2.image = UIImage(named: "username")
        
        let leftView2 = UIView()
        leftView2.addSubview(leftImageView2)
        
        leftView2.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        leftView2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftImageView2.frame = CGRect(x: 5, y: 10, width :20, height: 23)
        
        self.schoolCOntactNumberTextField.leftView = leftView2
        self.schoolCOntactNumberTextField.leftViewMode = .always
        
        
        let leftImageView3 = UIImageView()
        leftImageView3.image = UIImage(named: "username")
        
        let leftView3 = UIView()
        leftView3.addSubview(leftImageView3)
        
        leftView3.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        leftView3.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftImageView3.frame = CGRect(x: 5, y: 10, width :20, height: 23)
        
        self.stateTextField.leftView = leftView3
        self.stateTextField.leftViewMode = .always

        
        let rightImageView1 = UIImageView()
        rightImageView1.image = UIImage(named:"username")
        rightImageView1.frame = CGRect(x: 8, y: 0, width: 60, height: 30)
        let rightView = UIView()
        rightView.frame = CGRect(x: self.stateTextField.frame.size.width - 30, y: 10, width: 20, height: 23)
        rightView.addSubview(rightImageView1)
        self.stateTextField.rightView = rightView
        self.stateTextField.rightViewMode = .always
        
        let leftImageView4 = UIImageView()
        leftImageView4.image = UIImage(named: "username")
        
        let leftView4 = UIView()
        leftView4.addSubview(leftImageView4)
        
        leftView4.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        leftView4.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftImageView4.frame = CGRect(x: 5, y: 10, width :20, height: 23)
        
        self.cityTextField.leftView = leftView4
        self.cityTextField.leftViewMode = .always
        
        
        let rightImageView4 = UIImageView()
        rightImageView4.image = UIImage(named:"username")
        rightImageView4.frame = CGRect(x: 8, y: 0, width: 60, height: 30)
        let rightView4 = UIView()
        rightView4.frame = CGRect(x: self.cityTextField.frame.size.width - 30, y: 10, width: 20, height:  23)
        rightView4.addSubview(rightImageView4)
        self.cityTextField.rightView = rightView4
        self.cityTextField.rightViewMode = .always
        
        let leftImageView5 = UIImageView()
        leftImageView5.image = UIImage(named: "username")
        
        let leftView5 = UIView()
        leftView5.addSubview(leftImageView5)
        
        leftView5.frame = CGRect(x: 0, y: 0, width: 30, height: 45)
        leftView5.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftImageView5.frame = CGRect(x: 5, y: 10, width :20, height: 23)
        
        self.localityTextField.leftView = leftView5
        self.localityTextField.leftViewMode = .always
        
        
        let rightImageView5 = UIImageView()
        rightImageView5.image = UIImage(named:"username")
        rightImageView5.frame = CGRect(x: 8, y: 0, width: 60, height: 30)
        let rightView5 = UIView()
        rightView5.frame = CGRect(x: self.localityTextField.frame.size.width - 30, y: 10, width: 20, height: 23)
        rightView5.addSubview(rightImageView5)
        self.localityTextField.rightView = rightView5
        self.localityTextField.rightViewMode = .always



        // Do any additional setup after loading the view.
    }
    
    // MARK:- gesture function
    
//    func gestureFunction(){
//        
//    }
    
    
    // TextField Delegate method 
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
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
