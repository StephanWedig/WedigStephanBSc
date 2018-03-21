//
//  StartViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 23.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: GeneralViewController {
    
    @IBOutlet weak var butNew: UIButton!
    @IBOutlet weak var tableApartement: UITableView!
    
    override func viewDidLoad() {
        enumViewController = GlobalInfos.ViewControllers.OpenSave
        
        let gl = GlobalInfos.getInstance()
        if gl.getRoomDescriptions().count == 0 && FileManager().fileExists(atPath: gl.ArchiveRoomDescription.path) {
            let roomDescriptionList = NSKeyedUnarchiver.unarchiveObject(withFile: gl.ArchiveRoomDescription.path) as! NSMutableArray
            for roomDescription in roomDescriptionList {
                let s = roomDescription as! RoomDescription
                GlobalInfos.getInstance().addRoomDescription(description: s)
            }
        } else {
            print("Room Description File not found")
        }
        if gl.getSensorTypes().count == 0 && FileManager().fileExists(atPath: gl.ArchiveSensorType.path) {
            let sensorTypeList = NSKeyedUnarchiver.unarchiveObject(withFile: gl.ArchiveSensorType.path) as! NSMutableArray
            for sensorType in sensorTypeList {
                let s = sensorType as! SensorType
                GlobalInfos.getInstance().addSensorType(sensorType: s)
            }
        } else {
            print("Sensor Type File not found")
        }
        super.viewDidLoad()
    }
    
    public override func refresh() {
        super.refresh()
        print(tableApartement == nil)
        if tableApartement == nil {
            return;
        }
        tableApartement.reloadData()
        navTopItem.title = "Apartments"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let gl = GlobalInfos.getInstance()
        print("E: " + String(gl.getIsEditing()))
        if gl.getIsEditing() {
            return (gl.getApartments()?.count)! + 1
        }
        return (gl.getApartments()!.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GeneralTableDataCell = tableApartement.dequeueReusableCell(withIdentifier: "cellApartment", for: indexPath) as! GeneralTableDataCell
        
        cell.setParentController(ParentController: self)
        let gl = GlobalInfos.getInstance()
        if(indexPath.row == gl.getApartments()?.count) {
            cell.setIsLast(isLast : true)
            cell.setDataBinding(dataObject: Apartment(), dataObjectList: (gl.getApartments())!, viewController: GlobalInfos.ViewControllers.Apartment)
        } else {
            cell.setDataBinding(dataObject: gl.getApartments()![indexPath.row] as! GeneralTableDataObject, dataObjectList:  gl.getApartments()!, viewController: GlobalInfos.ViewControllers.Apartment)
        }
        cell.refresh()
        return cell
    }
    /*
 
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell:GeneralTableDataCell = tableRooms.dequeueReusableCell(withIdentifier: "cellRoom", for: indexPath) as! GeneralTableDataCell
     
     cell.setParentController(ParentController: self)
     if(indexPath.row == actObject?.getRooms().count) {
     cell.setIsLast(isLast : true)
     cell.setDataBinding(dataObject: Room(apartment: (actObject)!), dataObjectList: (actObject?.getRooms())!, viewController: GlobalInfos.ViewControllers.Room)
     } else {
     cell.setDataBinding(dataObject: actObject?.getRooms()[indexPath.row] as! GeneralTableDataObject, dataObjectList:  (actObject?.getRooms())!, viewController: GlobalInfos.ViewControllers.Room)
     }
     cell.refresh()
     return cell
     }
 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gl = GlobalInfos.getInstance()
        let controllerIndex = GlobalInfos.ViewControllers.Apartment.rawValue
        gl.orderedViewControllers[controllerIndex].setActObjectListIndex(index: indexPath.row)
        gl.setActApartment(index: indexPath.row)
        gl.setActPageIndex(actPageIndex: controllerIndex)
        
        mainPage.refreshPage()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func butNew_Click(_ sender: Any) {
        let gl = GlobalInfos.getInstance()
        
        gl.addApartment(apartment: Apartment())
        gl.orderedViewControllers[GlobalInfos.ViewControllers.Apartment.rawValue].setActObjectListIndex(index: 0)
        gl.setActApartment(index: 0)
        gl.setActPageIndex(actPageIndex: GlobalInfos.ViewControllers.Apartment.rawValue)
        mainPage.refreshPage()
    }
    @IBAction func butOpen_Click(_ sender: UIButton) {
        let gl = GlobalInfos.getInstance()
        if FileManager().fileExists(atPath: gl.ArchiveApartment.path) {
            /*let apartment = NSKeyedUnarchiver.unarchiveObject(withFile: gl.ArchiveApartment.path) as! Apartment
            gl.addApartment(apartment: apartment)
            gl.setActPageIndex(actPageIndex: GlobalInfos.ViewControllers.Apartment.rawValue)
            mainPage.refreshPage()*/
            let apartments = NSKeyedUnarchiver.unarchiveObject(withFile: gl.ArchiveApartment.path) as! NSMutableArray
            for a in apartments {
                gl.addApartment(apartment: a as! Apartment)
            }
            gl.orderedViewControllers[GlobalInfos.ViewControllers.Apartment.rawValue].setActObjectListIndex(index: 0)
            gl.setActApartment(index: 0)
            gl.setActPageIndex(actPageIndex: GlobalInfos.ViewControllers.Apartment.rawValue)
            mainPage.refreshPage()
            
        } else {
            print("Apartment File not found")
        }
    }
}
