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
    private var _apartements = NSMutableArray()
    private var _actRoomIndex = -1
    private var _actApartementIndex = -1
    public static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    public static let selectedButtonBackgroundColor = UIColor.yellow
    public static let unselectedButtonBackgroundColor = UIColor.clear
    public let ArchiveRoomDescription = GlobalInfos.DocumentsDirectory.appendingPathComponent("RoomDescription.plist")
    public let ArchiveSensorType = GlobalInfos.DocumentsDirectory.appendingPathComponent("SensorType.plist")
    public let ArchiveApartment = GlobalInfos.DocumentsDirectory.appendingPathComponent("Apartment.plist")
    public let selectedNodeColor = UIColor.yellow
    public var calcNodeColor = [UIColor]()
    private var _actPageIndex = 0
    private var _isEditing = false
    private init () {
        calcNodeColor.append(UIColor.red)
        calcNodeColor.append(UIColor.brown)
        calcNodeColor.append(UIColor.green)
        calcNodeColor.append(UIColor.orange)
    }
    public static func getInstance() -> GlobalInfos {
        return _globalInfos
    }
    public func addApartment (apartment : Apartment) {
        _apartements.add(apartment)
    }
    public func getActApartment () -> Apartment? {
        if _actApartementIndex >= _apartements.count || _actApartementIndex < 0 {
            return nil
        }
        return _apartements[_actApartementIndex] as? Apartment
    }
    public func setActApartment(index : Int) {
        _actApartementIndex = index
    }
    public func getApartments () -> NSMutableArray? {
        return _apartements
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
    public func setActPageIndex ( actPageIndex : Int) {
        addActControllerToNavigationOrder()
        _actPageIndex = actPageIndex
    }
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
        let a = getActApartment()
        if a == nil {
            return nil
        }
        if (a!.getRooms().count) <= _actRoomIndex {
            return nil
        }
        if(_actRoomIndex < 0) {
            return nil
        }
        return (a!.getRooms()[_actRoomIndex]) as? Room
    }
    public func setToPreviousViewController() {
        if navigationOrder.count == 0 {
            return
        }
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
    public func saveApartements() {
        if ArchiveApartment.path != "" {
            NSKeyedArchiver.archiveRootObject(_apartements, toFile: ArchiveApartment.path)
        }
    }
    public func saveSensorTypes() {
        if ArchiveSensorType.path != "" {
            NSKeyedArchiver.archiveRootObject(_sensorTypes, toFile: ArchiveSensorType.path)
        }
    }
    public func saveRoomDescriptions() {
        if ArchiveRoomDescription.path != "" {
            NSKeyedArchiver.archiveRootObject(_roomDescriptions, toFile: ArchiveRoomDescription.path)
        }
    }
    public func save() {
        saveSensorTypes()
        saveApartements()
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
