//
//  RoomViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 12.12.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

class RoomViewController: GeneralViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var actObject : Room!
    @IBOutlet weak var pickerDescription: UIPickerView!
    @IBOutlet weak var butDescription: UIButton!
    //@IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var tableSensor: UITableView!
    override func viewDidLoad() {
        enumViewController = GlobalInfos.ViewControllers.Room
        super.viewDidLoad()
        //txtDescription.delegate = self
        tableSensor.delegate = self
        tableSensor.dataSource = self
        pickerDescription.delegate = self
        pickerDescription.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let gl = GlobalInfos.getInstance()
        if gl.getActRoom() != nil && gl.getActRoom()?.getSensors() != nil {
            return (gl.getActRoom()?.getSensors().count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GeneralTableDataCell = tableSensor.dequeueReusableCell(withIdentifier: "cellSensor", for: indexPath) as! GeneralTableDataCell
        let gl = GlobalInfos.getInstance()
        
        cell.setParentController(ParentController: self)
        if gl.getActRoom() != nil && gl.getActRoom()?.getSensors() != nil {
            cell.setDataBinding(dataObject: gl.getActRoom()?.getSensors()[indexPath.row] as! GeneralTableDataObject, dataObjectList:  (gl.getActRoom()?.getSensors())!, viewController: GlobalInfos.ViewControllers.Sensor)
        }
        cell.refresh()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gl = GlobalInfos.getInstance()
        let controllerIndex = GlobalInfos.ViewControllers.Sensor.rawValue
        gl.orderedViewControllers[controllerIndex].setActObjectListIndex(index: indexPath.row)
        //gl.setActRoomIndex(index: indexPath.row)
        gl.setActPageIndex(actPageIndex: controllerIndex)
        
        mainPage.refreshPage()
        //mainPage.nextPage(viewController: self)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GlobalInfos.getInstance().getRoomDescriptions().count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        swapPickerDescriptionVisible()
        actObject.setDescription(description: GlobalInfos.getInstance().getRoomDescriptions()[row] as! RoomDescription)
        refresh()
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (GlobalInfos.getInstance().getRoomDescriptions()[row] as! RoomDescription).getDescription()
    }
    
    public override func refresh() {
        super.refresh()
        actObject = GlobalInfos.getInstance().getApartment()?.getRooms()[getActObjectListIndex()] as! Room
        let gl = GlobalInfos.getInstance()
        if(actObject == nil) {
            return
        }
        if butDescription != nil {
            if actObject.getDescription() != "" {
                butDescription.setTitle(actObject.getDescription(), for: .normal)
            } else {
                butDescription.setTitle("Select a room description", for: .normal)
            }
            butDescription.isEnabled = gl.getIsEditing()
        }
        if tableSensor != nil {
            tableSensor.reloadData()
        }
        navTopItem.title = gl.getApartment()?.toString()
    }
    override func textFieldDidEndEditing(_ textField: UITextField) {    //delegate method
        super.textFieldDidEndEditing(textField)
        let gl = GlobalInfos.getInstance()
        let r = gl.getActRoom()
        if(r == nil) {
            return
        }
    }
    @IBAction func butDescription_Onclick(_ sender: UIButton) {
        swapPickerDescriptionVisible()
    }
    private func swapPickerDescriptionVisible () {
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerDescription.isHidden = !self.pickerDescription.isHidden
            self.view.layoutIfNeeded()
        })
    }
}
