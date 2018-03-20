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
    struct myCameraCoordinates {
        var x = Float()
        var y = Float()
        var z = Float()
    }
    @IBOutlet weak var butClearSensor: UIButton!
    @IBOutlet weak var butAddSensor: UIButton!
    @IBOutlet weak var butOrientationPoint: UIButton!
    @IBOutlet weak var StackViewEdit: UIStackView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var addButton: UIButton!
    enum editLevel { case noEdit
        case editNoPositionLevel
        case editPointPositioning
    }
    let orientationNodeColor = UIColor.cyan
    let sensorColor = UIColor.black
    var calcNodeColor = [UIColor]()
    let configuration = ARWorldTrackingConfiguration()
    let SPHERESIZE = 0.05
    var _orientationMiddleNode:SCNNode? = nil
    var _orientationXNode:SCNNode? = nil
    var _orientationYNode:SCNNode? = nil
    var _calcNodes = [SCNNode]()
    var _editLevel : editLevel = editLevel.noEdit
    var _editingType = 0
    var _sensorArray = [SCNNode]()
    var _cntOrientationNodes:Int = 0
    var _rotationMatrix:SCNMatrix4 = SCNMatrix4.init(m11: 1, m12: 0, m13: 0, m14: 0, m21: 0, m22: 1, m23: 0, m24: 0, m31: 0, m32: 0, m33: 1, m34: 0, m41: 0, m42: 0, m43: 0, m44: 1)
    override func viewDidLoad() {
        enumViewController = GlobalInfos.ViewControllers.AR
        super.viewDidLoad()
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        configuration.planeDetection = ARWorldTrackingConfiguration.PlaneDetection.horizontal
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: ARSession.RunOptions.resetTracking)
        sceneView.automaticallyUpdatesLighting = true
        StackViewEdit.isHidden = true
        butAddSensor.isHidden = true
        butClearSensor.isHidden = true
        calcNodeColor.append(UIColor.red)
        calcNodeColor.append(UIColor.brown)
        calcNodeColor.append(UIColor.green)
        calcNodeColor.append(UIColor.orange)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func butClearSensor_Click(_ sender: Any) {
        let alert = UIAlertController(title: "Clear AR-View", message: "Are you sure you want to clear all points without the orientation point?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (alert: UIAlertAction!) -> Void in
            self.clearSensors()
        }
        let noAction = UIAlertAction(title: "No", style: .destructive) { (alert: UIAlertAction!) -> Void in
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion:nil)
    }
    func clearSensors() {
        for node in _sensorArray {
            node.removeFromParentNode()
        }
        _sensorArray = [SCNNode]()
    }
    func getCameraPosition() -> myCameraCoordinates {
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        var cc = myCameraCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z
        return cc
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if _editingType == 0 {
            return
        }
        guard let touch = touches.first else {return}
        let result = sceneView.hitTest(touch.location(in: sceneView), types:[ARHitTestResult.ResultType.featurePoint])
        guard let hitResult = result.last else {return}
        let hitTransform = hitResult.worldTransform
        let hitVector = SCNVector3Make(hitTransform.columns.3.x, hitTransform.columns.3.y, hitTransform.columns.3.z)
        let actRoom = GlobalInfos.getInstance().getActRoom()
        switch _editingType {
        case 1:
            if(actRoom?.getOrientationMiddleNode() == nil) {
                return
            }
            let node = SCNNode()
            node.geometry = SCNSphere(radius: CGFloat(SPHERESIZE))
            node.geometry?.firstMaterial?.diffuse.contents = calcNodeColor[(_sensorArray.count + 1) % calcNodeColor.count]
            node.position = hitVector - (actRoom?.getOrientationMiddleNode()?.position)!
            actRoom?.getOrientationMiddleNode()?.addChildNode(node)
            _sensorArray.append(node)
            let s = Sensor(position: node.position, room: actRoom!)
            actRoom?.addSensor(sensor: s)
            break
        case 2:
            let rootNode = SCNNode()
            rootNode.geometry = SCNSphere(radius: CGFloat(SPHERESIZE * 2))
            rootNode.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
            rootNode.position = hitVector
            print(_cntOrientationNodes)
            switch _cntOrientationNodes {
            case 0:
                if actRoom?.getOrientationMiddleNode() != nil {
                    actRoom?.getOrientationMiddleNode()?.removeFromParentNode()
                }
                actRoom?.setOrientationMiddleNode(node: rootNode)
                _orientationMiddleNode = rootNode
                break
            case 1:
                if actRoom?.getOrientationXNode() != nil {
                    actRoom?.getOrientationXNode()?.removeFromParentNode()
                }
                actRoom?.setOrientationXNode(node: rootNode)
                _orientationXNode = rootNode
                break
            case 2:
                if actRoom?.getOrientationYNode() != nil {
                    actRoom?.getOrientationYNode()?.removeFromParentNode()
                }
                actRoom?.setOrientationYNode(node: rootNode)
                _orientationYNode = rootNode
                break
            default:
                break
            }
            print(_cntOrientationNodes)
            _cntOrientationNodes = _cntOrientationNodes + 1
            //https://www.uninformativ.de/bin/SpaceSim-2401fee.pdf
            if _cntOrientationNodes == 3 {
                _cntOrientationNodes = 0
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
                actRoom?.setXVector(v: disX)
                actRoom?.setYVector(v: disY)
                actRoom?.setZVector(v: disZ)
                //XTube.rotation = SCNVector4(disX.x, disX.y, disX.z, 0)
                //XTube.eulerAngles = disX
                //XTube.rotation = SCNVector4(disX.x,disX.y,disX.z, Float.pi)
                /*XTube.rotate(by: SCNQuaternion(disX.x, disX.y, disX.z, 1), aroundTarget: (_orientationMiddleNode?.position)!)
                //XTube.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(Float.pi / 4), around: disX, duration: TimeInterval(10))))
                print(GLKMathDegreesToRadians(cosh(disX.x)))
                let YTube = SCNNode()
                YTube.geometry = SCNTube(innerRadius: 0, outerRadius: 0.01, height: 1)
                YTube.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                YTube.position = (_orientationMiddleNode?.position)!
                YTube.rotate(by: SCNQuaternion(disY.x, disY.y, disY.z, 1), aroundTarget: (_orientationMiddleNode?.position)!)
                let ZTube = SCNNode()
                ZTube.geometry = SCNTube(innerRadius: 0, outerRadius: 0.01, height: 1)
                ZTube.geometry?.firstMaterial?.diffuse.contents = UIColor.black
                ZTube.position = (_orientationMiddleNode?.position)!
                ZTube.rotate(by: SCNQuaternion(disZ.x, disZ.y, disZ.z, 1), aroundTarget: (_orientationMiddleNode?.position)!)
                sceneView.scene.rootNode.addChildNode(XTube)
                sceneView.scene.rootNode.addChildNode(YTube)
                sceneView.scene.rootNode.addChildNode(ZTube)*/
            }
            sceneView.scene.rootNode.addChildNode(rootNode)
            resetSensors()
            refreshHiddenButton()
            //_isFirstNode = false
            break
        default:
            break
        }
    }
    @IBAction func butAddSensor_Click(_ sender: Any) {
        _editingType = 1
        editingTypeChanged()
    }
    @IBAction func butOrientationPoint_Click(_ sender: Any) {
        _editingType = 2
        editingTypeChanged()
    }
    func resetSensors() {
        let gl = GlobalInfos.getInstance()
        for node in _sensorArray {
            node.removeFromParentNode()
        }
        
        let actRoom = GlobalInfos.getInstance().getActRoom()
        if actRoom?.getX2Vector() != nil && actRoom?.getY2Vector() != nil && actRoom?.getZ2Vector() != nil {
            //Rotiere
            let mOrigX:SCNVector3! = actRoom?.getX1Vector()
            let mOrigY:SCNVector3! = actRoom?.getY1Vector()
            let mOrigZ:SCNVector3! = actRoom?.getZ1Vector()
            let mOrig = SCNMatrix4.init(m11: mOrigX.x, m12: mOrigY.x, m13: mOrigZ.x, m14: 0, m21: mOrigX.y, m22: mOrigY.y, m23: mOrigZ.y, m24: 0, m31: mOrigX.z, m32: mOrigY.z, m33: mOrigZ.z, m34: 0, m41: 0, m42: 0, m43: 0, m44: 0)
            let mNewX:SCNVector3! = actRoom?.getX2Vector()
            let mNewY:SCNVector3! = actRoom?.getY2Vector()
            let mNewZ:SCNVector3! = actRoom?.getZ2Vector()
            //orthogonal matrix => invers matrix = transponet matrix
            let mNew = SCNMatrix4.init(m11: mNewX.x, m12: mNewX.y, m13: mNewX.z, m14: 0, m21: mNewY.x, m22: mNewY.y, m23: mNewY.z, m24: 0, m31: mNewZ.x, m32: mNewZ.y, m33: mNewZ.z, m34: 0, m41: 0, m42: 0, m43: 0, m44: 0)
            _rotationMatrix = SCNMatrix4Mult(mOrig, mNew)
        } else {
            _rotationMatrix = SCNMatrix4.init(m11: 1, m12: 0, m13: 0, m14: 0, m21: 0, m22: 1, m23: 0, m24: 0, m31: 0, m32: 0, m33: 1, m34: 0, m41: 0, m42: 0, m43: 0, m44: 1)
        }
        _sensorArray = [SCNNode]()
        var i:Int = 0
        for s in (gl.getActRoom()?.getSensors())! {
            let sensor = s as! Sensor
            let node = SCNNode()
            node.geometry = SCNSphere(radius: CGFloat(SPHERESIZE))
            node.geometry?.firstMaterial?.diffuse.contents = calcNodeColor[i % calcNodeColor.count]
            node.position = _rotationMatrix * sensor.getPosition()
            _sensorArray.append(node)
            gl.getActRoom()?.getOrientationMiddleNode()?.addChildNode(node)
            i = i + 1
        }
    }
    func editingTypeChanged() {
        butAddSensor.backgroundColor = UIColor.lightGray
        butOrientationPoint.backgroundColor = UIColor.lightGray
        switch _editingType {
        case 1:
            butAddSensor.backgroundColor = UIColor.blue
            break
        case 2:
            butOrientationPoint.backgroundColor = UIColor.blue
            break
        default:
            break
        }
        _editLevel = editLevel.editPointPositioning
        refreshHiddenButton()
    }
    func refreshHiddenButton() {
        UIView.animate(withDuration: 0.3, animations: {
            self.StackViewEdit.isHidden = !(self._editLevel == editLevel.editNoPositionLevel || (self._editLevel == editLevel.editPointPositioning))
            self.view.layoutIfNeeded()
        })
        UIView.animate(withDuration: 0.3, animations: {
            self.butClearSensor.isHidden = (self._orientationMiddleNode == nil || self._orientationXNode == nil || self._orientationYNode == nil)
            self.view.layoutIfNeeded()
        })
        UIView.animate(withDuration: 0.3, animations: {
            self.butAddSensor.isHidden = (self._orientationMiddleNode == nil || self._orientationXNode == nil || self._orientationYNode == nil)
            self.view.layoutIfNeeded()
        })
    }
    func getAbs(value : Float) -> Float {
        if(value < 0) {
            return value * -1
        }
        return value
    }
    public override func refresh() {
        super.refresh()
        _editingType = 0
        if GlobalInfos.getInstance().getIsEditing() {
            if _editLevel == editLevel.noEdit {
                _editLevel = editLevel.editNoPositionLevel
            }
        } else {
            _editLevel = editLevel.noEdit
        }
        refreshHiddenButton()
        let gl = GlobalInfos.getInstance()
        navTopItem.title = gl.getActRoom()?.toHeadingString()
        clearSensors()
        _orientationMiddleNode?.removeFromParentNode()
        _orientationMiddleNode = gl.getActRoom()?.getOrientationMiddleNode()
        if _orientationMiddleNode != nil {
            sceneView.scene.rootNode.addChildNode(_orientationMiddleNode!)
            resetSensors()
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

