//
//  ShareViewController.swift
//  Seeda
//
//  Created by Golden.Eagle on 6/22/16.
//  Copyright © 2016 Илья Железников. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var shareTableView: UITableView!
    
    var firstSectionTitle = "Current location"
    var secondSectionTitle = "Favorite location"
    var favoritePoints = [Point]()
    var arrSelectedCells:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrSelectedCells = NSMutableArray()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
//        shareTableView.rowHeight = UITableViewAutomaticDimension
//        shareTableView.estimatedRowHeight = 150
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let language = defaults.objectForKey("language") as! String
        if (language == "english") {
            firstSectionTitle = "Current location"
            secondSectionTitle = "Favorite location"
            sendButton.setTitle("Send", forState: .Normal)
            cancelButton.setTitle("Cancel", forState: .Normal)
        } else {
            firstSectionTitle = "الموقع الحالي"
            secondSectionTitle = "المفضلة"
            sendButton.setTitle("ارسال", forState: .Normal)
            cancelButton.setTitle("الغاء", forState: .Normal)
        }
        self.sendButton.layer.cornerRadius = 5.0
        self.sendButton.layer.borderWidth = 1.0
        self.sendButton.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        self.cancelButton.layer.cornerRadius = 5.0
        self.cancelButton.layer.borderWidth = 1.0
        self.cancelButton.layer.borderColor = UIColor(red: 31/255, green: 78/255, blue: 121/255, alpha: 1.0).CGColor
        favoritePoints = (defaults.arrayForKey("points") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
        
        shareTableView.reloadData()
    }
    
    
    
    @IBAction func sendPressed(sender: AnyObject) {
        
        var activityItems = [AnyObject]()
        var favoriteStringFlag = 0
                
        for (var i = 0; i < arrSelectedCells.count; i += 1) {
            if (arrSelectedCells[i].section == 0) {
                if let lat = ViewController.location?.latitude, long = ViewController.location?.longitude {
                    let textToShare = "Current location: http://seedalocationservice.com/?lat=\(lat)&long=\(long)"
                    activityItems.append(textToShare)
                }
            } else {
                if (favoriteStringFlag == 0) {
                    let tempString = " Favorite location: http://seedalocationservice.com/name=" + favoritePoints[arrSelectedCells[i].row].name + "&lat=" + favoritePoints[arrSelectedCells[i].row].latitude + "&long=" + favoritePoints[arrSelectedCells[i].row].longitude;
                    
                    activityItems.append(tempString)
                        
                    favoriteStringFlag = 1
                } else {
                    let favoriteLocationString = "http://seedalocationservice.com/?name=" + favoritePoints[arrSelectedCells[i].row].name + "&lat=" + favoritePoints[arrSelectedCells[i].row].latitude + "&long=" + favoritePoints[arrSelectedCells[i].row].longitude
                    activityItems.append(favoriteLocationString)
                }
            }
            
        }
        
        arrSelectedCells.removeAllObjects()
        let downloadHelpString = "If you dont have an app, download it here"
        let appstorelinkToApp = "https://itunes.apple.com/us/app/seeda/id1115824172?ls=1&mt=8"
        let playstorelinkToApp = "https://play.google.com/store/apps/details?id=com.seeda.fahad"
        
        activityItems.append(downloadHelpString)
        activityItems.append(appstorelinkToApp)
        activityItems.append(playstorelinkToApp)
        

        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = []
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return firstSectionTitle
        } else {
            return secondSectionTitle
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowCount = 0
        if (section == 0) {
            rowCount = 1
        } else {
            rowCount = favoritePoints.count
        }
        return rowCount
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

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("shareTableViewCell") as! ShareTableViewCell
        if arrSelectedCells.containsObject(indexPath) {
            cell.checkImg.image = UIImage(named: "check_on.png")
        } else {
            cell.checkImg.image = UIImage(named: "check_off.png")
//            cell!.accessoryType = .None
        }
        
        if (indexPath.section == 0) {
            if let lat = ViewController.location?.latitude, long = ViewController.location?.longitude{
                
                let ddLatValue:Double? = Double(lat)
                let ddLongValue:Double? = Double(long)
                
                var dmsData:[[Int]] = convertDDtoDMS(ddLatValue!, ddLong: ddLongValue!)
                
                let locationString = "N: " + String(format: "%.4f", ddLatValue!)  + " E: " + String(format: "%.4f", ddLongValue!) + "\n" + String(format: "N: %d.%d.%d E: %d.%d.%d", dmsData[0][0],dmsData[0][1],dmsData[0][2],dmsData[1][0],dmsData[1][1],dmsData[1][2])

                
                cell.titleLabel.text = ""
                cell.detailsLabel.text = locationString
            }
            
        } else {
            
            let ddLatValue:Double? = Double(favoritePoints[indexPath.row].latitude)
            let ddLongValue:Double? = Double(favoritePoints[indexPath.row].longitude)
            
            var dmsData:[[Int]] = convertDDtoDMS(ddLatValue!, ddLong: ddLongValue!)
            
            let favoriteLocationString = "N: " + String(format: "%.4f", Float(favoritePoints[indexPath.row].latitude)!)  + " E: " + String(format: "%.4f", Float(favoritePoints[indexPath.row].longitude)!) + "\n" + String(format: "N: %d.%d.%d E: %d.%d.%d", dmsData[0][0],dmsData[0][1],dmsData[0][2],dmsData[1][0],dmsData[1][1],dmsData[1][2])

            cell.titleLabel.text = favoritePoints[indexPath.row].name
            cell.detailsLabel.text = favoriteLocationString
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (arrSelectedCells.containsObject(indexPath)) {
            arrSelectedCells.removeObject(indexPath)
        } else {
            arrSelectedCells.addObject(indexPath)
        }
        
        tableView.reloadData()
    }

}
