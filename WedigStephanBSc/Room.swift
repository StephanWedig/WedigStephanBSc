//
//  Room.swift
//  WedigStephanBSc
//
//  Created by Admin on 28.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

public class Room : GeneralTableDataObject {
    private var _description : RoomDescription = RoomDescription(description: "")
    private var _rooms = [Room]()
    private var _sensors = NSMutableArray()
    private var _apartment : Apartment!
    public init (apartment : Apartment) {
        _apartment = apartment
    }
    public func setApartment(apartment : Apartment) {
        if(_apartment == nil) {
            _apartment = apartment
        }
    }
    public override init() {
        
    }
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(_description.getID(), forKey:"description")
        aCoder.encode(_sensors, forKey:"sensors")
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
    }
    public func addSensor (sensor : Sensor){
        _sensors.add(sensor)
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
    public func save() {
        GlobalInfos.getInstance().getApartment()?.save()
    }
}
