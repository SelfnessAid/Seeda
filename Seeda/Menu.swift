//
//  Menu.swift
//  UPWorkApp
//
//  Created by Илья Железников on 27/04/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import UIKit
import SimpleAlert
import StoreKit
import SwiftyStoreKit
import ZAlertView

class Menu: UIViewController, HistoryViewControllerDelegate{
    
    func buy(){
        var stringToShow = "There is an error occured while purchasing"
        let pending = UIAlertController(title: "", message: nil, preferredStyle: .Alert)
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        indicator.color = UIColor.blackColor()
        pending.view.addSubview(indicator)
        indicator.userInteractionEnabled = false
        indicator.startAnimating()
        self.presentViewController(pending, animated: true, completion: nil)
        
        
        SwiftyStoreKit.purchaseProduct("unlockAll1", completion:{ result in
            
            pending.dismissViewControllerAnimated(true, completion: nil)
            
            switch result {
            case .Success:
                stringToShow = "Thank you for your purchase"
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(true, forKey: "payed")
            case .Error(let error):
                stringToShow += ""
                
                print(error)
            }
            let alertController = UIAlertController(title: "Seeda", message:
                stringToShow, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)

        })
    }
    
    func didSelectHistory(sender: HistoryViewController) {
        if let image = UIImage(named: "MyLocation_Black.png") {
            let controller = self.sideMenuController()?.childViewControllers[0] as! UINavigationController
            (controller.viewControllers[0] as! ViewController).currentButton.setImage(image, forState: .Normal)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var CoordinationButton: UIButton!
    @IBOutlet weak var CalculatorButton: UIButton!
    @IBOutlet weak var SaveLocationButton: UIButton!
    @IBOutlet weak var FavoriteButton: UIButton!
    @IBOutlet weak var NewDestenationButton: UIButton!
    @IBOutlet weak var SettingsButton: UIButton!
    @IBOutlet weak var HistoryButton: UIButton!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var AboutButton: UIButton!
    @IBOutlet weak var showLastTrackBtn: UIButton!
    var dialog:ZAlertView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        let language = defaults.objectForKey("language") as! String
        if (language == "english") {
            titleLabel.text = "Seeda"
        } else {
            titleLabel.text = "ســــیدا"
        }
        LanguageChanger.buttonStrings[SaveLocationButton] = ("Save Location", "حفظ الموقع")
        LanguageChanger.buttonStrings[FavoriteButton] = ("Favorite", "المفضلة")
        LanguageChanger.buttonStrings[NewDestenationButton] = ("New Destination", "الوجهة الجديدة")
        LanguageChanger.buttonStrings[SettingsButton] = ("Settings", "الاعدادات")
        LanguageChanger.buttonStrings[HistoryButton] = ("History", "السجل")
        LanguageChanger.buttonStrings[AboutButton] = ("About", "حول")
        LanguageChanger.buttonStrings[ShareButton] = ("Share Location", "مشاركة الموقع")
        LanguageChanger.buttonStrings[CalculatorButton] = ("Calculate Distance", "حساب المسافات")
        LanguageChanger.buttonStrings[CoordinationButton] = ("Coordination", "الاحداثيات")
        LanguageChanger.buttonStrings[showLastTrackBtn] = ("Show last tracking", "عرض المسار الاخير")
        LanguageChanger.changeButtonLanguage()
        
        ZAlertView.positiveColor            = UIColor(red: 198/255, green: 215/255, blue: 238/255, alpha: 1.0)
        ZAlertView.negativeColor            = UIColor(red: 198/255, green: 215/255, blue: 238/255, alpha: 1.0)
        ZAlertView.buttonTitleColor         = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0)
        ZAlertView.titleColor               = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0)
        ZAlertView.textFieldBackgroundColor = UIColor(red: 198/255, green: 215/255, blue: 238/255, alpha: 1.0)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "historyTable" {
            let vc = segue.destinationViewController as! HistoryViewController
            vc.delegate = self
        }
    }
    
