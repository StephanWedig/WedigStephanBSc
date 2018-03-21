//
//  ViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 09.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: GeneralViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var addButton: UIButton!
    private let navARBottomBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    private let navARBottomItem = UINavigationItem(title: "");
    
    private let butSelect = UIBarButtonItem(image: UIImage(named: "iconmonstr-square-6-32"), style: .done, target: self, action: #selector(butSelect_Click(_:)))
    private let butAddSensor = UIBarButtonItem(image: UIImage(named: "iconmonstr-plus-4-32"), style: .done, target: self, action: #selector(butAddSensor_Click(_:)))
    private let butSetOrientationPoint = UIBarButtonItem(image: UIImage(named: "iconmonstr-crosshair-4-32"), style: .done, target: self, action: #selector(butOrientationPoint_Click(_:)))
    
    enum editLevel { case addSensor
        case setOrientationPoint
        case select
        case unknown
    }
    var orientationNodeColor = [UIColor]()
    var calcNodeColor = [UIColor]()
    let configuration = ARWorldTrackingConfiguration()
    let SPHERESIZE = 0.05
    var _orientationMiddleNode:SCNNode? = nil
    var _orientationXNode:SCNNode? = nil
    var _orientationYNode:SCNNode? = nil
    var _calcNodes = [SCNNode]()
    var _editLevel : editLevel = editLevel.unknown
    var _cntOrientationNodes:Int = 0
    override func viewDidLoad() {
        enumViewController = GlobalInfos.ViewControllers.AR
        super.viewDidLoad()
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        configuration.planeDetection = ARWorldTrackingConfiguration.PlaneDetection.horizontal
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: ARSession.RunOptions.resetTracking)
        sceneView.automaticallyUpdatesLighting = true
        navARBottomBar.isHidden = true
        calcNodeColor.append(UIColor.red)
        calcNodeColor.append(UIColor.brown)
        calcNodeColor.append(UIColor.green)
        calcNodeColor.append(UIColor.orange)
        
        orientationNodeColor.append(UIColor.cyan)
        orientationNodeColor.append(UIColor.blue)
        orientationNodeColor.append(UIColor.gray)
        let margins = self.view.layoutMarginsGuide
        navARBottomBar.backgroundColor = nil
        self.view.addSubview(navARBottomBar);
        navARBottomBar.translatesAutoresizingMaskIntoConstraints = false
        navARBottomBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        navARBottomBar.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -50).isActive = true
        navARBottomBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        navARBottomBar.setItems([navARBottomItem], animated: false);
        navARBottomItem.leftBarButtonItems = [butSetOrientationPoint, butAddSensor]
        navARBottomItem.rightBarButtonItems = [butSelect]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gl = GlobalInfos.getInstance()
        if !gl.getIsEditing() {
            return
        }
        guard let touch = touches.first else {return}
        let result = sceneView.hitTest(touch.location(in: sceneView), types:[ARHitTestResult.ResultType.featurePoint])
        guard let hitResult = result.last else {return}
        let hitTransform = hitResult.worldTransform
        let hitVector = SCNVector3Make(hitTransform.columns.3.x, hitTransform.columns.3.y, hitTransform.columns.3.z)
        let actRoom = GlobalInfos.getInstance().getActRoom()
        switch _editLevel {
        case editLevel.addSensor:
            if(actRoom?.getOrientationMiddleNode() == nil) {
                return
            }
            let node = SCNNode()
            node.geometry = SCNSphere(radius: CGFloat(SPHERESIZE))
            node.geometry?.firstMaterial?.diffuse.contents = calcNodeColor[(actRoom?.getSensors().count)! % calcNodeColor.count]
            node.position = hitVector - (actRoom?.getOrientationMiddleNode()?.position)!
            actRoom?.getOrientationMiddleNode()?.addChildNode(node)
            let s = Sensor(position: node.position, room: actRoom!)
            s.setNode(node: node)
            actRoom?.addSensor(sensor: s)
            break
        case editLevel.setOrientationPoint:
            let rootNode = SCNNode()
            rootNode.geometry = SCNSphere(radius: CGFloat(SPHERESIZE * 2))
            rootNode.position = hitVector
            rootNode.geometry?.firstMaterial?.diffuse.contents = orientationNodeColor[_cntOrientationNodes]
            switch _cntOrientationNodes {
            case 0:
                if actRoom?.getOrientationMiddleNode() != nil {
                    actRoom?.getOrientationMiddleNode()?.removeFromParentNode()
                }
                actRoom?.setOrientationMiddleNode(node: rootNode)
                _orientationMiddleNode?.removeFromParentNode()
                _orientationMiddleNode = rootNode
                break
            case 1:
                if actRoom?.getOrientationXNode() != nil {
                    actRoom?.getOrientationXNode()?.removeFromParentNode()
                }
                actRoom?.setOrientationXNode(node: rootNode)
                _orientationXNode?.removeFromParentNode()
                _orientationXNode = rootNode
                break
            case 2:
                if actRoom?.getOrientationYNode() != nil {
                    actRoom?.getOrientationYNode()?.removeFromParentNode()
                }
                actRoom?.setOrientationYNode(node: rootNode)
                _orientationYNode?.removeFromParentNode()
                _orientationYNode = rootNode
                break
            default:
                break
            }
            _cntOrientationNodes = (_cntOrientationNodes + 1) % 3
            //https://www.uninformativ.de/bin/SpaceSim-2401fee.pdf
            if _orientationMiddleNode != nil && _orientationXNode != nil && _orientationYNode != nil {
                let XTube = SCNNode()
                XTube.geometry = SCNTube(innerRadius: 0, outerRadius: 0.01, height: 1)
                XTube.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
                XTube.position = (_orientationMiddleNode?.position)!
                var disX = (_orientationXNode?.position)! - (_orientationMiddleNode?.position)!
                var disY = (_orientationYNode?.position)! - (_orientationMiddleNode?.position)!
                disX.norm()
                disY.norm()
                print(disX)
                var disZ = SCNVector3.crossProduct(lhv: disX, rhv: disY)
                disZ.norm()
                disY = SCNVector3.crossProduct(lhv: disX, rhv: disZ)
                disY.norm()
                for s in (actRoom?.getSensors())! {
                    let sensor = s as! Sensor
                    sensor.setXVector(v: disX)
                    sensor.setYVector(v: disY)
                    sensor.setZVector(v: disZ)
                }
            }
            sceneView.scene.rootNode.addChildNode(rootNode)
            resetSensors()
            refreshHiddenButton()
            break
        case editLevel.select:
            var nearest:Sensor? = nil
            for s in (actRoom?.getSensors())! {
                let sensor = s as! Sensor
                let disVector = ((sensor.getNode()?.position)! - hitVector)
                let dis = (disVector.x * disVector.x + disVector.y * disVector.y).squareRoot()
                print(String(dis))
                if dis < 0.4 {
                    if nearest == nil {
                        nearest = sensor
                    } else {
                        let disVectorNearest = ((nearest?.getNode()?.position)! - hitVector)
                        let disNearest = (disVectorNearest.x * disVectorNearest.x + disVectorNearest.y * disVectorNearest.y).squareRoot()
                        if dis < disNearest {
                            nearest = sensor
                        }
                    }
                }
            }
            if nearest != nil {
                nearest?.invertSelection()
            }
            break
        default:
            break
        }
    }
    @IBAction func butAddSensor_Click(_ sender: Any) {
        _editLevel = editLevel.addSensor
    }
    @IBAction func butOrientationPoint_Click(_ sender: Any) {
        _editLevel = editLevel.setOrientationPoint
    }
    @IBAction func butSelect_Click(_ sender: Any) {
        _editLevel = editLevel.select
    }
    func resetSensors() {
        let gl = GlobalInfos.getInstance()
        var i:Int = 0
        var rotationMatrix:SCNMatrix4
        for s in (gl.getActRoom()?.getSensors())! {
            
            let sensor = s as! Sensor
            sensor.getNode()?.removeFromParentNode()
            if _orientationMiddleNode != nil && _orientationXNode != nil && _orientationYNode != nil {
                if sensor.getX2Vector() != nil && sensor.getY2Vector() != nil && sensor.getZ2Vector() != nil {
                    //Rotiere
                    let mOrigX:SCNVector3! = sensor.getX1Vector()
                    let mOrigY:SCNVector3! = sensor.getY1Vector()
                    let mOrigZ:SCNVector3! = sensor.getZ1Vector()
                    let mOrig = SCNMatrix4.init(m11: mOrigX.x, m12: mOrigY.x, m13: mOrigZ.x, m14: 0, m21: mOrigX.y, m22: mOrigY.y, m23: mOrigZ.y, m24: 0, m31: mOrigX.z, m32: mOrigY.z, m33: mOrigZ.z, m34: 0, m41: 0, m42: 0, m43: 0, m44: 0)
                    let mNewX:SCNVector3! = sensor.getX2Vector()
                    let mNewY:SCNVector3! = sensor.getY2Vector()
                    let mNewZ:SCNVector3! = sensor.getZ2Vector()
                    //orthogonal matrix => invers matrix = transponet matrix
                    let mNew = SCNMatrix4.init(m11: mNewX.x, m12: mNewX.y, m13: mNewX.z, m14: 0, m21: mNewY.x, m22: mNewY.y, m23: mNewY.z, m24: 0, m31: mNewZ.x, m32: mNewZ.y, m33: mNewZ.z, m34: 0, m41: 0, m42: 0, m43: 0, m44: 0)
                    rotationMatrix = SCNMatrix4Mult(mNew, mOrig)
                } else {
                    rotationMatrix = SCNMatrix4.init(m11: 1, m12: 0, m13: 0, m14: 0, m21: 0, m22: 1, m23: 0, m24: 0, m31: 0, m32: 0, m33: 1, m34: 0, m41: 0, m42: 0, m43: 0, m44: 1)
                }
                let node = SCNNode()
                node.geometry = SCNSphere(radius: CGFloat(SPHERESIZE))
                node.geometry?.firstMaterial?.diffuse.contents = calcNodeColor[i % calcNodeColor.count]
                node.position = rotationMatrix * sensor.getPosition()
                sensor.setNode(node: node)
                gl.getActRoom()?.getOrientationMiddleNode()?.addChildNode(node)
                i = i + 1
            }
        }
    }
    func refreshHiddenButton() {
        butAddSensor.isEnabled = false
        let gl = GlobalInfos.getInstance()
        if gl.getIsEditing() {
            butAddSensor.isEnabled = (self._orientationMiddleNode != nil && self._orientationXNode != nil && self._orientationYNode != nil)
        }
    }
    func getAbs(value : Float) -> Float {
        if(value < 0) {
            return value * -1
        }
        return value
    }
    public override func refresh() {
        super.refresh()
        let gl = GlobalInfos.getInstance()
        UIView.animate(withDuration: 0.3, animations: {
            self.navARBottomBar.isHidden = !gl.getIsEditing()
            self.view.layoutIfNeeded()
        })
        refreshHiddenButton()
        navTopItem.title = gl.getActRoom()?.toHeadingString()
        _orientationMiddleNode?.removeFromParentNode()
        _orientationMiddleNode = gl.getActRoom()?.getOrientationMiddleNode()
        if _orientationMiddleNode != nil {
            sceneView.scene.rootNode.addChildNode(_orientationMiddleNode!)
        }
        _orientationXNode?.removeFromParentNode()
        _orientationXNode = gl.getActRoom()?.getOrientationXNode()
        if _orientationXNode != nil {
            sceneView.scene.rootNode.addChildNode(_orientationXNode!)
        }
        _orientationYNode?.removeFromParentNode()
        _orientationYNode = gl.getActRoom()?.getOrientationYNode()
        if _orientationYNode != nil {
            sceneView.scene.rootNode.addChildNode(_orientationYNode!)
        }
        if _orientationMiddleNode != nil && _orientationXNode != nil && _orientationYNode != nil {
            resetSensors()
        }
    }
}
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
}

