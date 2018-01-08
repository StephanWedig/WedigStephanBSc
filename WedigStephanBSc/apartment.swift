//
//  apartment.swift
//  WedigStephanBSc
//
//  Created by Admin on 28.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

public class Apartment {
    private var _street : String? = ""
    private var _housenumber : String? = ""
    private var _postalcode : String? = ""
    private var _location : String? = ""
    private var _name : String? = ""
    private var _rooms = [Room]()
    public init () {
        
    }
    public init (street:String, postalcode:String, location:String, housenumber:String) {
        _street = street
        _housenumber = housenumber
        _postalcode = postalcode
        _location = location
    }
    public func getStreet() -> String? {
        return _street
    }
    public func setStreet( street : String? ) {
        _street = street
    }
    public func getPostalcode() -> String? {
        return _postalcode
    }
    public func setPostalcode( postalcode : String? ) {
        _postalcode = postalcode
    }
    public func getLocation() -> String? {
        return _location
    }
    public func setLocation( location : String? ) {
        _location = location
    }
    public func setName (name : String?) {
        _name = name
    }
    public func appendRoom (room : Room){
        _rooms.append(room)
    }
    public func setHousenumber( housenumber : String? ) {
        _housenumber = housenumber
    }
    public func getHousenumber () -> String? {
        return _housenumber
    }
    public func getRooms () -> [Room] {
        return _rooms
    }
    public func getName () -> String? {
        return _name
    }
    public func toString () -> String? {
        return _name
    }
}
