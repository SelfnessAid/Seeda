//
//  AlertController.swift
//  Seeda
//
//  Created by Golden.Eagle on 6/12/16.
//  Copyright © 2016 Илья Железников. All rights reserved.
//

import UIKit

class AlertController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var destinationNameLabel: UILabel!
    @IBOutlet weak var ddLabel: UILabel!
    @IBOutlet weak var ddELabel: UILabel!
    @IBOutlet weak var ddNLabel: UILabel!
    @IBOutlet weak var dmsNLabel: UILabel!
    @IBOutlet weak var dmsELabel: UILabel!
    @IBOutlet weak var dmsLabel: UILabel!
    
    @IBOutlet weak var destinationName: UITextField!
    @IBOutlet weak var dmsLat1: UITextField!
    @IBOutlet weak var dmsLat2: UITextField!
    @IBOutlet weak var dmsLat3: UITextField!
    @IBOutlet weak var dmsLong1: UITextField!
    @IBOutlet weak var dmsLong2: UITextField!
    @IBOutlet weak var dmsLong3: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ddLat: UITextField!
    @IBOutlet weak var ddLong: UITextField!
    
   
   
    @IBOutlet weak var GoButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AlertController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AlertController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let superSize = self.view.superview!.frame.size
            let alertCenter: CGPoint = CGPointMake(superSize.width * 0.5, (superSize.height - keyboardSize.height - 10 - self.view.frame.size.height/2))
            self.view.center = alertCenter

        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            let superSize = self.view.superview!.frame.size
            let alertCenter: CGPoint = CGPointMake(superSize.width * 0.5, (superSize.height) * 0.5)
            self.view.center = alertCenter
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let language = defaults.objectForKey("language") as! String
        GoButton.layer.cornerRadius = 5.0
        CancelButton.layer.cornerRadius = 5.0
        GoButton.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        CancelButton.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        GoButton.layer.borderWidth = 1.0
        CancelButton.layer.borderWidth = 1.0
        self.view.layer.borderWidth = 1.0
        self.view.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        if (language == "english") {
            destinationNameLabel.text = "Enter Name"
            GoButton.titleLabel?.text = "Done"
            CancelButton.titleLabel?.text = "Cancel"
        } else {
            destinationNameLabel.text = "أدخل الاسم"
            GoButton.setTitle("تم", forState: .Normal)
            CancelButton.setTitle("الغاء", forState: .Normal)
        }
        self.destinationName.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.destinationName.layer.cornerRadius = 5.0
        self.destinationName.layer.borderWidth = 1.0
        self.ddLat.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.ddLat.layer.borderWidth = 1.0
        self.ddLat.layer.cornerRadius = 5.0
        self.ddLong.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.ddLong.layer.borderWidth = 1.0
        self.ddLong.layer.cornerRadius = 5.0
        self.dmsLat1.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.dmsLat1.layer.borderWidth = 1.0
        self.dmsLat1.layer.cornerRadius = 5.0
        self.dmsLat2.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.dmsLat2.layer.borderWidth = 1.0
        self.dmsLat2.layer.cornerRadius = 5.0
        self.dmsLat3.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.dmsLat3.layer.borderWidth = 1.0
        self.dmsLat3.layer.cornerRadius = 5.0
        self.dmsLong1.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.dmsLong1.layer.borderWidth = 1.0
        self.dmsLong1.layer.cornerRadius = 5.0
        self.dmsLong2.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.dmsLong2.layer.borderWidth = 1.0
        self.dmsLong2.layer.cornerRadius = 5.0
        self.dmsLong3.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.dmsLong3.layer.borderWidth = 1.0
        self.dmsLong3.layer.cornerRadius = 5.0
    }
    
    override func viewWillAppear(animated: Bool) {
        self.initUI()
    }
   
    //MARK: - UITextField Delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string.characters.count == 0 {
            return true
        }
        
        if textField != self.destinationName {
            let characterset = NSCharacterSet(charactersInString: "0123456789.-")
            if string.rangeOfCharacterFromSet(characterset.invertedSet) != nil {
                print("string contains special characters")
                return false
            } else {
                return true
            }
        }
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        if textField == self.destinationName {
            textField.resignFirstResponder()
        }
        
        if textField == self.ddLat {
            var latSeconds = (ddLat.text != nil && ddLat.text != "") ? Int(Double(ddLat.text!)! * 3600) : 0
            let latDegrees = latSeconds / 3600
            latSeconds = abs(latSeconds % 3600)
            let latMinutes = latSeconds / 60
            latSeconds %= 60
            dmsLat1.text = (latDegrees != 0) ? String(latDegrees) : ""
            dmsLat2.text = (latMinutes != 0) ? String(latMinutes) : ""
            dmsLat3.text = (latSeconds != 0) ? String(latSeconds) : ""
        }
        
        if textField == self.ddLong {
            let ddLongValue:Double? = Double(ddLong.text!)
            var longSeconds = (ddLong.text != nil && ddLong.text != "") ? Int(Double(ddLongValue!) * 3600) : 0
            let longDegrees = longSeconds / 3600
            longSeconds = abs(longSeconds % 3600)
            let longMinutes = longSeconds / 60
            longSeconds %= 60
            dmsLong1.text = (longDegrees != 0) ? String(longDegrees) : ""
            dmsLong2.text = (longMinutes != 0) ? String(longMinutes) : ""
            dmsLong3.text = (longSeconds != 0) ? String(longSeconds) : ""
        }
        
        if textField == self.dmsLat1 {
            let ddLat1Value:Int? = (dmsLat1.text != nil && dmsLat1.text != "") ? Int(dmsLat1.text!) : 0
            let ddLat2Value:Int? = (dmsLat2.text != nil && dmsLat2.text != "") ? Int(dmsLat2.text!) : 0
            let ddLat3Value:Int? = (dmsLat3.text != nil && dmsLat3.text != "") ? Int(dmsLat3.text!) : 0
            let lat = Double(ddLat1Value!) + Double((ddLat2Value! * 60 + ddLat3Value!)) / 3600
            ddLat.text = (lat != 0.0) ? String(lat) : ""
        }
        
        if textField == self.dmsLat2 {
            let ddLat1Value:Int? = (dmsLat1.text != nil && dmsLat1.text != "") ? Int(dmsLat1.text!) : 0
            let ddLat2Value:Int? = (dmsLat2.text != nil && dmsLat2.text != "") ? Int(dmsLat2.text!) : 0
            let ddLat3Value:Int? = (dmsLat3.text != nil && dmsLat3.text != "") ? Int(dmsLat3.text!) : 0
            let lat = Double(ddLat1Value!) + Double((ddLat2Value! * 60 + ddLat3Value!)) / 3600
            ddLat.text = (lat != 0.0) ? String(lat) : ""
        }
        
        if textField == self.dmsLat3 {
            let ddLat1Value:Int? = (dmsLat1.text != nil && dmsLat1.text != "") ? Int(dmsLat1.text!) : 0
            let ddLat2Value:Int? = (dmsLat2.text != nil && dmsLat2.text != "") ? Int(dmsLat2.text!) : 0
            let ddLat3Value:Int? = (dmsLat3.text != nil && dmsLat3.text != "") ? Int(dmsLat3.text!) : 0
            let lat = Double(ddLat1Value!) + Double((ddLat2Value! * 60 + ddLat3Value!)) / 3600
            ddLat.text = (lat != 0.0) ? String(lat) : ""
        }
        
        if textField == self.dmsLong1 {
            let ddLong1Value:Int? = (dmsLong1.text != nil && dmsLong1.text != "") ? Int(dmsLong1.text!) : 0
            let ddLong2Value:Int? = (dmsLong2.text != nil && dmsLong2.text != "") ? Int(dmsLong2.text!) : 0
            let ddLong3Value:Int? = (dmsLong3.text != nil && dmsLong3.text != "") ? Int(dmsLong3.text!) : 0
            let long = Double(ddLong1Value!) + Double((ddLong2Value! * 60 + ddLong3Value!)) / 3600
            ddLong.text = (long != 0.0) ? String(long) : ""
        }
        
        if textField == self.dmsLong2 {
            let ddLong1Value:Int? = (dmsLong1.text != nil && dmsLong1.text != "") ? Int(dmsLong1.text!) : 0
            let ddLong2Value:Int? = (dmsLong2.text != nil && dmsLong2.text != "") ? Int(dmsLong2.text!) : 0
            let ddLong3Value:Int? = (dmsLong3.text != nil && dmsLong3.text != "") ? Int(dmsLong3.text!) : 0
            let long = Double(ddLong1Value!) + Double((ddLong2Value! * 60 + ddLong3Value!)) / 3600
            ddLong.text = (long != 0.0) ? String(long) : ""
        }
        
        if textField == self.dmsLong3 {
            let ddLong1Value:Int? = (dmsLong1.text != nil && dmsLong1.text != "") ? Int(dmsLong1.text!) : 0
            let ddLong2Value:Int? = (dmsLong2.text != nil && dmsLong2.text != "") ? Int(dmsLong2.text!) : 0
            let ddLong3Value:Int? = (dmsLong3.text != nil && dmsLong3.text != "") ? Int(dmsLong3.text!) : 0
            let long = Double(ddLong1Value!) + Double((ddLong2Value! * 60 + ddLong3Value!)) / 3600
            ddLong.text = (long != 0.0) ? String(long) : ""
        }
    
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func GoBtnClick(sender: AnyObject) {
        self.view.endEditing(true)
        let ddLatValue:Double? = Double(ddLat.text!)
        let ddLongValue:Double? = Double(ddLong.text!)
        if let ddLatValue = ddLatValue, ddLongValue = ddLongValue {
            let controller = self.sideMenuController()?.childViewControllers[0] as! UINavigationController

            (controller.viewControllers[0] as! ViewController).addDestenationPoint(withLatitude: String(ddLatValue), longitude: String(ddLongValue), name: destinationName.text!) {

            }
            self.view.hidden = true
            if let image = UIImage(named: "MyLocation_Black.png") {
                (controller.viewControllers[0] as! ViewController).currentButton.setImage(image, forState: .Normal)
            }
        }
        else {
            let defaults = NSUserDefaults.standardUserDefaults()
            let language = defaults.objectForKey("language") as! String
            var message = ""
            var title = ""
            if language == "english" {
                message = "Lattitude or longitude are not numbers, try again, please"
                title = "Wrong data"
            }else{
                message = "خط العرض وخط الطول ليست أرقام . حاول مره اخري"
                title = "بيانات خاطئة"
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    @IBAction func CancelBtnClick(sender: AnyObject) {
        self.view.endEditing(true)
        self.view.hidden = true
    }
}
