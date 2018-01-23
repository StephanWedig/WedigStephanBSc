//
//  Sensor.swift
//  WedigStephanBSc
//
//  Created by Admin on 05.12.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import ARKit

public class Sensor : GeneralTableDataObject{
    private var _position : SCNVector3?
    private var _sensortype : SensorType?
    public init (position : SCNVector3) {
        _position = SCNVector3(position.x, position.y, position.z)
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
    public override func toString() -> String {
        var ret:String = getID()
        
        if _sensortype != nil {
            ret = ret + " " + _sensortype!.toString()
        }
        return ret
    }
    public override func isOnlySmallObject() -> Bool { return false }
}
