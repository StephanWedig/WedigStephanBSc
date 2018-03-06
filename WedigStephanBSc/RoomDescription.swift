//
//  RoomDescription.swift
//  WedigStephanBSc
//
//  Created by Admin on 15.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

public class RoomDescription : GeneralTableDataObject, NSCoding {
    private var _description : String! = ""
    public init (description : String) {
        _description = description
    }
    public func getDescription() -> String {
        return _description
    }
    public func setDescription( description : String) {
        _description = description
    }
    public override func toString() -> String {
        return _description
    }
    public override func setValue (value : String) {
        _description = value
    }
    /*public func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encode(_description, forKey:"description")
        aCoder.encode(getID(), forKey:"id")
    }
    
    public init (coder aDecoder: NSCoder!) {
        _description = aDecoder.decodeObject(forKey: "description") as! String
    }*/
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(_description, forKey:"description")
        aCoder.encode(getID(), forKey:"id")
    }
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(description: aDecoder.decodeObject(forKey: "description") as! String)
    }
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(_description, forKey:"description")
        aCoder.encode(getID(), forKey:"id")
    }
    
    /*init (coder aDecoder: NSCoder!) {
        self._description = aDecoder.decodeObject(forKey: "description") as! String
    }*/
}
