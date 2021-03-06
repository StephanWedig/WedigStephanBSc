//
//  Room.swift
//  WedigStephanBSc
//
//  Created by Admin on 28.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import ARKit

public class Room : GeneralTableDataObject {
    private var _description : RoomDescription = RoomDescription(description: "")
    private var _rooms = [Room]()
    private var _sensors = NSMutableArray()
    private var _apartment : Apartment!
    private var _orientationMiddleNode:SCNNode? = nil
    private var _orientationXNode:SCNNode? = nil
    private var _orientationYNode:SCNNode? = nil
    public init (apartment : Apartment) {
        _apartment = apartment
    }
    private override init() {
    }
    public func setApartment(apartment : Apartment) {
        if(_apartment == nil) {
            _apartment = apartment
        }
    }
    public func getApartment() -> Apartment {
        return _apartment
    }
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(_description.getID(), forKey:"description")
        aCoder.encode(_sensors as NSMutableArray, forKey:"sensors")
        super.encode(with: aCoder)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        let descID = aDecoder.decodeObject(forKey: "description") as! String
        let gl = GlobalInfos.getInstance()
        for desc in gl.getRoomDescriptions() {
            if (desc as! RoomDescription).getID() == descID {
                _description = desc as! RoomDescription
                break
            }
        }
        _sensors = aDecoder.decodeObject(forKey: "sensors") as! NSMutableArray
        var i:Int = 0
        for s in _sensors {
            (s as! Sensor).setRoom(r: self)
            (s as! Sensor).setColor(color: gl.calcNodeColor[i%gl.calcNodeColor.count])
            i = i + 1
        }
        super.initForLoad(aDecoder: aDecoder)
    }
    public func setDescription (description : RoomDescription) {
        _description = description
        save()
    }
    public func getDescription () -> String {
        return _description.getDescription()
    }
    public func addRoom (room : Room){
        _rooms.append(room)
        save()
    }
    public func addSensor (sensor : Sensor){
        _sensors.add(sensor)
        save()
    }
    public func getSensors () -> NSMutableArray {
        return _sensors
    }
    public func compare(other : Room) -> Bool {
        return other.getID() == getID()
    }
    public func removeRoom (room : Room) {
        for index in 1..._rooms.count {
            if _rooms[index].compare(other: room) {
                _rooms.remove(at: index)
            }
        }
    }
    public func toHeadingString() -> String {
        return _apartment.toString() + " " + _description.getDescription()
    }
    public override func toString() -> String {
        return _description.getDescription()
    }
    public override func isOnlySmallObject() -> Bool { return false }
    public override func initForAdd() {
        super.initForAdd()
        //_apartment.addRoom(room: self)
        GlobalInfos.getInstance().setActRoomIndex(index: _apartment.getRooms().count - 1)
    }
    public func save() {
        GlobalInfos.getInstance().saveApartements()
    }
    public func getOrientationMiddleNode() -> SCNNode? {
        return _orientationMiddleNode
    }
    public func setOrientationMiddleNode(node : SCNNode) {
        _orientationMiddleNode = node
    }
    public func getOrientationXNode() -> SCNNode? {
        return _orientationXNode
    }
    public func setOrientationXNode(node : SCNNode) {
        _orientationXNode = node
    }
    public func getOrientationYNode() -> SCNNode? {
        return _orientationYNode
    }
    public func setOrientationYNode(node : SCNNode) {
        _orientationYNode = node
    }
}
