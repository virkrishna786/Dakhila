//
//  InviteViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 23/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Contacts

class InviteViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
    
    var contactArray  = [ContactArray]()
    var numberArray = [String]()
    @IBAction func addButtonAction(_ sender: UIButton) {
        self.mobileTableView.isHidden = true
        let dataStrig = self.numberArray.joined(separator: ",")
        let sdfs =  dataStrig.replacingOccurrences(of: "+91", with:"")
        self.numberTextfield.text = sdfs
    }
    
    
    @IBAction func contactListBiuttonAction(_ sender: UIButton) {
        self.mobileTableView.reloadData()
        self.mobileTableView.isHidden = false
    }
    @IBOutlet weak var mobileTableView: UITableView!
  //  @IBOutlet weak var mobileTextField: UITextField!
    var timer = Timer()
    
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

    @IBAction func contactListButtonAction(_ sender: UIButton) {
    }
        

    @IBOutlet weak var numberTextfield: UITextField!
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        if self.numberTextfield.text == "" && self.messagfeTextfield.text == "" {
            parentClass.showAlertWithApiMessage(message: "Please enter all the fields.")
        }else {
            self.apiCall()
        }
    }
    @IBOutlet weak var messagfeTextfield: UITextField!
    var schoolId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let userId = defaults.value(forKey: "schoolId") as? String
        self.schoolId = userId
        self.mobileTableView.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector:  #selector(InviteViewController.fetchContacts), userInfo: nil, repeats: false)
        self.addChildViewController(appDelegate.menuTableViewController)

        // Do any additional setup after loading the view.
    }
    
    
    func fetchContacts(){
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            guard granted else {
                let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> MyApp to enable contact permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var cnContacts = [CNContact]()
            
            do {
                try store.enumerateContacts(with: request){
                    (contact, cursor) -> Void in
                    cnContacts.append(contact)
                }
            } catch let error {
                NSLog("Fetch contact error: \(error)")
            }
            
            NSLog(">>>> Contact list:")
            for contact in cnContacts {
                let myDataArray = ContactArray()
                let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
                NSLog("fullName \(fullName):  phonenumer\(contact.phoneNumbers.description)")
                let phoneNUmber = contact.phoneNumbers
                print("dfds",phoneNUmber)
                
                for phone in contact.phoneNumbers{
                    let phones = phone.value as CNPhoneNumber
                    let digits = phones.value(forKey: "digits") as! String
                    print("df",digits)
                    myDataArray.contactName = fullName
                    myDataArray.phoneNumber = digits
                    self.contactArray.append(myDataArray)
                    //                    let sortedContactArray = self.contactArray.sort{ ($0.contactName)! < ($1.phoneNumber)! }
                    //                    self.contactArray.removeAll()
                    //                    self.contactArray.append(contentsOf: sortedContactArray)
                    
                }
            }
            DispatchQueue.main.async() {
                // Do stuff to UI
                self.mobileTableView.reloadData()
            }
        })
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let dataArray = self.contactArray[indexPath.row]
        cell.textLabel?.text = dataArray.contactName!
        cell.detailTextLabel?.text = dataArray.phoneNumber!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let data = self.contactArray[indexPath.row]
        if cell?.accessoryType == .checkmark{
            cell?.accessoryType = .none
            self.numberArray.remove(at: indexPath.row)
            print("sds",numberArray)
        }else {
            cell?.accessoryType = .checkmark
            self.numberArray.append(data.phoneNumber!)
            print("fdfdf",numberArray)
            
        }
        
    }

    
    func apiCall(){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let urlString = "\(baseUrl)/SchoolInviteParent"
            let mobilestring = "\(numberTextfield.text!)"
            let messageString  = "\(messagfeTextfield.text!)"
            
            let parameter = ["SchoolId" : "\(self.schoolId!)",
                "MobileNumber" : mobilestring,
                "Message" : messageString
                
            ]
            
            print("dfd \(parameter)")
            
            Alamofire.request(urlString, method: .post, parameters: parameter)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                   // print("Response String: \(response.result.value)")
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = response.result.value
                        let JSON = result as! NSDictionary
                        let responseCode = JSON["ResponseCode"] as! String
                        if responseCode == "200" {
                            hudClass.hide()
                            self.numberTextfield.text = ""
                            self.messagfeTextfield.text = ""
                            
                            let alertVC = UIAlertController(title: "Alert", message: "You have successfully sent message.", preferredStyle: .alert)
                            alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = numberTextfield.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 10 // Bool
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
