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
    public let navTopItem = UINavigationItem(title: "SomeTitle");
    public let navBottomItem = UINavigationItem(title: "");
    public let navTopBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    public let navBottomBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navTopItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconmonstr-arrow-64-32"), style: .done, target: self, action: #selector(GeneralViewController.butBack_Click(_:)))
        navTopBar.backgroundColor = nil
        self.view.addSubview(navTopBar);
        let margins = self.view.layoutMarginsGuide
        navTopBar.translatesAutoresizingMaskIntoConstraints = false
        navTopBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        navTopBar.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        navTopBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        navTopBar.setItems([navTopItem], animated: false);
        navTopItem.title = "Hallo"
        let butEditing = UIBarButtonItem(image: UIImage(named: "iconmonstr-pencil-9-32"), style: .done, target: self, action: #selector(GeneralViewController.butEditing_Click(_:)))
        navTopItem.rightBarButtonItems = [butEditing]
        
        navBottomBar.backgroundColor = nil
        self.view.addSubview(navBottomBar);
        navBottomBar.translatesAutoresizingMaskIntoConstraints = false
        navBottomBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        navBottomBar.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        navBottomBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        navBottomBar.setItems([navBottomItem], animated: false);
        let butStart = UIBarButtonItem(image: UIImage(named: "iconmonstr-power-on-off-8-32"), style: .done, target: self, action: #selector(GeneralViewController.butStart_Click(_:)))
        let butMain = UIBarButtonItem(image: UIImage(named: "iconmonstr-building-18-32"), style: .done, target: self, action: #selector(GeneralViewController.butMain_Click(_:)))
        let butRoomDescription = UIBarButtonItem(image: UIImage(named: "iconmonstr-text-28-32"), style: .done, target: self, action: #selector(GeneralViewController.butRoomDescription_Click(_:)))
        navBottomItem.leftBarButtonItems = [butStart, butMain]
        navBottomItem.rightBarButtonItems = [butRoomDescription]
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
    @IBAction func butBack_Click(_ sender: Any) {
        mainPage.previousPage(viewController: self)
    }
    @IBAction func butStart_Click(_ sender: Any) {
        let gl = GlobalInfos.getInstance()
        if gl.getActMainPageIndex() == 0 && gl.getActPageIndex() == 0 {
            return
        }
        GlobalInfos.getInstance().setActMainPageIndex(actMainPageIndex: 0)
        mainPage.refreshPage()
    }
    @IBAction func butMain_Click(_ sender: Any) {
        let gl = GlobalInfos.getInstance()
        if gl.getApartment() == nil || (gl.getActMainPageIndex() == 1 && gl.getActPageIndex() == 0) {
            return
        }
        gl.setActMainPageIndex(actMainPageIndex: 1)
        mainPage.refreshPage()
    }
    @IBAction func butRoomDescription_Click(_ sender: Any) {
        let gl = GlobalInfos.getInstance()
        if gl.getActMainPageIndex() == 2 && gl.getActPageIndex() == 0 {
            return
        }
        GlobalInfos.getInstance().setActMainPageIndex(actMainPageIndex: 2)
        mainPage.refreshPage()
    }
    @IBAction func butSensortype_Click(_ sender: Any) {
        let gl = GlobalInfos.getInstance()
        if gl.getActMainPageIndex() == 3 && gl.getActPageIndex() == 0 {
            return
        }
        GlobalInfos.getInstance().setActMainPageIndex(actMainPageIndex: 3)
        mainPage.refreshPage()
    }
    @IBAction func butEditing_Click(_ sender: Any) {
        let gl = GlobalInfos.getInstance()
        gl.setIsEditing(isEditing: !gl.getIsEditing())
        refresh()
    }
}
