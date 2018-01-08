//
//  generalViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 13.12.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

public class GeneralViewController: UIViewController, UITextFieldDelegate {
    public var mainPage:MainPageViewController!
    public let navItem = UINavigationItem(title: "SomeTitle");
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        navBar.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
        navBar.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        navBar.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        navBar.backgroundColor = nil
        self.view.addSubview(navBar);
        navBar.setItems([navItem], animated: false);
        navItem.title = "Hallo"
        self.view.addSubview(navBar)
        refresh()
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.yellow
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {    //delegate method
        textField.backgroundColor = nil
    }
    public func refresh () {
        
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}
