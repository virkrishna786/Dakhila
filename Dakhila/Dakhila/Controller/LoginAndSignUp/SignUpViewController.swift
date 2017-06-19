//
//  SignUpViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 18/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var myScroolView: UIScrollView!
    @IBOutlet weak var playSchoolButton: UIButton!
    
    @IBOutlet weak var daySchoolButton: UIButton!
    
    @IBOutlet weak var daysBoardingSchoolButotn: UIButton!
    
    @IBOutlet weak var resedentailSchoolButton: UIButton!
    
    @IBOutlet weak var schoolNameTextField: UITextField!
    
    @IBOutlet weak var schoolEmailIdTextField: UITextField!
    
    @IBOutlet weak var schoolCOntactNumberTextField: UITextField!
    
    @IBOutlet weak var stateButton: UIButton!
   
    @IBOutlet weak var cityButton: UIButton!
    
    @IBOutlet weak var lcoalityButton: UIButton!
    
    @IBAction func playSchoolButttonAction(_ sender: UIButton) {
    }
    
    @IBAction func dayschoolButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func dayBoardingSchoolButtonAction(_ sender: UIButton) {
    }
    
    
    @IBAction func resedentailSchoolButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func stateButtonAction(_ sender: UIButton) {
    }
    
    
    @IBAction func cityButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func localityButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
