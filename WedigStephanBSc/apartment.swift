//
//  apartment.swift
//  WedigStephanBSc
//
//  Created by Admin on 28.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

public class Apartment : GeneralTableDataObject {
    private var _street : String = ""
    private var _housenumber : String = ""
    private var _postalcode : String = ""
    private var _location : String = ""
    private var _name : String = ""
    private var _rooms = NSMutableArray()
    public override init () {
        super.init()
    }
    public init (street:String, postalcode:String, location:String, housenumber:String) {
        _street = street
        _housenumber = housenumber
        _postalcode = postalcode
        _location = location
    }
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        _street = aDecoder.decodeObject(forKey: "street") as! String
        _housenumber = aDecoder.decodeObject(forKey: "housenumber") as! String
        _postalcode = aDecoder.decodeObject(forKey: "postalcode") as! String
        _location = aDecoder.decodeObject(forKey: "location") as! String
        _name = aDecoder.decodeObject(forKey: "name") as! String
        _rooms = aDecoder.decodeObject(forKey: "rooms") as! NSMutableArray
        for room in _rooms {
            (room as! Room).setApartment(apartment: self)
        }
        initForLoad(aDecoder: aDecoder)
    }
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(_street, forKey:"street")
        aCoder.encode(_housenumber, forKey:"housenumber")
        aCoder.encode(_postalcode, forKey:"postalcode")
        aCoder.encode(_location, forKey:"location")
        aCoder.encode(_name, forKey:"name")
        aCoder.encode(_rooms, forKey:"rooms")
    }
    public func getStreet() -> String? {
        return _street
    }
    public func setStreet( street : String ) {
        _street = street
        save()
    }
    public func getPostalcode() -> String? {
        return _postalcode
    }
    public func setPostalcode( postalcode : String ) {
        _postalcode = postalcode
        save()
    }
    public func getLocation() -> String? {
        return _location
    }
    public func setLocation( location : String ) {
        _location = location
        save()
    }
    public func setName (name : String) {
        _name = name
        save()
    }
    public func addRoom (room : Room){
        _rooms.add(room)
        save()
    }
    public func setHousenumber( housenumber : String ) {
        _housenumber = housenumber
        save()
    }
    public func getHousenumber () -> String? {
        return _housenumber
    }
    public func getRooms () -> NSMutableArray {
        return _rooms
    }
    public func getName () -> String? {
        return _name
    }
    public override func toString () -> String {
        return _name
    }
    private func save() {
        GlobalInfos.getInstance().saveApartements()
    }
    public override func initForAdd() {
        super.initForAdd()
        let gl = GlobalInfos.getInstance()
        gl.setActApartment(index: (gl.getApartments()?.count)! - 1)
    }
    public override func isOnlySmallObject() -> Bool { return false }
}
