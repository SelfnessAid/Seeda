//
//  ViewController.swift
//  UPWorkApp
//
//  Created by Роман Макаров on 13.04.16.
//  Copyright © 2016 Roman. All rights reserved.
//

import UIKit
import Mapbox
import SimpleAlert
import CoreLocation
import MapboxDirections
import ZAlertView
import SwiftyStoreKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var longLatView: UIView!
    @IBOutlet weak var compassView: UIImageView!
    @IBOutlet weak var compass_indicatorView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var currentButton: UIButton!
    @IBOutlet weak var DistanceWord: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var LatitudeWord: UILabel!
    @IBOutlet weak var LongitudeWord: UILabel!
    
    @IBOutlet weak var distanceViewHeight: NSLayoutConstraint!
    
    
    let trackingMode: MGLUserTrackingMode = MGLUserTrackingMode.FollowWithCourse
    var currentButtonState: Bool = false
    var annotationImage: MGLAnnotationImage?
    var destenationAnnotation: MGLAnnotation?
    var distance: Double = 0
    var oldDistance: Double = 100
    var shouldDrawLine = false
    var line = MGLPolyline()
    var linePoints = [CLLocationCoordinate2D]()
    var destination = CLLocationCoordinate2D()
    var isCancelButton = false
//    var favoriteLines = [MGLPolyline]()
    var favoriteAnnotations = [MGLPointAnnotation]()
    var lastAnnotations = [MGLPointAnnotation]()
    var lastAnnotation = MGLPointAnnotation()
    static var location: CLLocationCoordinate2D?
    static var point: Point?
    var animating = false
    var locationManager:CLLocationManager!
    static var startLat:String?
    static var startLong:String?
    static var startName:String?
    static var fromLink:Bool = false
    var dialog:ZAlertView!
    var pinCount : Int = 0
    
    let MapboxAccessToken = "pk.eyJ1Ijoicm83MjEiLCJhIjoiY2lteXoxc29iMDBrMXZubHlzaXBia29hdSJ9.9-9HaU-Fpwwvwsor-wR9Tw"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.compassView.frame.offsetInPlace(dx: 0, dy: 1000)
        longLatView.hidden = true
        longLatView.layer.cornerRadius = 5.0
        longLatView.layer.shadowRadius = 1.0
        distanceView.hidden = true
        distanceViewHeight.constant = 0
        pinCount = 0

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        locationManager = CLLocationManager()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addPathFromSomeWhere), name: UIApplicationDidBecomeActiveNotification, object: nil)
        deleteButton.hidden = true
        deleteButton.alpha = 0
        dispatch_async(dispatch_get_main_queue(), {
            self.locationManager.delegate = self
            self.locationManager.startUpdatingHeading()
        })
        
        let myGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.testLongGesture))
        myGesture.minimumPressDuration = 0.8
        mapView.addGestureRecognizer(myGesture)
    }
    
    func polygonCircleForCoordinate(coordinate: CLLocationCoordinate2D, withMeterRadius: Double) {
        let degreesBetweenPoints = 8.0
        //45 sides
        let numberOfPoints = floor(360.0 / degreesBetweenPoints)
        let distRadians: Double = withMeterRadius / 6371000.0
        // earth radius in meters
        let centerLatRadians: Double = coordinate.latitude * M_PI / 180
        let centerLonRadians: Double = coordinate.longitude * M_PI / 180
        var coordinates = [CLLocationCoordinate2D]()
        //array to hold all the points
        for index in 0 ..< Int(numberOfPoints) {
            let degrees: Double = Double(index) * Double(degreesBetweenPoints)
            let degreeRadians: Double = degrees * M_PI / 180
            let pointLatRadians: Double = asin(sin(centerLatRadians) * cos(distRadians) + cos(centerLatRadians) * sin(distRadians) * cos(degreeRadians))
            let pointLonRadians: Double = centerLonRadians + atan2(sin(degreeRadians) * sin(distRadians) * cos(centerLatRadians), cos(distRadians) - sin(centerLatRadians) * sin(pointLatRadians))
            let pointLat: Double = pointLatRadians * 180 / M_PI
            let pointLon: Double = pointLonRadians * 180 / M_PI
            let point: CLLocationCoordinate2D = CLLocationCoordinate2DMake(pointLat, pointLon)
            coordinates.append(point)
        }
        let polygon = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
        if (NSUserDefaults.standardUserDefaults().valueForKey("isTracking") as! Bool == true) {
            addLastAnnotattion(String(coordinate.latitude), long: String(coordinate.longitude))
        }
        self.mapView.addAnnotation(polygon)
    }
    
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

    func addLastAnnotattion(lat : String, long : String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let point = Point(latitude: lat, longitude: long, name: "")
        
        
        if(defaults.arrayForKey("lastpoints") == nil){
            let points = [point]
            let dataPoints = points.map{NSKeyedArchiver.archivedDataWithRootObject($0)}
            defaults.setObject(dataPoints, forKey: "lastpoints")
        }else{
            var points = (defaults.arrayForKey("lastpoints") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
            points.append(point)
            let dataPoints = points.map{NSKeyedArchiver.archivedDataWithRootObject($0)}
            defaults.setObject(dataPoints, forKey: "lastpoints")
        }
    }
    
    func saveLocation(defaults : NSUserDefaults, title3 : String, message1 : String, title4 : String, title5 : String, lat : String, long : String) {
        
        let textField = dialog.getTextFieldWithIdentifier("name")
        if let name = textField!.text {
            let point = Point(latitude: lat, longitude: long, name: name)
            
            
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
        self.showAllFavoriteLocation()
        
    }
    
    func saveLocation(lat: String, long: String) {
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
            self.saveLocation(defaults, title3: title3, message1: message1, title4: title4, title5: title5, lat: lat, long: long)
            alertView.dismiss()
            }, cancelButtonHandler: { alertView in
                alertView.dismiss()
            }
        )
        dialog.addTextField("name", placeHolder: placeholder1)
        dialog.alertView.layer.cornerRadius = 20.0
        dialog.show()
    }
    
    func testLongGesture(long: UILongPressGestureRecognizer){
        if long.state == .Began{
            let longPressPoint : CGPoint = long.locationInView(mapView)
            let longPressCoordinate = mapView.convertPoint(longPressPoint, toCoordinateFromView:mapView)
            print("N : \(longPressCoordinate.latitude) E: \(longPressCoordinate.longitude)")
            self.saveLocation(String(longPressCoordinate.latitude), long: String(longPressCoordinate.longitude))
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshMap(_:)), name: "kNotificationRefreshMap", object: nil)
        
        self.mapView.setUserTrackingMode(trackingMode, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        LanguageChanger.labelStrings[DistanceWord] = ("Distance","المسافة")
        LanguageChanger.labelStrings[arrivalTimeLabel] = ("Arrival Time", "وقت الوصول")
        LanguageChanger.labelStrings[LongitudeWord] = ("N", "N")
        LanguageChanger.labelStrings[LatitudeWord] = ("E", "E")
        LanguageChanger.changeLabelLanguage()
        self.navigationController?.navigationController?.setNavigationBarHidden(true, animated: false)
        addPathFromSomeWhere()
        
    }

    @IBAction func deleteButtonPressed(sender: AnyObject) {
        mapView.removeOverlay(line)
        mapView.removeAnnotation(destenationAnnotation!)
        shouldDrawLine = false
        UIView.animateWithDuration(0.3,animations: {
            self.distanceView.alpha = 0
            self.deleteButton.alpha = 0
        }, completion: {
            completed in
            UIView.animateWithDuration(0.1){
                self.distanceView.hidden = true
                self.distanceViewHeight.constant = 0
                self.deleteButton.hidden = true
            }
        })
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
//        print(heading.magneticHeading)
        let degrees: Double = -heading.magneticHeading
        compass_indicatorView.transform =  CGAffineTransformMakeRotation(CGFloat(degrees*M_PI/180))
    }
    
    //MARK:- Notifications
    
    func refreshMap(notification:NSNotification) {
        
        if (notification.userInfo!["safl"] != nil) {
            let safl = notification.userInfo!["safl"] as! Bool
            if (safl == true) {
                showAllFavoriteLocation()
            } else {
                hideAllFavoriteLocation()
            }
        }
        
        if (notification.userInfo!["isTracking"] != nil) {
            let usr = notification.userInfo!["isTracking"] as! Bool
            if (usr == false) {
                removeAllAnnotation()
            } else {
                NSUserDefaults.standardUserDefaults().setValue(false, forKey: "showLastTracking")
                let point = Point(latitude: String(ViewController.location!.latitude), longitude: String(ViewController.location!.longitude), name: "")
                let points = [point]
                let dataPoints = points.map{NSKeyedArchiver.archivedDataWithRootObject($0)}
                NSUserDefaults.standardUserDefaults().setObject(dataPoints, forKey: "lastpoints")
                removeAllAnnotation()
            }
        }
        
        if (notification.userInfo!["showLastTracking"] != nil) {
            let showLastTracking = notification.userInfo!["showLastTracking"] as! Bool
            if (showLastTracking == true) {
                if (NSUserDefaults.standardUserDefaults().valueForKey("isTracking") != nil && NSUserDefaults.standardUserDefaults().valueForKey("isTracking") as! Bool == false) {
                    self.showLastTrackingOnMap()
                }
            }
        }
    }
    
    func showLastTrackingOnMap() {
        var isTracking = true
        if (NSUserDefaults.standardUserDefaults().valueForKey("isTracking") != nil) {
            isTracking = NSUserDefaults.standardUserDefaults().valueForKey("isTracking") as! Bool
        }
        if (isTracking == false) {
            self.removeAllAnnotation()
            let defaults = NSUserDefaults.standardUserDefaults()
            var lastPoints = (defaults.arrayForKey("lastpoints") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
            
            _ = mapView.userLocation!.coordinate
            
            if (lastAnnotations.count > 0) {
                mapView.removeAnnotations(lastAnnotations)
                lastAnnotations.removeAll()
            }
            
            for (var i = 0; i<lastPoints.count; i += 1) {
                let lastPoint = lastPoints[i]
                
                
                var fLocation = CLLocationCoordinate2D()
                fLocation.latitude = Double(lastPoint.latitude)!
                fLocation.longitude = Double(lastPoint.longitude)!
                
                //            var linePoints = [userLocationForFavorite, fLocation]
                //            favoriteLines.append(MGLPolyline(coordinates: &linePoints, count: 2))
                //            mapView.addOverlay(favoriteLines[i])
                
                let lastAnnotation = MGLPointAnnotation()
                lastAnnotation.coordinate = fLocation
//                lastAnnotation.title = favoritePoint.name
                lastAnnotations.append(lastAnnotation)
                self.polygonCircleForCoordinate(fLocation, withMeterRadius: 10)
//                mapView.addAnnotation(lastAnnotation)
                
            }
        }
    }
    
    func addPathFromSomeWhere(){
        if let startLat = ViewController.startLat, startLong = ViewController.startLong{
            addDestenationPoint(withLatitude: startLat, longitude: startLong, name: "", withCallback: {})
            ViewController.startLat = nil
            ViewController.startLong = nil
            ViewController.startName = nil
            if sideMenuController()!.sidePanelVisible{
                sideMenuController()?.toggleSidePanel()
            }
        }
    }
    
    @IBAction func currentLocationButtonPressed(sender: AnyObject) {
        defer{
            self.mapView.setUserTrackingMode(trackingMode, animated: true)
        }
        self.currentButtonState = true
        if let image = UIImage(named: "MyLocation_Red.png") {
            self.currentButton.setImage(image, forState: .Normal)
        }
        let camera = MGLMapCamera(lookingAtCenterCoordinate: CLLocationCoordinate2D(latitude: Double(self.latitudeLabel.text!)!, longitude: Double(self.longitudeLabel.text!)!), fromDistance: 9000, pitch: 0, heading: 0)
        
        mapView.setCamera(camera, withDuration: 3, animationTimingFunction: nil)
        if self.animating{
            return
        }
        longLatView.hidden = true
        longLatView.alpha = 0
        let delay = 10 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        self.animating = true
        UIView.animateWithDuration(1, animations: {
            self.longLatView.alpha = 1
            }, completion: {
                _ in
                dispatch_after(time, dispatch_get_main_queue()) {
                    UIView.animateWithDuration(1, animations: {
                        self.longLatView.alpha = 0
                        }, completion:{
                            _ in
                            self.longLatView.hidden = true
                            self.animating = false
                    })
                }
        })
    }
    

    @IBAction func menuButtonPressed(sender: AnyObject) {
        if (self.childViewControllers.count > 0) {
            for VC in self.childViewControllers {
                VC.view.hidden = true
            }
            self.childViewControllers[0].view.hidden = true
        }
        self.sideMenuController()?.toggleSidePanel()
    }
    
    func addPointFromSideMenu(){
        
        let alert = self.storyboard?.instantiateViewControllerWithIdentifier("alertVC") as! AlertController
        self.addChildViewController(alert)
        alert.view.frame = CGRectMake(0, 0, 360, 250)
        alert.view.layer.cornerRadius = 20
        let alertCenter: CGPoint = CGPointMake(self.mapView.center.x, self.mapView.center.y)
        alert.view.center = alertCenter
        self.view.insertSubview(alert.view, aboveSubview: self.mapView)
        alert.didMoveToParentViewController(self)
    
    }
    
    func showCalculatorFromSideMenu() {
        let alert = self.storyboard?.instantiateViewControllerWithIdentifier("CalculatorVC") as! CalculatorViewController
        self.addChildViewController(alert)
        alert.view.frame = CGRectMake(0, 0, 360, 250)
        alert.view.layer.cornerRadius = 20
        let alertCenter: CGPoint = CGPointMake(self.mapView.center.x, self.mapView.center.y)
        alert.view.center = alertCenter
        self.view.insertSubview(alert.view, aboveSubview: self.mapView)
        alert.didMoveToParentViewController(self)
    }
    
    func showCoordinationFromSideMenu() {
        let alert = self.storyboard?.instantiateViewControllerWithIdentifier("coordinationVC") as! CoordinationViewController
        self.addChildViewController(alert)
        alert.view.frame = CGRectMake(0, 0, 360, 250)
        alert.view.layer.cornerRadius = 20
        let alertCenter: CGPoint = CGPointMake(self.mapView.center.x, self.mapView.center.y)
        alert.view.center = alertCenter
        self.view.insertSubview(alert.view, aboveSubview: self.mapView)
        alert.didMoveToParentViewController(self)
    }

    
    func addDestenationPoint(withLatitude lat:String, longitude long:String, name: String, withCallback callback: () -> Void){
        defer{
            self.mapView.setUserTrackingMode(trackingMode, animated: true)
        }
        UIView.animateWithDuration(0.3){
            self.deleteButton.hidden = false
            self.deleteButton.alpha = 1
        }
        ViewController.point = Point(latitude: lat, longitude: long, name: name)
        if let destenationAnnotation = destenationAnnotation{
            mapView.removeAnnotation(destenationAnnotation)
        }
        let latitude: Double? = Double(lat)
        let longitude: Double? = Double(long)
        let defaults = NSUserDefaults.standardUserDefaults()
        var tempPoints = (defaults.arrayForKey("history") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
        tempPoints.append(Point(latitude: lat, longitude: long, name: name))
        let dataPoints = tempPoints.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
        defaults.setObject(dataPoints, forKey: "history")
        
        isCancelButton = true
        destination.latitude = latitude!
        destination.longitude = longitude!
        shouldDrawLine = true
        
        UIView.animateWithDuration(0.3){
            self.distanceView.alpha = 0.85
            self.distanceView.hidden = false
            self.distanceViewHeight.constant = 65
        }
        
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
        point.title = "LastPoint"
        destenationAnnotation = point
        mapView.addAnnotation(point)
        drawPath()
        
        var lastPoint = (defaults.arrayForKey("lastPoint") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
        lastPoint.removeAll()
        lastPoint.append(Point(latitude: String(destination.latitude), longitude: String(destination.longitude), name: "lastPoint"))
        let lastPoint_Archiver = lastPoint.map{ NSKeyedArchiver.archivedDataWithRootObject($0)}
        defaults.setObject(lastPoint_Archiver, forKey: "lastPoint")
        
        callback()
        
    }
    
    func showAllFavoriteLocation() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let favoritePoints = (defaults.arrayForKey("points") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
        
        
        _ = mapView.userLocation!.coordinate
        
        if (favoriteAnnotations.count > 0) {
            mapView.removeAnnotations(favoriteAnnotations)
            favoriteAnnotations.removeAll()
        }
        
        for (var i = 0; i<favoritePoints.count; i += 1) {
            let favoritePoint = favoritePoints[i]
            
            
            var fLocation = CLLocationCoordinate2D()
            fLocation.latitude = Double(favoritePoint.latitude)!
            fLocation.longitude = Double(favoritePoint.longitude)!
            
//            var linePoints = [userLocationForFavorite, fLocation]
//            favoriteLines.append(MGLPolyline(coordinates: &linePoints, count: 2))
//            mapView.addOverlay(favoriteLines[i])
            
            let favoriteAnnotation = MGLPointAnnotation()
            favoriteAnnotation.coordinate = fLocation
            favoriteAnnotation.title = favoritePoint.name
            favoriteAnnotations.append(favoriteAnnotation)
            mapView.addAnnotation(favoriteAnnotation)

        }
    }
    
    func hideAllFavoriteLocation() {
//        mapView.removeOverlays(favoriteLines)
        
        for (var i = 0; i < favoriteAnnotations.count; i += 1) {
            mapView.removeAnnotation(favoriteAnnotations[i])
        }
        
    }
    
    func showLastPoint() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastPoint = (defaults.arrayForKey("lastPoint") as! [NSData]).map{NSKeyedUnarchiver.unarchiveObjectWithData($0) as! Point}
        
        if (lastPoint.count == 0) {
            return
        }
        var lastLocation = CLLocationCoordinate2D()
        lastLocation.latitude = Double(lastPoint[0].latitude)!
        lastLocation.longitude = Double(lastPoint[0].longitude)!
        
        lastAnnotation.coordinate = lastLocation
        lastAnnotation.title = "lastLocation"
        mapView.addAnnotation(lastAnnotation)
    }
    
    func hideLastPoint() {
        mapView.removeAnnotation(lastAnnotation)
    }
    
    func removeAllAnnotation() {
        let allAnnotations = self.mapView.annotations
        if allAnnotations != nil {
            self.mapView.removeAnnotations(allAnnotations!)
        }
    }

    func drawPath(){
        self.distanceLabel.text = ""
        self.timeLabel.text = ""
        let options = RouteOptions(waypoints: [
            Waypoint(coordinate: mapView.userLocation!.location!.coordinate, name: "User Location"),
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude), name: "Destination"),
            ])
        options.includesSteps = true

        Directions(accessToken: MapboxAccessToken).calculateDirections(options: options) { (waypoints, routes, error) in guard error == nil else {
            print("Error calculating directions: \(error!)")
            return
            }
            
            if let route = routes?.first, leg = route.legs.first {
                print("Route via \(leg):")

                let distanceFormatter = NSLengthFormatter()
                let formattedDistance = distanceFormatter.stringFromMeters(route.distance)
                
                let travelTimeFormatter = NSDateComponentsFormatter()
                travelTimeFormatter.unitsStyle = .Abbreviated
                let formattedTravelTime = travelTimeFormatter.stringFromTimeInterval(route.expectedTravelTime)
                self.timeLabel.text = formattedTravelTime
                
            }
        }
        
        distance = CLLocation(latitude: destination.latitude, longitude: destination.longitude).distanceFromLocation(mapView.userLocation!.location!)
        if(shouldDrawLine){
            
            mapView.removeOverlay(line)
            let userLoaction = mapView.userLocation!.coordinate
            
            linePoints = [userLoaction, destination]
            shouldDrawLine = true
            line = MGLPolyline(coordinates: &linePoints, count: 2)
            mapView.addOverlay(line)
        
    
            let defaults = NSUserDefaults.standardUserDefaults()
            let dist = ((defaults.objectForKey("distance")) as! String)
            if  dist == "km" {
                if (distance > 1000){
                    self.distanceLabel.text = String(format: "%.0f", distance/1000) + " km"
                } else {
                    self.distanceLabel.text = String(round(distance)) + " m"
                    mapView.delegate?.mapView!(mapView, imageForAnnotation: destenationAnnotation!)
                }
            }else if dist == "mi" {
                if (distance > 1000){
                    self.distanceLabel.text = String(format: "%.0f", distance/1609) + " mi"
                }else{
                    self.distanceLabel.text = String(round(distance)) + " m"
                    mapView.delegate?.mapView!(mapView, imageForAnnotation: destenationAnnotation!)
                }
            }
            oldDistance = distance
        }
    }
}


