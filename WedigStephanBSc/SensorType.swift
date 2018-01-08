//
//  SensorType.swift
//  WedigStephanBSc
//
//  Created by Admin on 05.12.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

public class SensorType {
    private var _description : String = ""
    public init (description : String) {
        _description = description
    }
    public func toString() -> String {
        return _description
    }
}

