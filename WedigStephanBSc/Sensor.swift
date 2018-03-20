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
    private var _sensortype : SensorType!
    private var _room : Room?
    private var _color : UIColor? = UIColor.red
    public init (position : SCNVector3, room : Room) {
        _position = SCNVector3(position.x, position.y, position.z)
        _room = room
    }
    private init (position : SCNVector3) {
        _position = SCNVector3(position.x, position.y, position.z)
    }
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(_position, forKey:"pos")
        var type : String = ""
        if _sensortype != nil {
            type = _sensortype.getID()
        }
        aCoder.encode(type, forKey:"sensortype")
        super.encode(with: aCoder)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(position: aDecoder.decodeObject(forKey: "pos") as! SCNVector3)
        let gl = GlobalInfos.getInstance()
        let sensortypeID = aDecoder.decodeObject(forKey: "sensortype") as! String
        for type in gl.getSensorTypes() {
            if (type as! SensorType).getID() == sensortypeID {
                _sensortype = type as! SensorType
                break
            }
        }
        super.initForLoad(aDecoder: aDecoder)
    }
    public func setSensortype (sensortype:SensorType) {
        _sensortype = sensortype
        save()
    }
    public func getSensortype () -> SensorType! {
        return _sensortype
    }
    public func getPosition () -> SCNVector3 {
        return _position!
    }
    public func getColor() -> UIColor? {
        return _color
    }
    public func setRoom (r: Room) {
        _room = r
    }
    public func save() {
        GlobalInfos.getInstance().saveApartements()
    }
    public override func toString() -> String {
        var ret:String = ""
        
        if _sensortype != nil {
            ret = _sensortype!.toString()
        }
        return ret
    }
    public override func isOnlySmallObject() -> Bool { return false }
}
