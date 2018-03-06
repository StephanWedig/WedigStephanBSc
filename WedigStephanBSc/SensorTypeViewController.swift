//
//  SensorTypeViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 19.12.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

public class SensorTypeViewController : GeneralViewController {
    private var actObject : SensorType!
    @IBOutlet weak var txtName: UITextField!
    override public func viewDidLoad() {
        enumViewController = GlobalInfos.ViewControllers.SensorType
        super.viewDidLoad()
        txtName.delegate = self
        refresh()
    }
    public override func refresh() {
        super.refresh()
        actObject = GlobalInfos.getInstance().getSensorTypes()[getActObjectListIndex()] as! SensorType
        if actObject == nil || txtName == nil {
            return
        }
        txtName.text = actObject.getDescription()
    }
    
    override public func textFieldDidEndEditing(_ textField: UITextField) {    //delegate method
        super.textFieldDidEndEditing(textField)
        let gl = GlobalInfos.getInstance()
        let s = gl.getSensorTypes()[getActObjectListIndex()] as! SensorType
        if textField == txtName {
            s.setDescription(description: textField.text!)
        }
    }
}
