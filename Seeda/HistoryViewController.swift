//
//  HistoryViewController.swift
//  Seeda
//
//  Created by Mobile Expert on 10/6/16.
//  Copyright © 2016 Илья Железников. All rights reserved.
//

import UIKit

protocol HistoryViewControllerDelegate {
    func didSelectHistory(sender: HistoryViewController)
}

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HistoryTableViewCellDelegate {

    @IBOutlet weak var historyTableView: UITableView!
//    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var originalView: UIView!
//    @IBOutlet weak var okBtn: UIButton!
//    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var delegate:HistoryViewControllerDelegate! = nil
    var checkMarkMode = false;
    var button_mode = 0; //1: delete clicked, 2: favorite clicked
    var points = [Point]()
    let defaults = NSUserDefaults.standardUserDefaults()
    var arrSelectedCells:NSMutableArray!
    var checked:[Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
//        self.reloadHistoryPoints()
//        arrSelectedCells = NSMutableArray()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        let language = defaults.objectForKey("language") as! String
        if (language == "english") {
            deleteBtn.setTitle("Delete", forState: .Normal)
            favoriteBtn.setTitle("Move to favorites", forState: .Normal)
        } else {
            deleteBtn.setTitle("مسح", forState: .Normal)
            favoriteBtn.setTitle("نقل الى المفضلة", forState: .Normal)
        }
//        self.confirmView.hidden = true
        self.deleteBtn.layer.borderWidth = 1.0
        self.deleteBtn.layer.cornerRadius = 5.0
        self.deleteBtn.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        
        self.favoriteBtn.layer.borderWidth = 1.0
        self.favoriteBtn.layer.cornerRadius = 5.0
        self.favoriteBtn.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.favoriteBtn.titleLabel?.numberOfLines = 2
        self.favoriteBtn.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        self.reloadHistoryPoints()
        arrSelectedCells = NSMutableArray()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
//    func showConfirmArea() {
//        self.confirmView.hidden = false
//        self.originalView.hidden = true
//        UIView .animateWithDuration(0.5, animations: {
//            self.confirmView.frame.origin.x = 0
//            }, completion: { (finished) in
//        })
//    }
//    
//    func hideConfirmArea() {
//        self.confirmView.hidden = true
//        self.originalView.hidden = false
//        UIView .animateWithDuration(0.5, animations: {
//            self.confirmView.frame.origin.x = 2000
//            }, completion: { (finished) in
//        })
//    }
    
    func reloadHistoryPoints() {
        points = (defaults.arrayForKey("history") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
        checked = Array<Bool>(count: points.count, repeatedValue: false)
    }
    
    @IBAction func deleteBtnPressed(sender: AnyObject) {
//        button_mode = 1
//        self.showConfirmArea()
        var temp = [Point]()
        for (var i = 0; i < points.count; i += 1) {
            if (checked[i] == false ) {
                temp.append(points[i])
            }
        }
        let DataPoints = temp.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
        defaults.setObject(DataPoints, forKey: "history")
        reloadHistoryPoints()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.historyTableView.reloadData()
        })
    }

    @IBAction func favoriteBtnPressed(sender: AnyObject) {
//        button_mode = 2
////        self.showConfirmArea()
//        checkMarkMode = true
        var tmpPointList = [Int]()
//        checkMarkMode = false
        
        for (var i = 0; i < points.count; i += 1) {
            if (checked[i] == true) {
                
                //favorite Points
                var favoritePoints = (defaults.arrayForKey("points") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
                favoritePoints.append(Point(latitude: points[i].latitude, longitude: points[i].longitude, name: points[i].name))
                let fDataPoints = favoritePoints.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
                defaults.setObject(fDataPoints, forKey: "points")
                
                tmpPointList.append(i)
                
            }
            //                cell.check_img.image = UIImage(named: "check_off.png")
        }
        
        var historyPoints = (defaults.arrayForKey("history") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
        
        for (var i = tmpPointList.count - 1; i >= 0; i -= 1) {
            //remove historyPoint
            historyPoints.removeAtIndex(tmpPointList[i])
        }
        
        let hDataPoints = historyPoints.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
        defaults.setObject(hDataPoints, forKey: "history")
        reloadHistoryPoints()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.historyTableView.reloadData()
        })
    }
    
//    @IBAction func okBtnPressed(sender: AnyObject) {
//        if (button_mode == 1) {
//            defaults.setObject([Point](), forKey: "history")
//            defaults.synchronize()
//            points = [Point]()
//        } else {
//            
//            var tmpPointList = [Int]()
//            checkMarkMode = false
//            
//            for (var i = 0; i < points.count; i += 1) {
//                if (checked[i] == true) {
//                    
//                    //favorite Points
//                    var favoritePoints = (defaults.arrayForKey("points") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
//                    favoritePoints.append(Point(latitude: points[i].latitude, longitude: points[i].longitude, name: points[i].name))
//                    let fDataPoints = favoritePoints.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
//                    defaults.setObject(fDataPoints, forKey: "points")
//                    
//                    tmpPointList.append(i)
//                    
//                }
////                cell.check_img.image = UIImage(named: "check_off.png")
//            }
//            
//            var historyPoints = (defaults.arrayForKey("history") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
//            
//            for (var i = tmpPointList.count - 1; i >= 0; i -= 1) {
//                //remove historyPoint
//                historyPoints.removeAtIndex(tmpPointList[i])
//            }
//            
//            let hDataPoints = historyPoints.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
//            defaults.setObject(hDataPoints, forKey: "history")
//        }
//        
////        button_mode = 0
//        reloadHistoryPoints()
////        self.hideConfirmArea()
//        
//        self.arrSelectedCells.removeAllObjects()
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.historyTableView.reloadData()
//        })
//    }
    
//    @IBAction func cancelBtnPressed(sender: AnyObject) {
//        if (button_mode == 1) {
//            
//        } else {
//            checkMarkMode = false
//            for (var i = 0; i < points.count; i += 1) {
//                let cell = self.historyTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! HistoryTableViewCell
////                cell.check_img.image = UIImage(named: "check_off.png")
//            }
//        }
//        
//        button_mode = 0
//        self.hideConfirmArea()
//        arrSelectedCells = NSMutableArray()
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.historyTableView.reloadData()
//        })
//    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return points.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! HistoryTableViewCell
        cell.titleLabel?.text = points[indexPath.row].name
        
        let ddLatValue:Double? = Double(points[indexPath.row].latitude)
        let ddLongValue:Double? = Double(points[indexPath.row].longitude)
        
        var dmsData:[[Int]] = convertDDtoDMS(ddLatValue!, ddLong: ddLongValue!)
        
        cell.detailsLabel?.text    = "N: " + String(format: "%.4f", Float(points[indexPath.row].latitude)!)  + " E: " + String(format: "%.4f", Float(points[indexPath.row].longitude)!) + "\n" + String(format: "N: %d.%d.%d E: %d.%d.%d", dmsData[0][0],dmsData[0][1],dmsData[0][2],dmsData[1][0],dmsData[1][1],dmsData[1][2])
        
//        if arrSelectedCells.containsObject(indexPath) {
//            cell.check_img.image = UIImage(named: "check_on.png")
//        }else {
//            cell.check_img.image = UIImage(named: "check_off.png")
////            cell.accessoryType = .None
//        }
        
        cell.check_button.selected = checked[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            points.removeAtIndex(indexPath.row)
            let defaults = NSUserDefaults.standardUserDefaults()
            let dataPoints = points.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
            defaults.setObject(dataPoints, forKey: "history")
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            checked.removeAtIndex(indexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if (button_mode == 1) {
//            
//        } else if (button_mode == 2) {
//            
//            tableView.deselectRowAtIndexPath(indexPath, animated: true)
//            
//            if arrSelectedCells.containsObject(indexPath) {
//                
//                arrSelectedCells.removeObject(indexPath)
//            }else {
//                
//                arrSelectedCells.addObject(indexPath)
//            }
//            
//            tableView.reloadData()
//        } else {
            let point = points[indexPath.row]
            ViewController.startLat = point.latitude
            ViewController.startLong = point.longitude
            ViewController.startName = point.name
            delegate!.didSelectHistory(self)
            let defaults = NSUserDefaults.standardUserDefaults()
            var lastPoint = (defaults.arrayForKey("lastPoint") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
            lastPoint.removeAll()
            lastPoint.append(Point(latitude: point.latitude, longitude: point.longitude, name: "lastPoint"))
            let lastPoint_Archiver = lastPoint.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
            defaults.setObject(lastPoint_Archiver, forKey: "lastPoint")
            
            self.navigationController?.popViewControllerAnimated(true)
//        }
    }
    
    // MARK: - HistoryTableViewCell delegate

    func historyCellPressCheck(sender: AnyObject, indexPath: NSIndexPath) {
        if let button = sender as? UIButton {
            checked[indexPath.row] = button.selected
        }
    }

}
