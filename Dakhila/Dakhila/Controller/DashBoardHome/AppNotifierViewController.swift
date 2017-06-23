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

class AppNotifierViewController: UIViewController,UITextFieldDelegate ,UIScrollViewDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate{

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
        }else {
            
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
        if textField == classTextField || textField == notificaitonDateTextField  {
            return false
        }else {
            return true
        }
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
