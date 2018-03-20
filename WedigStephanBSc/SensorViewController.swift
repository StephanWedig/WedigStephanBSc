//
//  SensorViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 13.12.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

class SensorViewController: GeneralViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private var actObject : Sensor!
    @IBOutlet weak var pickerType: UIPickerView!
    @IBOutlet weak var butType: UIButton!
    @IBOutlet weak var labPosition: UILabel!
    
    override func viewDidLoad() {
        enumViewController = GlobalInfos.ViewControllers.Sensor
        super.viewDidLoad()
        pickerType.delegate = self
        pickerType.dataSource = self
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GlobalInfos.getInstance().getSensorTypes().count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        swapPickerDescriptionVisible()
        actObject.setSensortype(sensortype: GlobalInfos.getInstance().getSensorTypes()[row] as! SensorType)
        refresh()
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (GlobalInfos.getInstance().getSensorTypes()[row] as! SensorType).getDescription()
    }
    public override func refresh() {
        super.refresh()
        let gl = GlobalInfos.getInstance()
        actObject = gl.getActRoom()?.getSensors()[getActObjectListIndex()] as! Sensor
        if(actObject == nil) {
            return
        }
        if butType != nil {
            if actObject.getSensortype() != nil {
                butType.setTitle(actObject.getSensortype().getDescription(), for: .normal)
            } else {
                butType.setTitle("Select a sensor type", for: .normal)
            }
            butType.isEnabled = gl.getIsEditing()
        }
        if pickerType != nil {
            pickerType.reloadAllComponents()
        }
        if labPosition != nil {
            labPosition.text = String(actObject.getPosition().x) + " " + String(actObject.getPosition().y) + " " + String(actObject.getPosition().z)
        }
        navTopItem.title = gl.getActRoom()?.toString()
    }
    private func swapPickerDescriptionVisible () {
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerType.isHidden = !self.pickerType.isHidden
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func butType_Onclick(_ sender: UIButton) {
        swapPickerDescriptionVisible()
    }
}
