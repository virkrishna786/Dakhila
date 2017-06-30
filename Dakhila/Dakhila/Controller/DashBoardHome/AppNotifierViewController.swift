//
//  AppNotifierViewController.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 22/06/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Alamofire
import SwiftyJSON
class AppNotifierViewController: UIViewController,UITextFieldDelegate ,UIScrollViewDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate,UIPickerViewDelegate,UIPickerViewDataSource{

    var videoUrl : URL?
    var imageArray = [UIImage]()
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var runningTimeLabel: UILabel!
    @IBOutlet weak var myScollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    var classArray=NSMutableArray()
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
    
    @IBAction func postButtonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func audioSliderAction(_ sender: UISlider) {
    }
    @IBOutlet weak var audioSlider: UISlider!
    @IBAction func audioButtonAction(_ sender: UIButton) {
        
    }
    @IBAction func videoShowingButtonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var videoShwoingButton: UIButton!
    @IBAction func chooseVideoButtonAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            self.imagePicker.allowsEditing = false
            self.imagePicker.mediaTypes = [kUTTypeMovie as String]
            present(imagePicker, animated: true, completion: nil)
        }else {
            self.noCamara()
        }

    }
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBAction func camaraButtonAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }else {
            self.noCamara()
        }

    }
    @IBOutlet weak var notificaitonDateTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var notificationMessageTextField: UITextView!{
        didSet{
            notificationMessageTextField.layer.cornerRadius = 1.0
            notificationMessageTextField.layer.borderColor = UIColor.black.cgColor
            notificationMessageTextField.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var notificationTextField: UITextField!
    
    @IBAction func datePickerCpntroller(_ sender: UIDatePicker) {
        self.setDate()
    }
    @IBOutlet weak var classPickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var imagePicker = UIImagePickerController()
    var groupImage : UIImage?
    var resNameString : String?
    
    let dateFormatter = DateFormatter()
    
    func setDate() {
        datePicker.minimumDate = NSDate() as Date
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "YYYY-MM-dd"
       // self.timeLimitForOfferTextField.text = dateFormatter.string(from: datePicker.date)
        self.datePicker.isHidden = true
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        classArray=["Nursery","LKG","UKG"]
        classPickerView.frame.size.width=self.view.frame.size.width
        hitApi()
        classPickerView.delegate=self
        classPickerView.dataSource=self
        datePicker.addTarget(self, action: #selector(AppNotifierViewController.datePickerValueChanged(_:)), for: .valueChanged)
        //self.datePicker.addTarget(self, action:#selector(AppNotifierViewController.setDate(_:)), for: UIControlEvents.valueChanged)
        self.myScollView.delegate = self
        self.datePicker.isHidden = true
        self.myScollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 3000)
        self.myScollView.isScrollEnabled = true
        self.classPickerView.isHidden = true
        self.imageCollectionView.register(UINib(nibName: "customCell", bundle: nil), forCellWithReuseIdentifier: "cellIdentifier")

        
        // for choosing audio  from iphone
//        playButton.isEnabled = false
  //      stopButton.isEnabled = false
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        // emd
        self.addChildViewController(appDelegate.menuTableViewController)

        // Do any additional setup after loading the view.
    }
    
    // deleagte method for audio recodrding 
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        notificaitonDateTextField.text=selectedDate
        notificaitonDateTextField.textColor=UIColor.black
        datePicker.isHidden=true
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //recordButton.isEnabled = true
        //stopButton.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            //  profileImageView.contentMode = .scaleAspectFit
            // profileImageView.image = pickedImage
            DispatchQueue.global().async(execute: {
                self.setImage(image: pickedImage)
            })
            
        }else  {
            let mediaType = info[UIImagePickerControllerMediaURL] as! URL
            print("mediaType",mediaType)
            self.setVideo(video: mediaType)
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Set Image
    func  setImage(image: UIImage!)  {
        self.groupImage = image
        self.imageArray.append(self.groupImage!)
        self.imageCollectionView.reloadData()
        print("jkek \(self.groupImage!)")
    }
    
    // MARK:- Set Video Url
    
    func setVideo(video: URL!){
        self.videoUrl = video
        print("video",video)
        print("krishna")
    }
    
    func noCamara(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // COllection View Delgate and data source methods
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
      return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func  collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier",
                                                      for: indexPath) as! CustomCellType
        
        let data = imageArray[indexPath.row]
        cell.photoImageView.image =  data
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == notificationTextField {
            myScollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }else if textField==notificaitonDateTextField {
            
            print("testing")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        myScollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == notificaitonDateTextField  {
            
            self.datePicker.backgroundColor=UIColor.orange
            self.datePicker.isHidden = false
            self.classPickerView.isHidden=true
            print("test")
            return false
        }
        else if textField == classTextField {
            
            //self.datePicker.backgroundColor=UIColor.orange
            self.datePicker.isHidden = true
            self.classPickerView.backgroundColor=UIColor.orange
            self.classPickerView.isHidden=false
            print("test")
            return false
        }
        else {
            return true
        }
        return true
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return classArray.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return (classArray[row] as? NSDictionary)?.value(forKey: "Name") as? String
//        if stateArray.count > 0 {
//            if cityArray.count > 0 {
//                if localityArray.count > 0 {
//                    return   localityArray[row].localityName!
//                }else {
//                    return   cityArray[row].cityName!
//                }
//                
//            }else {
//                
//                return  stateArray[row].stateName!
//            }
//        }else {
//            return ""
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.classTextField.text = (classArray[row] as? NSDictionary)?.value(forKey: "Name") as? String
        self.classTextField.textColor=UIColor.black
        self.classPickerView.isHidden = true
    }
    func hitApi(){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let sid=defaults.value(forKey: "schoolId") as? String
            let  urlString = "\(baseUrl)/GetChildClasses?SchoolId=\(sid!)"
            
            //let parameter = ["SchoolId" : defaults.value(forKey: "schoolId") as? String]
            Alamofire.request(urlString, method: .get , parameters : nil)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    // print("Response String:", response.result.value)
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = JSON(response.result.value!)
                        //  let JSON = result as! NSDictionary
                        
                        print("result %@",response.result.value! )
                        
                        let responseCode = "200"//result["ResponseCode"].string
                        //print("response message \(responseCode!)")
                        
                        if responseCode == "200" {
                            hudClass.hide()
                            //self.cityArray = []
                            //self.localityArray = []
                            
                            self.classArray=((response.result.value as? NSArray)?.mutableCopy() as? NSMutableArray)!//(response.result.value as? NSArray)!
                            
                            DispatchQueue.main.async {
                                self.classPickerView.reloadAllComponents()
                                //self.pickerView.isHidden = false
                            }
                            print("success");
                            
                            
                        }else if responseCode == "500" {
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
