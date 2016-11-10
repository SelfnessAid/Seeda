//
//  CoordinationViewController.swift
//  Seeda
//
//  Created by Mobile Expert on 9/28/16.
//  Copyright © 2016 Илья Железников. All rights reserved.
//

import UIKit

class CoordinationViewController: UIViewController {

    @IBOutlet weak var ddNLabel: UILabel!
    @IBOutlet weak var ddLabel: UILabel!
    @IBOutlet weak var ddELabel: UILabel!
    @IBOutlet weak var ddLongTextField: UITextField!
    @IBOutlet weak var ddLatTextField: UITextField!
   
    @IBOutlet weak var dmsNLabel: UILabel!
    @IBOutlet weak var dmsLat1TextField: UITextField!
    @IBOutlet weak var dmsLat2TextField: UITextField!
    @IBOutlet weak var dmsLat3TextField: UITextField!
    @IBOutlet weak var dmsLong1TextField: UITextField!
    @IBOutlet weak var dmsLong2TextField: UITextField!
    @IBOutlet weak var dmsLong3TextField: UITextField!
    @IBOutlet weak var dmsELabel: UILabel!
    @IBOutlet weak var dmsLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.cancelButton.layer.cornerRadius = 5.0
        self.cancelButton.layer.borderWidth = 1.0
        self.cancelButton.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        
        self.view.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.view.layer.borderWidth = 1.0
        
        self.ddLatTextField.enabled = false
        self.ddLongTextField.enabled = false
        self.dmsLat1TextField.enabled = false
        self.dmsLat2TextField.enabled = false
        self.dmsLat3TextField.enabled = false
        self.dmsLong1TextField.enabled = false
        self.dmsLong2TextField.enabled = false
        self.dmsLong3TextField.enabled = false

        self.ddLatTextField.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.ddLatTextField.layer.borderWidth = 1.0
        self.ddLatTextField.layer.cornerRadius = 5.0
        self.ddLongTextField.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.ddLongTextField.layer.borderWidth = 1.0
        self.ddLongTextField.layer.cornerRadius = 5.0
        self.dmsLat1TextField.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.dmsLat1TextField.layer.borderWidth = 1.0
        self.dmsLat1TextField.layer.cornerRadius = 5.0
        self.dmsLat2TextField.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.dmsLat2TextField.layer.borderWidth = 1.0
        self.dmsLat2TextField.layer.cornerRadius = 5.0
        self.dmsLat2TextField.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.dmsLat3TextField.layer.borderWidth = 1.0
        self.dmsLat3TextField.layer.cornerRadius = 5.0
        self.dmsLong1TextField.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.dmsLong1TextField.layer.borderWidth = 1.0
        self.dmsLong1TextField.layer.cornerRadius = 5.0
        self.dmsLong2TextField.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.dmsLong2TextField.layer.borderWidth = 1.0
        self.dmsLong2TextField.layer.cornerRadius = 5.0
        self.dmsLong3TextField.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.dmsLong3TextField.layer.borderWidth = 1.0
        self.dmsLong3TextField.layer.cornerRadius = 5.0
        
        self.displayCurrentLocation()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        let language = defaults.objectForKey("language") as! String
        if (language == "english") {
            cancelButton.setTitle("Cancel", forState: .Normal)
        } else {
            cancelButton.setTitle("الغاء", forState: .Normal)
        }
    }
    
    func convertDDtoDMS(ddLat: Double, ddLong: Double) -> [[Int]]{
        var latSeconds = Int(ddLat * 3600)
        let latDegrees = latSeconds / 3600
        latSeconds = abs(latSeconds % 3600)
        let latMinutes = latSeconds / 60
        latSeconds %= 60
        var longSeconds = Int(ddLong * 3600)
        let longDegrees = longSeconds / 3600
        longSeconds = abs(longSeconds % 3600)
        let longMinutes = longSeconds / 60
        longSeconds %= 60
        
        var ret = [[Int]]()
        var latAry = [Int]()
        latAry.append(latDegrees)
        latAry.append(latMinutes)
        latAry.append(latSeconds)
        
        var longAry = [Int]()
        longAry.append(longDegrees)
        longAry.append(longMinutes)
        longAry.append(longSeconds)
        
        ret.append(latAry)
        ret.append(longAry)
        
        return ret
        
    }
    
    func displayCurrentLocation() {
        if let lat = ViewController.location?.latitude, long = ViewController.location?.longitude{
            //                let locationString = "lat=\(lat), long=\(long)"

            let ddLatValue:Double? = Double(lat)
            let ddLongValue:Double? = Double(long)
            
            var dmsData:[[Int]] = convertDDtoDMS(ddLatValue!, ddLong: ddLongValue!)
            
            self.ddLatTextField.text = String(format:"%.4f", ddLatValue!)
            self.ddLongTextField.text = String(format:"%.4f", ddLongValue!)
            
            self.dmsLat1TextField.text = String(dmsData[0][0])
            self.dmsLat2TextField.text = String(dmsData[0][1])
            self.dmsLat3TextField.text = String(dmsData[0][2])
            self.dmsLong1TextField.text = String(dmsData[1][0])
            self.dmsLong2TextField.text = String(dmsData[1][1])
            self.dmsLong3TextField.text = String(dmsData[1][2])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelBtnPressed(sender: AnyObject) {
        self.view.endEditing(true)
        self.view.hidden = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
