//
//  SupportTicketViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 23/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit

class SupportTicketViewController: UIViewController ,UITextFieldDelegate{

    
    var boolValue = 0
    @IBAction func refreshButtonAction(_ sender: UIButton) {
    }
    @IBAction func submitButtonAction(_ sender: UIButton) {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(appDelegate.menuTableViewController)

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
