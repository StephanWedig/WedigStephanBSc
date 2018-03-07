//
//  SensorType.swift
//  WedigStephanBSc
//
//  Created by Admin on 05.12.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

public class SensorType : GeneralTableDataObject {
    private var _description : String = ""
    public init (description : String) {
        _description = description
    }
    public func setDescription (description : String) {
        _description = description
    }
    public func getDescription() -> String {
        return _description
    }
    public override func toString() -> String {
        return _description
    }
    public override func isOnlySmallObject() -> Bool { return false }
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(_description, forKey:"description")
        super.encode(with: aCoder)
    }
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(description: aDecoder.decodeObject(forKey: "description") as! String)
        super.initForLoad(aDecoder: aDecoder)
    }
}

