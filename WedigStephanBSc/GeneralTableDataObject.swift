//
//  GeneralTableDataObject.swift
//  WedigStephanBSc
//
//  Created by Admin on 15.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

public class GeneralTableDataObject {
    private let _ID = NSUUID().uuidString
    public func getID() -> String {
        return _ID
    }
    public func toString() -> String { return "" }
}
