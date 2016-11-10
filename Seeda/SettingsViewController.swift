//
//  SettingsViewController.swift
//  UPWorkApp
//
//  Created by Илья Железников on 28/04/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

extension String{
    static func hui(){}
}


class SettingsViewController: UIViewController {

    @IBOutlet weak var lengthSwitch: UISwitch!
    @IBOutlet weak var length2: UILabel!
    @IBOutlet weak var length1: UILabel!
    @IBOutlet weak var languageSwitch: UISwitch!
    @IBOutlet weak var language2: UILabel!
    @IBOutlet weak var language1: UILabel!
    @IBOutlet weak var saflSwitch: UISwitch!
    @IBOutlet weak var usrSwitch: UISwitch!
    @IBOutlet weak var usrLabel: UILabel!
    @IBOutlet weak var saflLabel: UILabel!
    @IBOutlet weak var restorePurchaseBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let defaults = NSUserDefaults.standardUserDefaults()
        let language = defaults.objectForKey("language") as! String
        if language == "english"{
            languageSwitch.setOn(true, animated: false)
            language1.textColor = UIColor.lightGrayColor()
            language2.textColor = UIColor.blackColor()
            saflLabel.text = "Show all Favorites"
//            usrLabel.text = "Use the Same Route"
            usrLabel.text = "Tracking"
            restorePurchaseBtn.setTitle("Restore purchase", forState: .Normal)
        }else{
            languageSwitch.setOn(false, animated: false)
            language1.textColor = UIColor.blackColor()
            language2.textColor = UIColor.lightGrayColor()
            saflLabel.text = "عرض كل المفضلة"
            usrLabel.text = "تتبع المسار"
            restorePurchaseBtn.setTitle("إعادة الشراء", forState: .Normal)
        }
        let distance = defaults.objectForKey("distance") as! String
        if distance == "km"{
            lengthSwitch.setOn(true, animated: false)
            length1.textColor = UIColor.lightGrayColor()
            length2.textColor = UIColor.blackColor()
        }else{
            lengthSwitch.setOn(false, animated: false)
            length1.textColor = UIColor.blackColor()
            length2.textColor = UIColor.lightGrayColor()
        }
        let safl = defaults.objectForKey("SAFL") as! Bool
        saflSwitch.setOn(safl, animated: false)
        
        if (defaults.objectForKey("isTracking") != nil) {
            let usr = defaults.objectForKey("isTracking") as! Bool
            usrSwitch.setOn(usr, animated: false)
        } else {
            usrSwitch.setOn(false, animated: false)
        }
        
    
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func restorePurchasesPressed(sender: AnyObject) {
        var stringToShow = "There is an error occured while resotring"
        let pending = UIAlertController(title: "", message: nil, preferredStyle: .Alert)
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        indicator.color = UIColor.blackColor()
        pending.view.addSubview(indicator)
        indicator.userInteractionEnabled = false
        indicator.startAnimating()
        self.presentViewController(pending, animated: true, completion: nil)
        
        SwiftyStoreKit.restorePurchases() { results in
            
            pending.dismissViewControllerAnimated(true, completion: nil)
            
            if results.restoreFailedProducts.count > 0 {
            }
            else if results.restoredProductIds.count > 0 {
                stringToShow = "Restoring success"
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(true, forKey: "payed")
            }
            else {
                stringToShow = "Nothing to restore"
            }
            let alertController = UIAlertController(title: "Seeda", message:
                stringToShow, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Cancel ,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    
    @IBAction func languageSwitchToggled(sender: AnyObject) {
        defer{
            LanguageChanger.changeButtonLanguage()
            LanguageChanger.changeLabelLanguage()
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        if (sender.on == true){
            language1.textColor = UIColor.lightGrayColor()
            language2.textColor = UIColor.blackColor()
            defaults.setObject("english", forKey: "language")
            
            saflLabel.text = "Show all Favorites"
//            usrLabel.text = "Use the Same Route"
            usrLabel.text = "Tracking"
            restorePurchaseBtn.setTitle("Restore purchase", forState: .Normal)
        }else{
            language1.textColor = UIColor.blackColor()
            language2.textColor = UIColor.lightGrayColor()
            defaults.setObject("arabic", forKey: "language")
            saflLabel.text = "عرض كل المفضلة"
            usrLabel.text = "تتبع المسار"
            restorePurchaseBtn.setTitle("إعادة الشراء", forState: .Normal)
            
        }
    }

    
    @IBAction func distanceSwitchTogled(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if (sender.on == true){
            length1.textColor = UIColor.lightGrayColor()
            length2.textColor = UIColor.blackColor()
            defaults.setObject("km", forKey: "distance")
        }else{
            length1.textColor = UIColor.blackColor()
            length2.textColor = UIColor.lightGrayColor()
            defaults.setObject("mi", forKey: "distance")
        }
    }
    
    @IBAction func saflSwitchTogled(sender: AnyObject) { // show all favorite location
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(saflSwitch.on, forKey: "SAFL")
        
        let saflValue = ["safl":saflSwitch.on]
        
        NSNotificationCenter.defaultCenter().postNotificationName("kNotificationRefreshMap", object: nil, userInfo:saflValue)
        
    }
    
    @IBAction func usrSwitchTogled(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(usrSwitch.on, forKey: "isTracking")
//        if usrSwitch.on == false {
            let userValue = ["isTracking" : usrSwitch.on]
            NSNotificationCenter.defaultCenter().postNotificationName("kNotificationRefreshMap", object: nil, userInfo:userValue)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
