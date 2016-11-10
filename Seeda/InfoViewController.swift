//
//  InfoViewController.swift
//  Seeda
//
//  Created by Golden.Eagle on 6/22/16.
//  Copyright © 2016 Илья Железников. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var contact_label: UILabel!
    @IBOutlet weak var contactEmail_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(InfoViewController.contactPressed(_:)))
        contactEmail_label.userInteractionEnabled = true
        contactEmail_label.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let language = defaults.objectForKey("language") as! String
        //process language settings
        if (language == "english") {
            contact_label.text = "For inquiry or suggestion please"
        } else {
            contact_label.text = "للاستفسار أو اقتراح من فضلك"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func contactPressed(sender : UITapGestureRecognizer) {
        UIApplication.sharedApplication().openURL(NSURL(string: "mailto:seeda2016@outlook.com")!)
    }

}
