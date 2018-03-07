//
//  GeneralTableDataObject.swift
//  WedigStephanBSc
//
//  Created by Admin on 15.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

public class GeneralTableDataObject : NSObject, NSCoding {
    
    private var _ID : String! = NSUUID().uuidString
    public func getID() -> String {
        return _ID
    }
    public func setValue (value : String) { }
    public func toString() -> String { return "" }
    public func isOnlySmallObject() -> Bool { return true }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(getID(), forKey:"id")
    }
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self._ID = aDecoder.decodeObject(forKey: "id") as! String
    }
    public func initForLoad (aDecoder: NSCoder) {
        _ID = aDecoder.decodeObject(forKey: "id") as! String
    }
    public func initForAdd() {}
}
