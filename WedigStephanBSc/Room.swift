//
//  Room.swift
//  WedigStephanBSc
//
//  Created by Admin on 28.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

public class Room {
    private var _description : String = ""
    private var _ID : String = ""
    private var _rooms = [Room]()
    private var _sensors = [Sensor]()
    private var _apartment : Apartment
    public init (apartment : Apartment) {
        _apartment = apartment
        _ID = NSUUID().uuidString
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
        _sensors.append(sensor)
    }
    public func getSensors () -> [Sensor] {
        return _sensors
    }
    public func setID (ID : String) {
        _ID = ID
    }
    public func getID () -> String {
        return _ID
    }
    public func compare(other : Room) -> Bool {
        return other.getID() == _ID
    }
    public func removeRoom (room : Room) {
        for index in 1..._rooms.count {
            if _rooms[index].compare(other: room) {
                _rooms.remove(at: index)
            }
        }
    }
    public func toString() -> String {
        return _apartment.toString()! + " " + _description
    }
}
