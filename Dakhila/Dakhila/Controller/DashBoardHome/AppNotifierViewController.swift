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
import AVKit
import AVFoundation

class AppNotifierViewController: UIViewController,UITextFieldDelegate ,UIScrollViewDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate,UIPickerViewDelegate,UIPickerViewDataSource, AVPlayerViewControllerDelegate,UITextViewDelegate{

    @IBOutlet weak var audioFileLabel: UILabel!
    var videoUrl : URL?
    var imageArray = [UIImage]()
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer?
    var classTypeArray  = [ChildClassArrayClass]()
    let date = Date()
    let formatter = DateFormatter()
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.notificationMessageTextField.text = ""
        self.notificationTextField.text = ""
        self.notificaitonDateTextField.text = ""
        
    }
    @IBOutlet weak var videoView: UIView!
    @IBAction func photoDeleteButtonAction(_ sender: UIButton) {
        self.imageArray.removeAll()
        self.imageCollectionView.reloadData()
        
    }
    @IBAction func homeButtonAction(_ sender: UIButton) {
        let firstView:DashBoardViewController
            = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Dashboard") as! DashBoardViewController
             var fcheck=Bool()
        fcheck=false
        let viewArray=self.navigationController?.viewControllers as NSArray!
        if((viewArray) != nil){
            if !((viewArray?.lastObject! as! UIViewController) .isKind(of: DashBoardViewController.self)){
                
                for views in self.navigationController?.viewControllers as NSArray!
                {
                    if((views as! UIViewController) .isKind(of: DashBoardViewController.self))
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
        }else{
            appDelegate.navigationController?.pushViewController(firstView, animated: true)
            // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
        }

        
    }
    @IBOutlet weak var homeButton: UIButton!
    @IBAction func crossButtonAction(_ sender: UIButton) {
        self.audioFileLabel.isHidden = true
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
        
    if !(notificationTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&  !(notificationMessageTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            self.postApiCall()
        } 
        else{
           parentClass.showAlertWithApiMessage(message: "Please fill all fields.")
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func audioSliderAction(_ sender: UISlider) {
    }
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBAction func audioButtonAction(_ sender: UIButton) {
        if audioRecorder?.isRecording == false{
            playButton.isEnabled = false
            stopButton.isEnabled = true
            audioRecorder?.record()
        }
    }
    @IBAction func videoShowingButtonAction(_ sender: UIButton) {
        
        if self.videoUrl == nil{
            parentClass.showAlertWithApiMessage(message: "Please add video from library.")
        }else {
        
        self.videoView.isHidden = false
        let player = AVPlayer(url: self.videoUrl!)
        let playerController = AVPlayerViewController()
            NotificationCenter.default.addObserver(self, selector: #selector(AppNotifierViewController.playerItemDidPlayToEndTime(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        playerController.player = player
        
        self.addChildViewController(playerController)
        self.myScollView.addSubview(playerController.view)
        playerController.view.frame = self.videoView.frame
        player.play()
        }
    }
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    func playerItemDidPlayToEndTime(note: NSNotification){
        //self.videoView.removeFromSuperview()
       // self.dismiss(animated: true, completion: nil)
        //let player =  AVPlayer()
    }
    
    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool {
        self.videoView.isHidden = true
        return true
    }
    @IBOutlet weak var videoShwoingButton: UIButton!
    @IBAction func chooseVideoButtonAction(_ sender: UIButton) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Choose an option!", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            //Just dismiss the action sheet
            self.openCamara()
                    }
        let addCamaraAction: UIAlertAction = UIAlertAction(title: " Video from Library", style: .default) { action -> Void in
            //Just dismiss the action sheet
           self.photoFromCamara()
        }
        actionSheetController.addAction(addCamaraAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)

    }
    
    func openCamara(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.allowsEditing = false
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.mediaTypes = [kUTTypeMovie as String]
            present(imagePicker, animated: true, completion: nil)
        }else {
            self.noCamara()
        }
    }
    
    func photoFromCamara(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            self.imagePicker.allowsEditing = false
            self.imagePicker.delegate = self
            self.imagePicker.mediaTypes = [kUTTypeMovie as String]
            present(imagePicker, animated: true, completion: nil)
        }else {
            self.noCamara()
        }
    }
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBAction func camaraButtonAction(_ sender: UIButton) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Choose an option!", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            //Just dismiss the action sheet
            self.openCamaraForPic()
        }
        let addCamaraAction: UIAlertAction = UIAlertAction(title: "Photo from Library", style: .default) { action -> Void in
            //Just dismiss the action sheet
            self.photoFromCamaraForPic()
        }
        actionSheetController.addAction(addCamaraAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)

    }
    
    func openCamaraForPic(){
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker.delegate = self
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .camera
                    present(imagePicker, animated: true, completion: nil)
                }else {
                    self.noCamara()
                }
    }
    
    func photoFromCamaraForPic(){
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    self.imagePicker.delegate = self
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
        self.datePicker.isHidden = true
    }

    var schoolId : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.audioFileLabel.isHidden = true

        imagePicker.delegate = self
        self.videoView.isHidden = true
        notificationMessageTextField.delegate = self
        
        classArray=["Nursery","LKG","UKG"]
        self.dateLabel.layer.borderWidth = 1
        self.dateLabel.layer.borderColor = UIColor.black.cgColor
        classPickerView.frame.size.width=self.view.frame.size.width
        
        formatter.dateFormat = "dd MM yyyy"
        let result = formatter.string(from: date)
        dateLabel.text = "\(result)"
        print("kjbk ",dateLabel.frame)
        
        let sid=defaults.value(forKey: "schoolId") as? String
        self.schoolId = sid
        let timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
        print("\(timer)")

        self.addChildViewController(appDelegate.menuTableViewController)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.myScollView.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    func tap(gesture: UITapGestureRecognizer) {
        notificaitonDateTextField.resignFirstResponder()
        notificationMessageTextField.resignFirstResponder()
        self.videoView.isHidden = true
        self.view.endEditing(true)
        self.myScollView.endEditing(true)
        //textField.resignFirstResponder()
    }
    //MARK:-Audio 
    @IBAction func stopAudio(sender: AnyObject) {
        
        stopButton.isEnabled = false
        playButton.isEnabled = true
        recordButton.isEnabled = true
        self.audioFileLabel.text = "File.mp3"
        self.audioFileLabel.isHidden = false
        
        if audioRecorder?.isRecording == true{
            audioRecorder?.stop()
        }else{
            audioPlayer?.stop()
        }
    }
    
    @IBAction func playAudio(sender: AnyObject) {
        if audioRecorder?.isRecording == false{
            stopButton.isEnabled = true
            recordButton.isEnabled = false
            //audioPlayer=AVAudioPlayer(contentsOf: audioRecorder?.url)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("error loading file")
                // couldn't load file :(
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        recordButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        print("Audio Record Encode Error")
    }
    // Update Method
    
    
    func update(){
        DispatchQueue.main.async {
            self.hitApi()
            self.classPickerView.delegate=self
            self.classPickerView.dataSource=self
            self.datePicker.addTarget(self, action: #selector(AppNotifierViewController.datePickerValueChanged(_:)), for: .valueChanged)
            self.myScollView.delegate = self
            self.datePicker.isHidden = true
            self.myScollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 2000)
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
                try self.audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                    settings: recordSettings as [String : AnyObject])
                self.audioRecorder?.prepareToRecord()
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }
            
  
        }
        
    }
    
    // deleagte method for audio recodrding 
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy"
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
            //DispatchQueue.global().async(execute: {
                self.setImage(image: pickedImage)
            //})
            
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
        
        if self.imageArray.count > 5 {
            DispatchQueue.main.async {
                let alertVC = UIAlertController(title: "Alert", message: "you can not select more than 5 images.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
            }
            
        }else {
        self.imageCollectionView.reloadData()
        }
    }
    
    // MARK:- Set Video Url
    
    func setVideo(video: URL!){
        self.videoUrl = video
        let image=getThumbnailImage(forUrl: video)
        let imageView=UIImageView()
        imageView.frame=self.videoView.frame
        imageView.image=image
        myScollView.addSubview(imageView)
        
        //self.videoView.isHidden=false
        //self.videoView.backgroundColor=UIColor.clear
        //self.videoView.addSubview(imageView)
        //self.videoView.bringSubview(toFront: imageView)

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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Type Text Here" {
             textView.text = ""
           return true
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.notificationMessageTextField.resignFirstResponder()
    }
    


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classTypeArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return classTypeArray[row].className
    }
    
    
    var classIdString : Int?
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.classTextField.text = classTypeArray[row].className
        self.classIdString = classTypeArray[row].classId
        self.classTextField.textColor=UIColor.black
        self.classPickerView.isHidden = true
    }
    func hitApi(){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let  urlString = "\(baseUrl)/GetAllChildClasses"
            
            //let parameter = ["SchoolId" : "\(self.schoolId!)"]
            Alamofire.request(urlString, method: .get)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    // print("Response String:", response.result.value)
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = JSON(response.result.value!)
                        //  let JSON = result as! NSDictionary
                        print("result %@",response.result.value! )
                        let responseCode =   "200"
                        
                        if responseCode == "200" {
                            hudClass.hide()
                            self.classArray = []
                            let dataArray = result.array
                            
                            for data in dataArray! {
                               let classObject =  ChildClassArrayClass()
                              classObject.classId = data["ClassId"].int
                              classObject.className = data["ClassName"].string
                              self.classTypeArray.append(classObject)
                            }
                            
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
    
    // Post notifier api hit 
    
    func postApiCall(){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let  urlString = "\(baseUrl)/CreateSchoolNotification"
            
            let notificationTitle = notificationTextField.text!
            let notificationMessage = notificationMessageTextField.text!
            let classString  = "\(self.classIdString!)"
            let dateString = notificaitonDateTextField.text!
            
            let parameter = ["SchoolId": "\(self.schoolId!)",
                "Title": notificationTitle,
                "ClassId": classString,
                "Message" : notificationMessage,
                "BroadcastDate" : dateString,
                ]

            print("dfd \(parameter)")
            
            Alamofire.request(urlString, method: .post, parameters: parameter)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                      //print("Response String:", response.result.value!)
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = response.result.value
                        let json = JSON(result!)
                        print("result %@",response.result.value! )
                        let responseCode = json["NotificationId"].int
                        
                        if responseCode == 0 {
                            let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
                        }else {
                            hudClass.hide()
                            print("success")
                            self.notificationMessageTextField.text = ""
                            self.notificationTextField.text = ""
                            self.notificaitonDateTextField.text = ""
                            let responseMessage = json["ResponseText"].string
                            let notificationId = "\(json["NotificationId"])"
                            print("response message \(String(describing: responseMessage))")
                            print("\(String(describing: notificationId))")
                            let alertVC = UIAlertController(title: "Alert", message: "Your Notification has been created.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: { UIAlertAction in
                                if notificationId == "0"{
                                }else {
                                    self.uploadImageAPi(notificationId: Int(notificationId)!)
                                }
                            })
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
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
    
    
    // final upload of document 
    
    
    func finalUploadOfDoucment(notificationId: Int ,fileType:String , filePath: String){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let  urlString = "\(baseUrl)/SaveNotificationFilesPath"
            
            
            let parameter = ["NotificationId": "\(notificationId)",
                "FilePath": filePath,
                "FileType": fileType
                ]
            
            print("dfd \(parameter)")
            
            Alamofire.request(urlString, method: .post, parameters: parameter)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    //print("Response String:", response.result.value!)
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = response.result.value
                        let json = JSON(result!)
                        print("result %@",response.result.value! )
                        let responseCode = json["NotificationId"].int
                        
                        if responseCode == 0 {
                            let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
                        }else {
                            hudClass.hide()
                            print("success")
                            let responseMessage = json["ResponseText"].string
                            let notificationId = "\(json["NotificationId"])"
                            print("response message \(String(describing: responseMessage))")
                            print("\(String(describing: notificationId))")
//                            let alertVC = UIAlertController(title: "Alert", message: "Your imag.", preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "OK",style:.default,handler: { UIAlertAction in
//                               
//                            })
//                            alertVC.addAction(okAction)
//                            self.present(alertVC, animated: true, completion: nil)
                        }
                        
                    }else {
                        hudClass.hide()
                        //parentClass.showAlertWithApiFailure()
                    }
            }
            
            
        }else {
            hudClass.hide()
            parentClass.showAlert()
        }
        
        
    }

    var counter = 0
    var paramArray : NSMutableArray = []
    var jsonString : String?
    var notfId : Int?
    
    func uploadImageAPi(notificationId : Int){
        
        notfId=notificationId

        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let  urlString = "\(baseUrl)/iosImageUpload"
            if((self.videoUrl) != nil){
                
                self.uploadVideoApi(image: self.videoUrl!)
            }
            if((audioPlayer?.url) != nil){
                
                uploadSoundApi()
            }
            for image in self.imageArray {
                print(image)
               // let dict : NSMutableDictionary! = [:]
                let name = "ni_" + "\(self.schoolId!)" + "_" + "\(notificationId)" + "_" + "\(self.counter)" + ".png"
                self.uploadImageApi(image: image , nameString: name)
//                let imageData: NSData = UIImageJPEGRepresentation(image, 0.4)! as NSData
//                let imageStr = imageData.base64EncodedString(options:.lineLength64Characters)
//                let imagedata = imageStr
//                dict.setValue(name, forKey: "name")
//                dict.setValue(imagedata, forKey: "data")
//               self.paramArray.add(dict)
                counter = counter + 1
            }
            //print(JSON(self.paramArray))
            //print("paramArray :" ,paramArray)
            
                let data = try? JSONSerialization.data(withJSONObject: self.paramArray, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
                let url: NSURL = NSURL(string: urlString)!
                let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
                let bodyData = jsonString
                //print(jsonString)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               // request .setValue(token, forHTTPHeaderField:"tokenValue")
                request.httpBody = bodyData!.data(using: String.Encoding.utf8);
                NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
                {
                    (response, data, error) in
                    
                    let responseDic=try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if((responseDic) != nil){
                        print(" fggdf \(String(describing: responseDic))")
                        
                        if(((responseDic?.value(forKey: "status"))! as! NSObject) as! Decimal==1){
                            hudClass.hide()
                            print("success")
                        }
                    }else {
                        hudClass.hide()
                        print("eroorfd dfs")
                    }
                }
        
            
        }else {
            hudClass.hide()
            parentClass.showAlert()
        }
    }
    // upload video
    func  uploadVideoApi(image : URL) {
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            
            let URL = try! URLRequest(url: "http://justadmission.in/UploadFiles.ashx?SavePath=Upload/NotificationFiles/\(self.schoolId!)/", method: .post)
            print("URLS : \(URL)")
            //let name = "ni_" + "\(self.schoolId!)" + "_" + "\(notificationId)" + "_" + "\(self.counter)" + ".png"
            let name = "nv_" + "\(self.schoolId!)" + "_" + "\(notfId!)" + "_" + "\(self.counter)" + ".MOV"
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(image, withName: name, fileName: name, mimeType: "mov/mp4/avi/MOV/MP4")
                
            }, with: URL, encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    print("successessret")
                    upload.responseString { response in
                        print("request dfd \(response.request!)")
                        print("response data \(response.data!)")
                        print("response.result value \(String(describing: response.result.value))")
                        switch  response.result {
                        case .success(let datads) :
                            hudClass.hide()
                            print("dasdfkas \(datads)")
                            let dsfs = datads.data(using: String.Encoding.utf8)!
                            let json = JSON(data: dsfs)
                            print("JSOn " ,json)
                            let   filePath = String(describing: ((json.arrayObject?[0])! as! NSDictionary).value(forKey: "URL")!)
                            print("sfs \(String(describing: ((json.arrayObject?[0])! as! NSDictionary).value(forKey: "URL")))")
                            self.finalUploadOfDoucment(notificationId: self.notfId!, fileType: "video", filePath: filePath)
                            
                        case .failure(let errordarta) :
                            hudClass.hide()
                            print("err0rdata \(errordarta)")
                        }
                    }
                case .failure(let encodingError):
                    hudClass.hide()
                    parentClass.showAlertWithApiFailure()
                    print(encodingError)
                }
            })
        }else {
            hudClass.hide()
            parentClass.showAlert()
        }
    }
    
    // MARK:- Upload Image 
    
    
    func  uploadImageApi(image : UIImage ,nameString: String) {
        if currentReachabilityStatus != .notReachable {
            
            //  let images   = UIImage(named : "\(self.groupImage!)")
            //  print("images \(images)")
            let   imagedata  = UIImageJPEGRepresentation(image, 0.2)
            print("imageDatadd \(imagedata!)")
            hudClass.showInView(view: self.view)
            
            let URL = try! URLRequest(url:  "http://justadmission.in/UploadFiles.ashx?SavePath=Upload/NotificationFiles/\(self.schoolId!)/", method: .post)
            print("URLS : \(URL)")
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imagedata!, withName: nameString, fileName: nameString, mimeType: "image/png/jpeg/jpg")
                
            }, with: URL, encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    print("successessret")
                    upload.responseString { response in
                        print("request dfd \(response.request!)")
                        print("response data \(response.data!)")
                        print("response.result value \(String(describing: response.result.value))")
                        switch  response.result {
                        case .success(let datads) :
                            
                            let dsfs = datads.data(using: String.Encoding.utf8)!
                            let json = JSON(data: dsfs)
                            print("JSOn " ,json)
                         let   filePath = String(describing: ((json.arrayObject?[0])! as! NSDictionary).value(forKey: "URL")!)
                            print("sfs \(String(describing: ((json.arrayObject?[0])! as! NSDictionary).value(forKey: "URL")))")
                            
                        self.finalUploadOfDoucment(notificationId: self.notfId!, fileType: "image", filePath: filePath)
//
                            
                        case .failure(let errordarta) :
                            hudClass.hide()
                            print("err0rdata \(errordarta)")
                        }
                    }
                case .failure(let encodingError):
                    hudClass.hide()
                    parentClass.showAlertWithApiFailure()
                    print(encodingError)
                }
            })
        }else {
            hudClass.hide()
            parentClass.showAlert()
        }
    }

    //upload sound
    func  uploadSoundApi() {
        if currentReachabilityStatus != .notReachable {
            
            //   let images   = UIImage(named : "\(self.groupImage!)")
            //   print("images \(images)")
            //  let   imagedata  = UIImageJPEGRepresentation(image, 0.2)
            // print("imageDatadd \(imagedata!)")
            hudClass.showInView(view: self.view)
            
            let URL = try! URLRequest(url: "http://justadmission.in/UploadFiles.ashx?SavePath=Upload/NotificationFiles/\(self.schoolId!)/", method: .post)
            print("URLS : \(URL)")
            //let name = "ni_" + "\(self.schoolId!)" + "_" + "\(notificationId)" + "_" + "\(self.counter)" + ".png"
            let name = "na_" + "\(self.schoolId!)" + "_" + "\(notfId!)" + "_" + "\(self.counter)" + ".mp3"
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(self.audioRecorder.url, withName: name, fileName: name, mimeType: "mov/mp4/avi/MOV/MP4/mp3")
                
            }, with: URL, encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    print("successessret")
                    upload.responseString { response in
                        print("request dfd \(response.request!)")
                        print("response data \(response.data!)")
                        print("response.result value \(String(describing: response.result.value))")
                        switch  response.result {
                        case .success(let datads) :
                            print("dasdfkas \(datads)")
                            let dsfs = datads.data(using: String.Encoding.utf8)!
                            let json = JSON(data: dsfs)
                            print("JSOn " ,json)
                            let   filePath = String(describing: ((json.arrayObject?[0])! as! NSDictionary).value(forKey: "URL")!)
                            print("sfs \(String(describing: ((json.arrayObject?[0])! as! NSDictionary).value(forKey: "URL")))")
                            
                            self.finalUploadOfDoucment(notificationId: self.notfId!, fileType: "audio", filePath: filePath)
                            
                        case .failure(let errordarta) :
                            hudClass.hide()
                            print("err0rdata \(errordarta)")
                        }
                    }
                case .failure(let encodingError):
                    hudClass.hide()
                    parentClass.showAlertWithApiFailure()
                    print(encodingError)
                }
            })
        }else {
            hudClass.hide()
            parentClass.showAlert()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.videoView.isHidden = true
        self.view.endEditing(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
