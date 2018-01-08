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
    @IBOutlet weak var StackViewPointSet: UIStackView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var addButton: UIButton!
    enum editLevel { case noEdit
        case editNoPositionLevel
        case editPointPositioning
    }
    let orientationNodeColor = UIColor.cyan
    let sensorColor = UIColor.black
    /*let bestFitColor = UIColor.yellow
    let avgColor = UIColor.green*/
    let calcNodeColor = UIColor.red
    let configuration = ARWorldTrackingConfiguration()
    let SPHERESIZE = 0.05
    var rootNode:SCNNode? = nil
    //var avgNode:SCNNode? = nil
    var calcNodes = [SCNNode]()
    //var bestFitNode:SCNNode? = nil
    var isFirstNode = true
    var _editLevel : editLevel = editLevel.noEdit
    var editingType = 0
    var sensorArray = [SCNNode]()
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(configuration)
        StackViewEdit.isHidden = true
        StackViewPointSet.isHidden = true
        /*avgNode = SCNNode()
        avgNode?.geometry = SCNSphere(radius: CGFloat(SPHERESIZE))
        avgNode?.geometry?.firstMaterial?.diffuse.contents = avgColor
        bestFitNode = SCNNode()
        bestFitNode?.geometry = SCNSphere(radius: CGFloat(SPHERESIZE))
        bestFitNode?.geometry?.firstMaterial?.diffuse.contents = bestFitColor*/
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
        //if( editingType == 1) {
            node.position = hitVector - (rootNode?.position)!
            rootNode?.addChildNode(node)
            sensorArray.append(node)
            let gl = GlobalInfos.getInstance()
            let s = Sensor(position: node.position)
            gl.getActRoom()?.addSensor(sensor: s)
        /*} else {
            node.position = hitVector
            sceneView.scene.rootNode.addChildNode(node)
        }
            calcNodes.append(node)
        avgNodeCalc()
        bestFitNodeCalc()*/
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
    @IBAction func butAbortCalculation_Click(_ sender: Any) {
        //resetCalcNodes()
    }
    @IBAction func butAVGCalc_Click(_ sender: Any) {
        /*addNode(nNode: avgNode!)
        avgNode?.removeFromParentNode()*/
    }
    @IBAction func butBestFit_Click(_ sender: Any) {
        /*addNode(nNode: bestFitNode!)
        bestFitNode?.removeFromParentNode()*/
    }
    /*func addNode( nNode : SCNNode ) {
        resetCalcNodes()
        let newNode = SCNNode()
        newNode.position = nNode.position
        if(editingType == 1) {
            newNode.geometry = SCNSphere(radius: CGFloat(SPHERESIZE))
            newNode.geometry?.firstMaterial?.diffuse.contents = sensorColor
            rootNode?.addChildNode(newNode)
            sensorArray.append(newNode)
        } else {
            if rootNode != nil {
                rootNode?.removeFromParentNode()
            }
            newNode.geometry = SCNSphere(radius: CGFloat(SPHERESIZE * 2))
            newNode.geometry?.firstMaterial?.diffuse.contents = orientationNodeColor
            rootNode = newNode
            for node in sensorArray {
                rootNode?.addChildNode(node)
            }
            sceneView.scene.rootNode.addChildNode(rootNode!)
            refreshHiddenButton()
            isFirstNode = false
        }
    }*/
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
    /*func avgNodeCalc() {
        avgNode?.removeFromParentNode()
        var avgX : Float = 0
        var avgY : Float = 0
        var avgZ : Float = 0
        for node in calcNodes {
            avgX = avgX + node.position.x
            avgY = avgY + node.position.y
            avgZ = avgZ + node.position.z
        }
        avgX = avgX / Float(calcNodes.count)
        avgY = avgY / Float(calcNodes.count)
        avgZ = avgZ / Float(calcNodes.count)
        avgNode?.position = SCNVector3Make(avgX, avgY, avgZ)
        if(editingType == 1) {
            rootNode?.addChildNode(avgNode!)
        } else {
            sceneView.scene.rootNode.addChildNode(avgNode!)
        }
    }
    func bestFitNodeCalc() {
        if(calcNodes.count < 3) {
            return
        }
        bestFitNode?.removeFromParentNode()
        var completeX : Float = 0
        var completeY : Float = 0
        var completeZ : Float = 0
        for node in calcNodes {
            completeX = completeX + node.position.x
            completeY = completeY + node.position.y
            completeZ = completeZ + node.position.z
        }
        let avgX = completeX / Float(calcNodes.count)
        let avgY = completeY / Float(calcNodes.count)
        let avgZ = completeZ / Float(calcNodes.count)
        var maxDiffX : Float = 0
        var maxDiffY : Float = 0
        var maxDiffZ : Float = 0
        for node in calcNodes {
            if getAbs(value: maxDiffX) < getAbs(value: avgX - node.position.x) {
                maxDiffX = avgX - node.position.x
            }
            if getAbs(value: maxDiffY) < getAbs(value: avgY - node.position.y) {
                maxDiffY = avgY - node.position.y
            }
            if getAbs(value: maxDiffZ) < getAbs(value: avgZ - node.position.z) {
                maxDiffZ = avgZ - node.position.z
            }
        }
        bestFitNode?.position = SCNVector3Make((completeX - (avgX - maxDiffX)) / Float(calcNodes.count - 1), (completeY - (avgY - maxDiffY)) / Float(calcNodes.count - 1), (completeZ - (avgZ -  maxDiffZ)) / Float(calcNodes.count - 1))
        if(editingType == 1) {
            rootNode?.addChildNode(bestFitNode!)
        } else {
            sceneView.scene.rootNode.addChildNode(bestFitNode!)
        }
    }*/
    func getAbs(value : Float) -> Float {
        if(value < 0) {
            return value * -1
        }
        return value
    }
    /*func resetCalcNodes() {
        for node in calcNodes {
            node.removeFromParentNode()
        }
        calcNodes = [SCNNode]()
        avgNode?.removeFromParentNode()
        bestFitNode?.removeFromParentNode()
    }*/
    public override func refresh() {
        super.refresh()
        navItem.title = GlobalInfos.getInstance().getActRoom()?.toString()
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
