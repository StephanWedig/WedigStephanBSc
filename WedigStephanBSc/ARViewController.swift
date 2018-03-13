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
    let calcNodeColor = UIColor.red
    let configuration = ARWorldTrackingConfiguration()
    let SPHERESIZE = 0.05
    var _orientationMiddleNode:SCNNode? = nil
    var _orientationXNode:SCNNode? = nil
    var _orientationYNode:SCNNode? = nil
    var _calcNodes = [SCNNode]()
    //var _isFirstNode = true
    var _editLevel : editLevel = editLevel.noEdit
    var _editingType = 0
    var _sensorArray = [SCNNode]()
    var _cntOrientationNodes:Int = 0
    override func viewDidLoad() {
        enumViewController = GlobalInfos.ViewControllers.AR
        super.viewDidLoad()
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(configuration)
        StackViewEdit.isHidden = true
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
            node.geometry?.firstMaterial?.diffuse.contents = calcNodeColor
            node.position = hitVector - (actRoom?.getOrientationMiddleNode()?.position)!
            actRoom?.getOrientationMiddleNode()?.addChildNode(node)
            _sensorArray.append(node)
            let s = Sensor(position: node.position)
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
                print(_orientationMiddleNode == nil)
                print(_orientationXNode == nil)
                print(_orientationYNode == nil)
                break
            case 1:
                if actRoom?.getOrientationXNode() != nil {
                    actRoom?.getOrientationXNode()?.removeFromParentNode()
                }
                actRoom?.setOrientationXNode(node: rootNode)
                _orientationXNode = rootNode
                print(_orientationMiddleNode == nil)
                print(_orientationXNode == nil)
                print(_orientationYNode == nil)
                break
            case 2:
                if actRoom?.getOrientationYNode() != nil {
                    actRoom?.getOrientationYNode()?.removeFromParentNode()
                }
                actRoom?.setOrientationYNode(node: rootNode)
                _orientationYNode = rootNode
                print(_orientationMiddleNode == nil)
                print(_orientationXNode == nil)
                print(_orientationYNode == nil)
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
                //XTube.rotation = SCNVector4(disX.x, disX.y, disX.z, 0)
                //XTube.eulerAngles = disX
                //XTube.rotation = SCNVector4(disX.x,disX.y,disX.z, Float.pi)
                XTube.rotate(by: SCNQuaternion(disX.x, disX.y, disX.z, 1), aroundTarget: (_orientationMiddleNode?.position)!)
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
                sceneView.scene.rootNode.addChildNode(ZTube)
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
    @IBAction func butEdit_Click(_ sender: Any) {
        _editingType = 0
        if(_editLevel == editLevel.noEdit) {
            _editLevel = editLevel.editNoPositionLevel
        } else {
            _editLevel = editLevel.noEdit
        }
        refreshHiddenButton()
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
        _sensorArray = [SCNNode]()
        for s in (gl.getActRoom()?.getSensors())! {
            let sensor = s as! Sensor
            let node = SCNNode()
            node.geometry = SCNSphere(radius: CGFloat(SPHERESIZE))
            node.geometry?.firstMaterial?.diffuse.contents = calcNodeColor
            node.position = sensor.getPosition()
            _sensorArray.append(node)
            gl.getActRoom()?.getOrientationMiddleNode()?.addChildNode(node)
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
        print("refreshHiddenButton")
        UIView.animate(withDuration: 0.3, animations: {
            self.StackViewEdit.isHidden = !(self._editLevel == editLevel.editNoPositionLevel || (self._editLevel == editLevel.editPointPositioning))
            //StackViewPointSet.isHidden = !(_editLevel == editLevel.editPointPositioning)
            self.butAddSensor.isHidden = self._orientationMiddleNode == nil || self._orientationXNode == nil || self._orientationYNode == nil
            self.butClearSensor.isHidden = self._orientationMiddleNode == nil || self._orientationXNode == nil || self._orientationYNode == nil
            print("refreshHiddenButton")
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
