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
}

