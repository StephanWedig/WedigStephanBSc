//
//  Sensor.swift
//  WedigStephanBSc
//
//  Created by Admin on 05.12.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import ARKit

public class Sensor {
    private var _ID : Int = -1
    private var _position : SCNVector3?
    private var _sensortype : SensorType?
    public init (position : SCNVector3) {
        _position = SCNVector3(position.x, position.y, position.z)
    }
    public func getID () -> Int {
        return _ID
    }
    public func setSensortype (sensortype:SensorType) {
        _sensortype = sensortype
    }
    public func getSensortype () -> SensorType {
        return _sensortype!
    }
    public func getPosition () -> SCNVector3 {
        return _position!
    }
    public func toString() -> String {
        var ret:String = "1"
        if _ID != -1 {
            ret = ret + String(_ID)
        }
        if _sensortype != nil {
            ret = ret + " " + _sensortype!.toString()
        }
        return ret
    }
}
