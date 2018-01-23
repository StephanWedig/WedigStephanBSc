//
//  Room.swift
//  WedigStephanBSc
//
//  Created by Admin on 28.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

public class Room : GeneralTableDataObject {
    private var _description : String = ""
    private var _rooms = [Room]()
    private var _sensors = NSMutableArray()
    private var _apartment : Apartment
    public init (apartment : Apartment) {
        _apartment = apartment
        GlobalInfos.getInstance().setActRoomIndex(index: apartment.getRooms().count)
    }
    public func setDescription (description : String) {
        _description = description
    }
    public func getDescription () -> String {
        return _description
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
        return _apartment.toString()! + " " + _description
    }
    public override func toString() -> String {
        return _description
    }
    public override func isOnlySmallObject() -> Bool { return false }
}
