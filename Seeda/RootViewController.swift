//
//  RootViewController.swift
//  UPWorkApp
//
//  Created by Роман Макаров on 25.04.16.
//  Copyright © 2016 Roman. All rights reserved.
//

import UIKit
import RESideMenu

class RootViewController: RESideMenu {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parallaxEnabled = false
        self.bouncesHorizontally = false
        self.scaleContentView = false
        self.scaleMenuView = false
        self.contentViewInPortraitOffsetCenterX = 0
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        self.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewController")
        self.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("sideMenuViewController")
        let contentVC = self.contentViewController as! UINavigationController
        (contentVC.viewControllers.first as! ViewController).root = self
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
