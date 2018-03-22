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
    private var _node : SCNNode?
    private var _color : UIColor? = UIColor.red
    private var _orientationX1Vector:SCNVector3? = nil
    private var _orientationY1Vector:SCNVector3? = nil
    private var _orientationZ1Vector:SCNVector3? = nil
    private var _orientationX2Vector:SCNVector3? = nil
    private var _orientationY2Vector:SCNVector3? = nil
    private var _orientationZ2Vector:SCNVector3? = nil
    //private var _isNew = true
    private var _isSelected = false
    public init (position : SCNVector3, room : Room) {
        _position = SCNVector3(position.x, position.y, position.z)
        _room = room
    }
    private init (position : SCNVector3) {
        _position = SCNVector3(position.x, position.y, position.z)
        /*_isNew = false
        print(_position)*/
    }
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(_position, forKey:"pos")
        var type : String = ""
        if _sensortype != nil {
            type = _sensortype.getID()
        }
        aCoder.encode(type, forKey:"sensortype")
        aCoder.encode(_orientationX1Vector, forKey:"xOrientationVector")
        aCoder.encode(_orientationY1Vector, forKey:"yOrientationVector")
        aCoder.encode(_orientationZ1Vector, forKey:"zOrientationVector")
        if _sensortype != nil {
            print(_sensortype.description)
            print(_orientationX1Vector)
            print(_orientationY1Vector)
            print(_orientationZ1Vector)
        }
        super.encode(with: aCoder)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(position: aDecoder.decodeObject(forKey: "pos") as! SCNVector3)
        _orientationX1Vector = aDecoder.decodeObject(forKey: "xOrientationVector") as? SCNVector3
        _orientationY1Vector = aDecoder.decodeObject(forKey: "yOrientationVector") as? SCNVector3
        _orientationZ1Vector = aDecoder.decodeObject(forKey: "zOrientationVector") as? SCNVector3
        if _orientationX1Vector != nil {
            _orientationX1Vector = SCNVector3((_orientationX1Vector?.x)!, (_orientationX1Vector?.y)!, (_orientationZ1Vector?.z)!)
        }
        if _orientationY1Vector != nil {
            _orientationY1Vector = SCNVector3((_orientationY1Vector?.x)!, (_orientationY1Vector?.y)!, (_orientationY1Vector?.z)!)
        }
        if _orientationZ1Vector != nil {
            _orientationZ1Vector = SCNVector3((_orientationZ1Vector?.x)!, (_orientationZ1Vector?.y)!, (_orientationZ1Vector?.z)!)
        }
        let gl = GlobalInfos.getInstance()
        let sensortypeID = aDecoder.decodeObject(forKey: "sensortype") as! String
        for type in gl.getSensorTypes() {
            if (type as! SensorType).getID() == sensortypeID {
                _sensortype = type as! SensorType
                break
            }
        }
        if _sensortype != nil {
            print(_sensortype.description)
            print(_orientationX1Vector)
            print(_orientationY1Vector)
            print(_orientationZ1Vector)
        }
        //_isNew = false
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
    public func getRoom() -> Room? {
        return _room
    }
    public func setXVector(v:SCNVector3) {
        if _orientationX1Vector == nil/* || _isNew*/ {
            _orientationX1Vector = v
            save()
            print("Vector1X")
        } else {
            _orientationX2Vector = v
        }
    }
    public func setYVector(v:SCNVector3) {
        if _orientationY1Vector == nil/* || _isNew*/ {
            _orientationY1Vector = v
            save()
            print("Vector1Y")
        } else {
            _orientationY2Vector = v
        }
    }
    public func setZVector(v:SCNVector3) {
        if _orientationZ1Vector == nil/* || _isNew*/ {
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
    public func invertSelection() {
        _isSelected = !_isSelected
        selectionChanged()
    }
    private func selectionChanged() {
        if _node != nil {
            if _isSelected {
                _color = _node?.geometry?.firstMaterial?.diffuse.contents as? UIColor
                _node?.geometry?.firstMaterial?.diffuse.contents = GlobalInfos.getInstance().selectedNodeColor
            } else {
                _node?.geometry?.firstMaterial?.diffuse.contents = _color
            }
        }
    }
    
    public func setIsSelected( isSelected: Bool) {
        _isSelected = isSelected
        selectionChanged()
    }
    public func getIsSelected() -> Bool {
        return _isSelected
    }
    public func setNode(node:SCNNode) {
        _node = node
    }
    public func getNode() -> SCNNode? {
        return _node
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
