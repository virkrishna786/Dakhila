//
//  DashBoardViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 18/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()

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
