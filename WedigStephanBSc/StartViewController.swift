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
    override func refresh() {
        super.refresh()
        navTopBar.isHidden = true
    }
    
    @IBAction func butNew_Click(_ sender: Any) {
        let gl = GlobalInfos.getInstance()
        
        gl.setApartment(apartment: Apartment())
        gl.addActControllerToNavigationOrder()
        gl.setActPageIndex(actPageIndex: GlobalInfos.ViewControllers.Apartment.rawValue)
        mainPage.refreshPage()
    }
}