//    @IBAction func sharePressed(sender: AnyObject) {
//
//    }
    @IBAction func calculatorPressed(sender: AnyObject) {
        self.sideMenuController()?.toggleSidePanel()
        let controller = self.sideMenuController()?.childViewControllers[0] as! UINavigationController
        
        (controller.viewControllers[0] as! ViewController).showCalculatorFromSideMenu()
    }
    
    @IBAction func coordinatioPressed(sender: AnyObject) {
        self.sideMenuController()?.toggleSidePanel()
        let controller = self.sideMenuController()?.childViewControllers[0] as! UINavigationController
        
        (controller.viewControllers[0] as! ViewController).showCoordinationFromSideMenu()
    }
    
    @IBAction func newDestenationPressed(sender: AnyObject) {
        self.sideMenuController()?.toggleSidePanel()
        let controller = self.sideMenuController()?.childViewControllers[0] as! UINavigationController
        
        (controller.viewControllers[0] as! ViewController).addPointFromSideMenu()
    
    }
    
    func saveLocation(defaults : NSUserDefaults, title3 : String, message1 : String, title4 : String, title5 : String) {
        
        let textField = dialog.getTextFieldWithIdentifier("name")
        if let name = textField!.text {
            let point = Point(latitude: String(ViewController.location!.latitude), longitude: String(ViewController.location!.longitude), name: name)
            
            
            if(defaults.arrayForKey("points") == nil){
                let points = [point]
                let dataPoints = points.map{NSKeyedArchiver.archivedDataWithRootObject($0)}
                defaults.setObject(dataPoints, forKey: "points")
            }else{
                
                var points = (defaults.arrayForKey("points") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
                
                if(defaults.boolForKey("payed")){
                    points.append(point)
                    let dataPoints = points.map{NSKeyedArchiver.archivedDataWithRootObject($0)}
                    defaults.setObject(dataPoints, forKey: "points")
                }else{
                    if (points.count > 0){
                        let alert = UIAlertController(title: title3, message: message1 as String, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: title4, style: .Default){
                            _ in
                            self.buy()
                            })
                        alert.addAction(UIAlertAction(title: title5, style: .Default){ _ in})
                        self.presentViewController(alert, animated: true, completion: nil)
                    }else{
                        points.append(point)
                        let dataPoints = points.map{NSKeyedArchiver.archivedDataWithRootObject($0)}
                        defaults.setObject(dataPoints, forKey: "points")
                    }
                }
            }
        }
        
    }
    
    @IBAction func saveLocationPressed(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
//        var name = ""
        
        let language = defaults.objectForKey("language") as! String
        
        var title1 = ""
        var placeholder1 = ""
        var title2 = ""
        var title3 = ""
        var message1 = ""
        var title4 = ""
        var title5 = ""
        var title6 = ""
        if language == "english"{
            title1 = "Add name"
            placeholder1 = "Name"
            title2 = "Done"
            title3 = "Error"
            message1 = "You need to pay to save more than one location"
            title4 = "Buy"
            title5 = "Later"
            title6 = "Cancel"
        }else{
            title1 = "إضافة اسم"
            placeholder1 = "اسم"
            title2 = "إضافة"
            title3 = "خطأ"
            message1 = "يجب شراء البرنامج لتخزين المواقع بلا حدود"
            title4 = "شراء"
            title5 = "في وقت لاحق"
            title6 = "إلغاء"
        }
        dialog = ZAlertView(title: title1, message: "", isOkButtonLeft: true, okButtonText: title2, cancelButtonText: title6, okButtonHandler: { alertView in
                self.saveLocation(defaults, title3: title3, message1: message1, title4: title4, title5: title5)
                alertView.dismiss()
            }, cancelButtonHandler: { alertView in
                alertView.dismiss()
            }
        )
        dialog.addTextField("name", placeHolder: placeholder1)
        dialog.show()
    }
    
    @IBAction func historyPressed(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let language = defaults.objectForKey("language") as! String
        var title1 = ""
        var message1 = ""
        var title2 = ""
        var title3 =  ""
        if language == "english"{
            title1 = "Error"
            message1 = "You need to pay to save more than one location"
            title2 = "Buy"
            title3 = "Later"
        }else{
            title1 = "خطأ"
            message1 = "يجب شراء البرنامج لتخزين المواقع بلا حدود"
            title2 = "شراء"
            title3 = "في وقت لاحق"
        }
        
        
        if !defaults.boolForKey("payed"){
            let alert = UIAlertController(title: title1, message: message1, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: title2, style: .Default){
                _ in
                self.buy()
                })
            alert.addAction(UIAlertAction(title: title3, style: .Default){ _ in})
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func showLastTrackingBtnPressed(sender: AnyObject) {
        self.sideMenuController()?.toggleSidePanel()
        let userValue = ["showLastTracking" : true]
        NSNotificationCenter.defaultCenter().postNotificationName("kNotificationRefreshMap", object: nil, userInfo:userValue)
    }
}
