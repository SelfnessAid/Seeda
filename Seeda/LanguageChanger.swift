//
//  LanguageChanger.swift
//  UPWorkApp
//
//  Created by Илья Железников on 17/05/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import UIKit

class LanguageChanger: NSObject {
    
    static var labelStrings = [UILabel : (String, String)]()
    static var buttonStrings = [UIButton : (String, String)]()
    
    class func changeLabelLanguage() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let language = defaults.objectForKey("language") as! String
        if (language == "english"){
            LanguageChanger.labelStrings.map{$0.0.text = $0.1.0}
        }else{
            LanguageChanger.labelStrings.map{$0.0.text = $0.1.1}
        }
    }
    
    class func changeButtonLanguage() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let language = defaults.objectForKey("language") as! String
        if (language == "english"){
            LanguageChanger.buttonStrings.map{$0.0.setTitle($0.1.0, forState: .Normal)}
        }else{
            LanguageChanger.buttonStrings.map{$0.0.setTitle($0.1.1, forState: .Normal)}
        }
    }

}
