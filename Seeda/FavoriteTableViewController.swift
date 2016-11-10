//
//  FavoriteTableViewController.swift
//  UPWorkApp
//
//  Created by Илья Железников on 28/04/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import UIKit
import SimpleAlert

class FavoriteTableViewController: UITableViewController, FavoriteCellDelegate {
    var points = [Point]()
    @IBOutlet var favoriteTable: UITableView!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        points = (defaults.arrayForKey("points") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.blueColor().CGColor, UIColor.redColor().CGColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

//        self.view.layer.insertSublayer(gradient, atIndex: 0)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return points.count
    }
    
    func editButtonPressed(cell: FavoriteCell) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let language = defaults.objectForKey("language") as! String
        
        var title1 = "Rename Location"
        var placeholder1 = "Enter the location name"
        var title2 = "OK"
        var title3 = "Cancel"
        
        if  (language != "english") {
            title1 = "إعادة تسمية الموقع"
            placeholder1 = "ادخل اسم الموقع"
            title2 = "حسنا"
            title3 = "إلغاء"
        }
        
        
        let alert = SimpleAlert.Controller(title: title1, message: nil, style: .Alert)
        alert.addTextFieldWithConfigurationHandler() { textField in
            textField.frame.size.height = 33
            textField.backgroundColor = nil
            textField.layer.borderColor = UIColor.whiteColor().CGColor
            textField.layer.borderWidth = 1
            textField.placeholder = placeholder1
        }
        
        alert.configContentView = { [weak self] view in
            if let view = view as? SimpleAlert.ContentView {
                view.titleLabel.font = UIFont.init(name: "Helvetica-Neue Light", size: 17)
            }
        }
        alert.addAction(SimpleAlert.Action(title: title2, style: .OK){
            _ in
            
            var favoritePoints = (self.defaults.arrayForKey("points") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
            let lat = favoritePoints[cell.row].latitude
            let long = favoritePoints[cell.row].longitude
            let name = alert.textFields[0].text
            
            cell.title.text = name
            
            favoritePoints.removeAtIndex(cell.row)
            favoritePoints.insert(Point(latitude: lat, longitude: long, name: name!), atIndex: cell.row)
            let fDataPoints = favoritePoints.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
            self.defaults.setObject(fDataPoints, forKey: "points")
            
            self.points = favoritePoints
            self.favoriteTable.reloadData()
            
            })
        alert.addAction(SimpleAlert.Action(title: title3, style: .Cancel))
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func deleteButtonPressed(cell: FavoriteCell) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let language = defaults.objectForKey("language") as! String
        
        var title1 = "Delete Location"
        var title2 = "OK"
        var title3 = "Cancel"
        var alertString = "Are you sure you want to delete this location?"
        
        if  (language != "english") {
            title1 = "حذف موقع"
            title2 = "حسنا"
            title3 = "إلغاء"
            alertString = "هل أنت متأكد أنك تريد حذف هذا الموقع؟"
        }
        
        let alert = SimpleAlert.Controller(title: title1, message: alertString, style: .Alert)
        
        alert.configContentView = { [weak self] view in
            if let view = view as? SimpleAlert.ContentView {
                view.titleLabel.font = UIFont.init(name: "Helvetica-Neue Light", size: 17)
            }
        }
        alert.addAction(SimpleAlert.Action(title: title2, style: .OK){
            _ in
            
            var favoritePoints = (self.defaults.arrayForKey("points") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
            favoritePoints.removeAtIndex(cell.row)
            let fDataPoints = favoritePoints.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
            self.defaults.setObject(fDataPoints, forKey: "points")
            self.points = favoritePoints
            self.favoriteTable.reloadData()
            
            })
        alert.addAction(SimpleAlert.Action(title: title3, style: .Cancel))
        presentViewController(alert, animated: true, completion: nil)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteCell", forIndexPath: indexPath) as! FavoriteCell

        cell.title.text     = points[indexPath.row].name
        let ddLatValue:Double? = Double(points[indexPath.row].latitude)
        let ddLongValue:Double? = Double(points[indexPath.row].longitude)
        
        var dmsData:[[Int]] = convertDDtoDMS(ddLatValue!, ddLong: ddLongValue!)
        
        cell.detail.text    = "N: " + String(format: "%.4f", Float(points[indexPath.row].latitude)!)  + " E: " + String(format: "%.4f", Float(points[indexPath.row].longitude)!) + "\n" + String(format: "N: %d.%d.%d E: %d.%d.%d", dmsData[0][0],dmsData[0][1],dmsData[0][2],dmsData[1][0],dmsData[1][1],dmsData[1][2])
        cell.row = indexPath.row
        cell.cellDelegate = self
        
        return cell
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


    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            points.removeAtIndex(indexPath.row)
            let defaults = NSUserDefaults.standardUserDefaults()
            let dataPoints = points.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
            defaults.setObject(dataPoints, forKey: "points")
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let point = points[indexPath.row]
        ViewController.startLat = point.latitude
        ViewController.startLong = point.longitude
        ViewController.startName = point.name
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var lastPoint = (defaults.arrayForKey("lastPoint") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
        lastPoint.removeAll()
        lastPoint.append(Point(latitude: point.latitude, longitude: point.longitude, name: "lastPoint"))
        let lastPoint_Archiver = lastPoint.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
        defaults.setObject(lastPoint_Archiver, forKey: "lastPoint")
        
        self.navigationController?.popViewControllerAnimated(true)
    }

}
