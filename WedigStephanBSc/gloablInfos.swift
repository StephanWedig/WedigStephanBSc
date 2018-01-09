//
//  gloablInfos.swift
//  WedigStephanBSc
//
//  Created by Admin on 05.12.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

public class GlobalInfos {
    private static var _globalInfos:GlobalInfos = GlobalInfos()
    private var _apartement : Apartment?
    private var _actRoomIndex = 0
    private var _actMainPageIndex = 0
    private var _actPageIndex = 0
    private init () {
        
    }
    public static func getInstance() -> GlobalInfos {
        return _globalInfos
    }
    public func setApartment (apartment : Apartment) {
        _apartement = apartment
    }
    public func getApartment () -> Apartment? {
        return _apartement
    }
    public func setActRoomIndex(index:Int) {
        _actRoomIndex = index
    }
    public func getActRoomIndex() -> Int {
        return _actRoomIndex
    }
    public func setActMainPageIndex ( actMainPageIndex : Int) {
        _actMainPageIndex = actMainPageIndex
        _actPageIndex = 0
    }
    public func getActMainPageIndex () -> Int {
        return _actMainPageIndex
    }
    public func setActPageIndex ( actPageIndex : Int) {
        _actPageIndex = actPageIndex
    }
    public func getActPageIndex () -> Int {
        return _actPageIndex
    }
    public func getActRoom() -> Room? {
        if _apartement == nil {
            return nil
        }
        if _apartement?.getRooms() == nil {
            return nil
        }
        if (_apartement?.getRooms().count)! < _actRoomIndex {
            return nil
        }
        if _apartement?.getRooms().count == _actRoomIndex {
            let r = Room(apartment: _apartement!)
            _apartement?.appendRoom(room: r)
            return r
        }
        return (_apartement?.getRooms()[_actRoomIndex])!
    }
    
    private(set) lazy var orderedViewControllers: [[GeneralViewController]] = {
        return [[self.newColoredViewController(Identifier: "OpenSave")],[
                self.newColoredViewController(Identifier: "Apartment"),
                self.newColoredViewController(Identifier: "Room"),
                self.newColoredViewController(Identifier: "AR")],
                [self.newColoredViewController(Identifier: "RoomDescription")],
                [self.newColoredViewController(Identifier: "SensorType")]]
    }()
    
    public func newColoredViewController(Identifier: String) -> GeneralViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(Identifier)ViewController") as! GeneralViewController
    }
}
