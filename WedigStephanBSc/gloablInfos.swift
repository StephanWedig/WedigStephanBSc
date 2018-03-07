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
    private var navigationOrder = [Int]()
    private var _roomDescriptions = NSMutableArray()
    private var _sensorTypes = NSMutableArray()
    private var _apartement : Apartment?
    private var _actRoomIndex = 0
    public static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    //public static let DocumentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    public let ArchiveRoomDescription = GlobalInfos.DocumentsDirectory.appendingPathComponent("RoomDescription.plist")
    public let ArchiveSensorType = GlobalInfos.DocumentsDirectory.appendingPathComponent("SensorType.plist")
    //private var _actMainPageIndex = 0
    private var _actPageIndex = 0
    private var _isEditing = false
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
    public func getRoomDescriptions () -> NSMutableArray {
        return _roomDescriptions
    }
    public func addRoomDescription (description : RoomDescription) {
        _roomDescriptions.add(description)
    }
    public func getSensorTypes () -> NSMutableArray {
        return _sensorTypes
    }
    public func addSensorType (sensorType : SensorType) {
        _sensorTypes.add(sensorType)
    }
    /*public func setActMainPageIndex ( actMainPageIndex : Int) {
        addActControllerToNavigationOrder()
        _actMainPageIndex = actMainPageIndex
        _actPageIndex = 0
    }
    public func getActMainPageIndex () -> Int {
        return _actMainPageIndex
    }*/
    public func setActPageIndex ( actPageIndex : Int) {
        addActControllerToNavigationOrder()
        _actPageIndex = actPageIndex
    }
    /*public func getActPageIndex () -> Int {
        return _actPageIndex
    }*/
    public func getActViewController() -> GeneralViewController {
        return orderedViewControllers[_actPageIndex]
    }
    public func setIsEditing(isEditing : Bool) {
        _isEditing = isEditing
    }
    public func getIsEditing() -> Bool {
        return _isEditing
    }
    public func getActRoom() -> Room? {
        if _apartement == nil {
            return nil
        }
        if _apartement?.getRooms() == nil {
            return nil
        }
        if (_apartement?.getRooms().count)! <= _actRoomIndex {
            return nil
        }
        /*if _apartement?.getRooms().count == _actRoomIndex {
            return nil
        }*/
        return (_apartement?.getRooms()[_actRoomIndex]) as? Room
    }
    public func setToPreviousViewController() {
        let vc = navigationOrder[navigationOrder.count - 1]
        navigationOrder.remove(at: navigationOrder.count - 1)
        _actPageIndex = vc
    }
    public func addActControllerToNavigationOrder () {
        navigationOrder.append(_actPageIndex)
    }
    
    public enum ViewControllers : Int {
        case unknown = -1
        case OpenSave = 0
        case Apartment = 1
        case Room = 2
        case AR = 3
        case RoomDescription = 4
        case SensorType = 5
        case SensorTypeList = 6
        case Sensor = 7
    }
    private(set) lazy var orderedViewControllers: [GeneralViewController] = {
        return [self.newColoredViewController(Identifier: "OpenSave"),
                self.newColoredViewController(Identifier: "Apartment"),
                self.newColoredViewController(Identifier: "Room"),
                self.newColoredViewController(Identifier: "AR"),
                self.newColoredViewController(Identifier: "RoomDescription"),
                self.newColoredViewController(Identifier: "SensorType"),
                self.newColoredViewController(Identifier: "SensorTypeList"),
                self.newColoredViewController(Identifier: "Sensor")]
    }()
    
    public func newColoredViewController(Identifier: String) -> GeneralViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(Identifier)ViewController") as! GeneralViewController
    }
}