extension ViewController: MGLMapViewDelegate{
    
    func mapView(mapView: MGLMapView, didUpdateUserLocation userLocation: MGLUserLocation?){
        drawPath()
        if ViewController.location == nil{
            ViewController.location = CLLocationCoordinate2D()
        }
        ViewController.location?.latitude = (userLocation?.coordinate.latitude)!
        ViewController.location?.longitude = (userLocation?.coordinate.longitude)!
        
        self.longitudeLabel.text = String(format: "%.4f", (userLocation?.coordinate.longitude)!)
        self.latitudeLabel.text = String(format: "%.4f", (userLocation?.coordinate.latitude)!)
        print("E: \(self.latitudeLabel.text)   N: \(self.longitudeLabel.text)")
        //        showAllFavoriteLocation
        let defaults = NSUserDefaults.standardUserDefaults()
        let safl = defaults.objectForKey("SAFL") as! Bool
        var isTrack = false
        if (defaults.objectForKey("isTracking") != nil ) {
            isTrack = defaults.objectForKey("isTracking") as! Bool
        }
        if (isTrack) {
            if pinCount%5 == 0 {
                polygonCircleForCoordinate(ViewController.location!, withMeterRadius: 10)
            }
        }
        
        if(safl) {
            self.showAllFavoriteLocation()
        }
        pinCount = (pinCount + 1)%5
    }
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        //scale from 5 to 2
        let scale:CGFloat = distance > 2000 ? 5 : CGFloat(5 - 3*(Int(distance)/2000))
        if (annotation.title! != "LastPoint" && annotation.title! != "") {
            let image = UIImage(CGImage: UIImage(named: "favoritePoint.png")!.CGImage!, scale: scale, orientation: UIImageOrientation.Up)
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "favoritePoint")
        } else if (annotation.title! == "LastPoint") {
            let image = UIImage(CGImage: UIImage(named: "Point.png")!.CGImage!, scale: scale, orientation: UIImageOrientation.Up)
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "Point")
        }
        return annotationImage
    }

    func mapView(mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return 5.0
    }
    
    func mapView(mapView:MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapViewRegionIsChanging(mapView: MGLMapView) {
        let degrees: Double = 360 - mapView.direction
        compassView.transform =  CGAffineTransformMakeRotation(CGFloat(degrees*M_PI/180))
    }
    
    func mapView(mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return UIColor.redColor()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

