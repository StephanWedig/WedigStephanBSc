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
    var rootNode:SCNNode? = nil
    var calcNodes = [SCNNode]()
    var isFirstNode = true
    var _editLevel : editLevel = editLevel.noEdit
    var editingType = 0
    var sensorArray = [SCNNode]()
    override func viewDidLoad() {
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
            self.resetSensors()
        }
        let noAction = UIAlertAction(title: "No", style: .destructive) { (alert: UIAlertAction!) -> Void in
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion:nil)
    }
    func resetSensors() {
        for node in sensorArray {
            node.removeFromParentNode()
        }
        sensorArray = [SCNNode]()
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
        if editingType == 0 {
            return
        }
        guard let touch = touches.first else {return}
        let result = sceneView.hitTest(touch.location(in: sceneView), types:[ARHitTestResult.ResultType.featurePoint])
        guard let hitResult = result.last else {return}
        let hitTransform = hitResult.worldTransform
        let hitVector = SCNVector3Make(hitTransform.columns.3.x, hitTransform.columns.3.y, hitTransform.columns.3.z)
        switch editingType {
        case 1:
            if(rootNode == nil) {
                return
            }
            let node = SCNNode()
            node.geometry = SCNSphere(radius: CGFloat(SPHERESIZE))
            node.geometry?.firstMaterial?.diffuse.contents = calcNodeColor
            node.position = hitVector - (rootNode?.position)!
            rootNode?.addChildNode(node)
            sensorArray.append(node)
            let gl = GlobalInfos.getInstance()
            let s = Sensor(position: node.position)
            gl.getActRoom()?.addSensor(sensor: s)
            break
        case 2:
            if rootNode != nil {
                rootNode?.removeFromParentNode()
            }
            rootNode = SCNNode()
            rootNode?.geometry = SCNSphere(radius: CGFloat(SPHERESIZE * 2))
            rootNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
            rootNode?.position = hitVector
            for node in sensorArray {
                rootNode?.addChildNode(node)
            }
            sceneView.scene.rootNode.addChildNode(rootNode!)
            refreshHiddenButton()
            isFirstNode = false
            break
        default:
            break
        }
    }
    @IBAction func butEdit_Click(_ sender: Any) {
        editingType = 0
        if(_editLevel == editLevel.noEdit) {
            _editLevel = editLevel.editNoPositionLevel
        } else {
            _editLevel = editLevel.noEdit
        }
        refreshHiddenButton()
    }
    @IBAction func butAddSensor_Click(_ sender: Any) {
        editingType = 1
        editingTypeChanged()
    }
    @IBAction func butOrientationPoint_Click(_ sender: Any) {
        editingType = 2
        editingTypeChanged()
    }
    func editingTypeChanged() {
        butAddSensor.backgroundColor = UIColor.lightGray
        butOrientationPoint.backgroundColor = UIColor.lightGray
        switch editingType {
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
        StackViewEdit.isHidden = !(_editLevel == editLevel.editNoPositionLevel || (_editLevel == editLevel.editPointPositioning))
        //StackViewPointSet.isHidden = !(_editLevel == editLevel.editPointPositioning)
        butAddSensor.isHidden = rootNode == nil
        butClearSensor.isHidden = rootNode == nil
    }
    func getAbs(value : Float) -> Float {
        if(value < 0) {
            return value * -1
        }
        return value
    }
    public override func refresh() {
        super.refresh()
        navTopItem.title = GlobalInfos.getInstance().getActRoom()?.toString()
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
