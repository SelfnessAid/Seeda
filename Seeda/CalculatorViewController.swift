  //
//  CalculatorViewController.swift
//  Seeda
//
//  Created by Mobile Expert on 9/28/16.
//  Copyright © 2016 Илья Железников. All rights reserved.
//

import UIKit
import DropDown

class CalculatorViewController: UIViewController {
    
    var points = [Point]()
    let defaults = NSUserDefaults.standardUserDefaults()
    var f_index = 0
    var t_index = 0

    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var calculatorButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    
    let fromDropDown = DropDown()
    let toDropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fromButton.layer.cornerRadius = 5.0
        self.toButton.layer.cornerRadius = 5.0
        self.cancelButton.layer.cornerRadius = 5.0
        self.calculatorButton.layer.cornerRadius = 5.0
        self.fromButton.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.toButton.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.cancelButton.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.calculatorButton.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.view.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.calculatorButton.layer.borderWidth = 1.0
        self.cancelButton.layer.borderWidth = 1.0
        self.fromButton.layer.borderWidth = 1.0
        self.toButton.layer.borderWidth = 1.0
        self.view.layer.borderWidth = 1.0
        self.resultTextField.layer.borderWidth = 1.0
        self.resultTextField.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        
        points = (defaults.arrayForKey("points") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
        self.setupDropDowns()
        self.resultTextField.enabled = false
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        let language = defaults.objectForKey("language") as! String
        if (language == "english") {
            fromLabel.text = "From"
            toLabel.text = "To"
            calculatorButton.setTitle("Calculate", forState: .Normal)
            cancelButton.setTitle("Cancel", forState: .Normal)
        } else {
            fromLabel.text = "من"
            toLabel.text = "إلي"
            calculatorButton.setTitle("احسب", forState: .Normal)
            cancelButton.setTitle("الغاء", forState: .Normal)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDropDowns(){
        var datas = [String]()
        for point in points {
            datas.append(point.name)
        }
        fromDropDown.anchorView = self.fromButton
        fromDropDown.bottomOffset = CGPoint(x: 0, y: self.fromButton.bounds.height)
        
//        fromDropDown.width = self.fromButton.frame.width + 20
        fromDropDown.dataSource = datas
        fromDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.f_index = index
            self.fromButton.setTitle(item, forState: .Normal)
        }

        toDropDown.anchorView = self.toButton
        toDropDown.bottomOffset = CGPoint(x: 0, y: self.toButton.bounds.height)
        
//        toDropDown.width = self.toButton.frame.width + 20
        toDropDown.dataSource = datas
        toDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.t_index = index
            self.toButton.setTitle(item, forState: .Normal)
        }
    }
    
    func getDistance(lat1 : Double, lon1 : Double, lat2 : Double, lon2 : Double) -> Double {
        let p = 0.017453292519943295    // Math.PI / 180
        let sub1 = cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p))/2
        let a = 0.5 - cos((lat2 - lat1) * p)/2 + sub1
        
        return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
    }
    
    @IBAction func fromBtnClick(sender: AnyObject) {
        fromDropDown.show()
    }

    @IBAction func toBtnClick(sender: AnyObject) {
        toDropDown.show()
    }

    @IBAction func calculatorBtnClick(sender: AnyObject) {
        let distance = self.getDistance(Double(points[f_index].latitude)!, lon1: Double(points[f_index].longitude)!, lat2: Double(points[t_index].latitude)!, lon2: Double(points[t_index].longitude)!)
        let Dis_String:String = String(format:"%.3f", distance)
        self.resultTextField.text = Dis_String + "KM"
    }

    @IBAction func cancelBtnClick(sender: AnyObject) {
        self.view.endEditing(true)
        self.view.hidden = true
    }
}
