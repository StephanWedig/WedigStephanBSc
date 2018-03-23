//
//  MatrixVectorFunctions.swift
//  WedigStephanBSc
//
//  Created by Admin on 23.03.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import ARKit

func +(lhv:SCNVector3, rhv:SCNVector3) -> SCNVector3 {
    return SCNVector3(lhv.x + rhv.x, lhv.y + rhv.y, lhv.z + rhv.z)
}
func -(lhv:SCNVector3, rhv:SCNVector3) -> SCNVector3 {
    return SCNVector3(lhv.x - rhv.x, lhv.y - rhv.y, lhv.z - rhv.z)
}
func -(lhv:SCNVector3, rhv:Float) -> SCNVector3 {
    return SCNVector3(lhv.x - rhv, lhv.y - rhv, lhv.z - rhv)
}
func /(lhv:SCNVector3, rhv:Float) -> SCNVector3 {
    return SCNVector3(lhv.x / rhv, lhv.y / rhv, lhv.z / rhv)
}
func *(lhv:SCNMatrix4, rhv:SCNVector3) -> SCNVector3 {
    let x = lhv.m11 * rhv.x + lhv.m12 * rhv.y + lhv.m13 * rhv.z
    let y = lhv.m21 * rhv.x + lhv.m22 * rhv.y + lhv.m23 * rhv.z
    let z = lhv.m31 * rhv.x + lhv.m32 * rhv.y + lhv.m33 * rhv.z
    return SCNVector3(x, y, z)
}
extension SCNVector3 {
    func length () -> Float {
        return (x * x + y * y + z * z).squareRoot()
    }
    mutating func norm() {
        let n = self / length()
        self.x = n.x
        self.y = n.y
        self.z = n.z
    }
    static func crossProduct(lhv:SCNVector3, rhv:SCNVector3) -> SCNVector3 {
        var ret = SCNVector3()
        ret.x = lhv.y * rhv.z - lhv.z * rhv.y
        ret.y = lhv.z * rhv.x - lhv.x * rhv.z
        ret.z = lhv.x * rhv.y - lhv.y * rhv.x
        return ret
    }
    static func scalarProduct(lhv:SCNVector3, rhv:SCNVector3) -> Float {
        return lhv.x * rhv.x + lhv.y * rhv.y + lhv.z * rhv.z
    }
}
extension SCNMatrix4 {
    func trans() -> SCNMatrix4 {
        var ret = SCNMatrix4()
        ret.m11 = self.m11
        ret.m12 = self.m21
        ret.m13 = self.m31
        ret.m14 = self.m41
        ret.m21 = self.m12
        ret.m22 = self.m22
        ret.m23 = self.m32
        ret.m24 = self.m42
        ret.m31 = self.m13
        ret.m32 = self.m23
        ret.m33 = self.m33
        ret.m34 = self.m43
        ret.m41 = self.m14
        ret.m42 = self.m24
        ret.m43 = self.m34
        ret.m44 = self.m44
        return ret
    }
    static func getSCNMatrix(X:SCNVector3, Y:SCNVector3, Z:SCNVector3) -> SCNMatrix4{
        var ret = SCNMatrix4()
        ret.m11 = X.x
        ret.m21 = X.y
        ret.m31 = X.z
        ret.m41 = 0
        ret.m12 = Y.x
        ret.m22 = Y.y
        ret.m32 = Y.z
        ret.m42 = 0
        ret.m13 = Z.x
        ret.m23 = Z.y
        ret.m33 = Z.z
        ret.m43 = 0
        ret.m14 = 0
        ret.m24 = 0
        ret.m34 = 0
        ret.m44 = 0
        return ret
    }
}
