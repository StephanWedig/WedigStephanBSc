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
    private var _orientationX1Vector:SCNVector3? = nil
    private var _orientationY1Vector:SCNVector3? = nil
    private var _orientationZ1Vector:SCNVector3? = nil
    private var _orientationX2Vector:SCNVector3? = nil
    private var _orientationY2Vector:SCNVector3? = nil
    private var _orientationZ2Vector:SCNVector3? = nil
    private var _isNew = true
    public init (apartment : Apartment) {
        _apartment = apartment
    }
    private override init() {
        _isNew = false
    }
    public func setApartment(apartment : Apartment) {
        if(_apartment == nil) {
            _apartment = apartment
        }
    }
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(_description.getID(), forKey:"description")
        aCoder.encode(_sensors, forKey:"sensors")
        aCoder.encode(_orientationX1Vector, forKey:"xOrientationVector")
        aCoder.encode(_orientationY1Vector, forKey:"yOrientationVector")
        aCoder.encode(_orientationZ1Vector, forKey:"zOrientationVector")
        super.encode(with: aCoder)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        _orientationX1Vector = aDecoder.decodeObject(forKey: "xOrientationVector") as? SCNVector3
        _orientationY1Vector = aDecoder.decodeObject(forKey: "yOrientationVector") as? SCNVector3
        _orientationZ1Vector = aDecoder.decodeObject(forKey: "zOrientationVector") as? SCNVector3
        let descID = aDecoder.decodeObject(forKey: "description") as! String
        let gl = GlobalInfos.getInstance()
        for desc in gl.getRoomDescriptions() {
            if (desc as! RoomDescription).getID() == descID {
                _description = desc as! RoomDescription
                break
            }
        }
        _sensors = aDecoder.decodeObject(forKey: "sensors") as! NSMutableArray
        for s in _sensors {
            (s as! Sensor).setRoom(r: self)
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
        return _apartment.toString()! + " " + _description.getDescription()
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
    private func save() {
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
    public func setXVector(v:SCNVector3) {
        if _orientationX1Vector == nil || _isNew {
            _orientationX1Vector = v
            save()
            print("Vector1X")
        } else {
            _orientationX2Vector = v
        }
    }
    public func setYVector(v:SCNVector3) {
        if _orientationY1Vector == nil || _isNew {
            _orientationY1Vector = v
            save()
            print("Vector1Y")
        } else {
            _orientationY2Vector = v
        }
    }
    public func setZVector(v:SCNVector3) {
        if _orientationZ1Vector == nil || _isNew {
            _orientationZ1Vector = v
            save()
            print("Vector1Z")
        } else {
            _orientationZ2Vector = v
        }
    }
    public func getX1Vector() -> SCNVector3? {
        return _orientationX1Vector
    }
    public func getX2Vector() -> SCNVector3? {
        return _orientationX2Vector
    }
    public func getY1Vector() -> SCNVector3? {
        return _orientationY1Vector
    }
    public func getY2Vector() -> SCNVector3? {
        return _orientationY2Vector
    }
    public func getZ1Vector() -> SCNVector3? {
        return _orientationZ1Vector
    }
    public func getZ2Vector() -> SCNVector3? {
        return _orientationZ2Vector
    }
}
