//
//  DashBoardViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 18/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit
import  Alamofire
import  SwiftyJSON

class DashBoardViewController: UIViewController {
    
    @IBOutlet weak var schoolNameLabel: UILabel!
    
    @IBOutlet weak var jdVerifiedAccountTypeLabel: UILabel!
    
    @IBOutlet weak var virtualActvieLabel: UILabel!
    
    @IBOutlet weak var schoolOffersLabel: UILabel!
    
    @IBOutlet weak var profielCompleteNessLabel: UILabel!
    
    @IBOutlet weak var admissionLeadsLabel: UILabel!
    
    @IBOutlet weak var jdApplicationsLabel: UILabel!
    
    @IBOutlet weak var eventConsentDetailLabel: UILabel!
    
    @IBOutlet weak var admissionLabel: UILabel!
    
    @IBOutlet weak var jdSearchLabel: UILabel!
    
    @IBOutlet weak var parentNofifierLabel: UILabel!
    
    @IBOutlet weak var advertisementsLabel: UILabel!
    
    @IBOutlet weak var advertisementGraphLabel: UILabel!
    
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
    
    @IBAction func accountTypeButtonAction(_ sender: UIButton) {
        let firstView:AlertCustomViewController
            = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "alert") as! AlertCustomViewController
        firstView.sceenshotgImage = parentClass.screenShot()
        appDelegate.navigationController?.pushViewController(firstView, animated: false)
    }
    @IBAction func threeSixtyDegreeButtonAction(_ sender: UIButton) {
        
    }
    @IBAction func schoolOffersButtonAction(_ sender: UIButton) {
        let firstView:AlertCustomViewController
            = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "alert") as! AlertCustomViewController
        firstView.sceenshotgImage = parentClass.screenShot()
        appDelegate.navigationController?.pushViewController(firstView, animated: false)
    }
    @IBAction func profileCompleteNessButtonAction(_ sender: UIButton) {
        let firstView:AlertCustomViewController
            = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "alert") as! AlertCustomViewController
        firstView.sceenshotgImage = parentClass.screenShot()
        appDelegate.navigationController?.pushViewController(firstView, animated: false)
    }
    @IBAction func admissionLeadsButtonAction(_ sender: UIButton) {
        let firstView:AlertCustomViewController
            = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "alert") as! AlertCustomViewController
        firstView.sceenshotgImage = parentClass.screenShot()
        appDelegate.navigationController?.pushViewController(firstView, animated: false)
    }
    
    @IBAction func jdApplicationButtonAction(_ sender: UIButton) {
        let firstView:AlertCustomViewController
            = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "alert") as! AlertCustomViewController
        firstView.sceenshotgImage = parentClass.screenShot()
        appDelegate.navigationController?.pushViewController(firstView, animated: false)
    }
    
    @IBAction func eventConsentDetailButtonAction(_ sender: UIButton) {
        let firstView:AlertCustomViewController
            = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "alert") as! AlertCustomViewController
        firstView.sceenshotgImage = parentClass.screenShot()
        appDelegate.navigationController?.pushViewController(firstView, animated: false)
    }
    
    @IBAction func admissionAlertButtonAction(_ sender: UIButton) {
        let firstView: AdmissionAlertViewController
            = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "admissionAlert") as! AdmissionAlertViewController
        //            let firstView:HomeViewController = HomeViewController(nibName:"HomeViewController",bundle:Bundle.main)
        var fcheck=Bool()
        fcheck=false
        let viewArray=self.navigationController?.viewControllers as NSArray!
        if((viewArray) != nil){
            if !((viewArray?.lastObject! as! UIViewController) .isKind(of: AdmissionAlertViewController.self)){
                
                for views in self.navigationController?.viewControllers as NSArray!
                {
                    if((views as! UIViewController) .isKind(of: AdmissionAlertViewController.self))
                    {
                        fcheck=true
                        _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                    }
                }
                if(fcheck==false){
                    
                    self.navigationController?.pushViewController(firstView, animated: true)
                }
            }
            else{
                
                //reset button
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetStaticView"), object: nil)
            }
        }
        else{
            
            //reset button
            appDelegate.navigationController?.pushViewController(firstView, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
        }
        

    }

    @IBAction func jdSearchButtonAction(_ sender: UIButton) {
        let firstView:AlertCustomViewController
            = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "alert") as! AlertCustomViewController
        firstView.sceenshotgImage = parentClass.screenShot()
        appDelegate.navigationController?.pushViewController(firstView, animated: false)
    }
    
    @IBAction func parentNotificationButtonAction(_ sender: UIButton) {
        let firstView:AppNotifierViewController
            = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "appNotify") as! AppNotifierViewController
        //            let firstView:HomeViewController = HomeViewController(nibName:"HomeViewController",bundle:Bundle.main)
        var fcheck=Bool()
        fcheck=false
        let viewArray=self.navigationController?.viewControllers as NSArray!
        if((viewArray) != nil){
            if !((viewArray?.lastObject! as! UIViewController) .isKind(of: AppNotifierViewController.self)){
                for views in self.navigationController?.viewControllers as NSArray!
                {
                    if((views as! UIViewController) .isKind(of: AppNotifierViewController.self))
                    {
                        fcheck=true
                        _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                    }
                }
                if(fcheck==false){
                    
                    self.navigationController?.pushViewController(firstView, animated: true)
                }
            }
            else{
                
                //reset button
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetStaticView"), object: nil)
            }
        }
        else{
            
            appDelegate.navigationController?.pushViewController(firstView, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
        }

    }
    
    
    
    @IBAction func advertisementGraphButtonAction(_ sender: UIButton) {
        let firstView:AlertCustomViewController
            = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "alert") as! AlertCustomViewController
        firstView.sceenshotgImage = parentClass.screenShot()
        appDelegate.navigationController?.pushViewController(firstView, animated: false)    }
    @IBAction func advertisementButtonAction(_ sender: UIButton) {
        let firstView:AlertCustomViewController
            = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "alert") as! AlertCustomViewController
        firstView.sceenshotgImage = parentClass.screenShot()
        appDelegate.navigationController?.pushViewController(firstView, animated: false)
    }
    
    var schoolType : String?
    var schoolId : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let userId = defaults.value(forKey: "schoolId") as? String
        self.schoolId = userId
      //  print("user %@" ,userId!)
        let schoolNameString = defaults.value(forKey: "school_name") as? String
        self.schoolNameLabel.text = schoolNameString!
        
        let interestIdString = defaults.string(forKey: "typeOfSchool")
        self.schoolType = interestIdString
      //  print("dkfkd %@",interestIdString!)
        
        self.dashBoardCallApi()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.addChildViewController(appDelegate.menuTableViewController)
        
        let view=self.navigationController?.viewControllers.first
        
        if !((view! ) .isKind(of: DashBoardViewController.self)){
            
            //set ralist view as root view controller
            
            let firstView:DashBoardViewController
                = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Dashboard") as! DashBoardViewController
            self.navigationController?.viewControllers .remove(at: 0)
            self.navigationController?.viewControllers .insert(firstView, at: 0)
        }
        
        //        self.eventApiHit(string: "1")
        self.navigationController?.navigationBar.isHidden = true
    }
    

    func dashBoardCallApi(){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let  urlString = "\(baseUrl)/GetSchoolDashboard"
            
            
            let  parameter = ["SchoolId" : self.schoolId!,
                              "typeofschool" : self.schoolType!
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
                        print("response message \(responseCode)")
                        
                        if responseCode == "200" {
                            hudClass.hide()
                            print("success");
                            
                            let admissionAlerts = JSON["AdmissionAlerts"] as! String
                            let admissionLeadCounts = JSON["AdmissionLeadsCount"] as! String
                            let advertisemsnts = JSON["Advertisement"] as! String
                            let EventConsentDetails = JSON["EventConsentDetails"] as! String
                            let Is360ViewActived = JSON["Is360ViewActived"] as! String
                            let JDApplication = JSON["JDApplication"] as! String
                            let ParentNotifier = JSON["ParentNotifier"] as! String
                            let Photo = JSON["Photo"] as! String
                            let ProfileCompleteness = JSON["ProfileCompleteness"] as! String
                            let Rate = JSON["Rate"] as? String
                            let SchoolVerified = JSON["SchoolVerified"] as! String
                            let TotalSearch = JSON["TotalSearch"] as! String
                            let live_Offer = JSON["live_Offer"] as? String
                            
                            DispatchQueue.main.async {
                             
                                self.jdVerifiedAccountTypeLabel.text = SchoolVerified
                                self.virtualActvieLabel.text = Is360ViewActived
                                self.schoolOffersLabel.text = live_Offer
                                self.profielCompleteNessLabel.text = ProfileCompleteness
                                self.admissionLeadsLabel.text = admissionLeadCounts
                                self.jdApplicationsLabel.text = JDApplication
                                self.eventConsentDetailLabel.text = EventConsentDetails
                                self.admissionLabel.text = admissionAlerts
                                self.jdSearchLabel.text = TotalSearch
                                self.parentNofifierLabel.text = ParentNotifier
                                self.advertisementGraphLabel.text = "View"
                                self.advertisementsLabel.text = advertisemsnts
                            }
                            
                        }else if responseCode == "500" {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Please enter valid email and password", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
                        }else {
                            
                            hudClass.hide()
                            parentClass.showAlertWithApiMessage(message: "some thing went worng")
                            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
