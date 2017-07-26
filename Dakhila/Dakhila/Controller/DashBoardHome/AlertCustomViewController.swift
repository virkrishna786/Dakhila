//
//  AlertCustomViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 19/07/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit

class AlertCustomViewController: UIViewController {
    @IBAction func urlButtonAction(_ sender: UIButton) {
    }

    @IBAction func okButtonAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    var sceenshotgImage : UIImage?
    @IBOutlet weak var customImaeView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.customImaeView.alpha = 0.5
        self.customImaeView.image = sceenshotgImage!
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
