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
        if gl.getRoomDescriptions().count < 0 && FileManager().fileExists(atPath: GlobalInfos.ArchiveRoomDescription.path) {
            /*let roomDescriptionList = NSMutableArray(contentsOfFile: GlobalInfos.ArchiveRoomDescription.path)
            if roomDescriptionList != nil {
                for roomDescription in roomDescriptionList! {
                    gl.addRoomDescription(description: roomDescription as! RoomDescription)
                }
            }*/
            let roomDescriptionList = NSKeyedUnarchiver.unarchiveObject(withFile: GlobalInfos.ArchiveRoomDescription.path) as! NSMutableArray
            
            if roomDescriptionList != nil {
                for roomDescription in roomDescriptionList {
                    let s = roomDescription as! RoomDescription
                    GlobalInfos.getInstance().addRoomDescription(description: s)
                    print(s.getDescription())
                }
                print(roomDescriptionList.count)
            } else {
                print("Liste ist NULL")
            }
        } else {
            print("File not found")
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
