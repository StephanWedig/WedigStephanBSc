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
        if #available(iOS 11.3, *) {
            configuration.planeDetection = [.horizontal, .vertical]
            print("11.3")
        } else {
            configuration.planeDetection = [.horizontal]
            print("11.2")
        }
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
        
        
        guard let camera = sceneView.pointOfView?.camera else {
            return
        }
        print("Camera")
        
        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
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
            calcSensorVector(sensor: s)
            let rotationMatrix = SCNMatrix4.getSCNMatrix(X: s.getX1Vector()!,Y: s.getY1Vector()!, Z: s.getZ1Vector()!).trans()
            s.setPosition(pos: rotationMatrix * s.getPosition())
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
            calcSensorVector(sensor: nil)
            sceneView.scene.rootNode.addChildNode(rootNode)
            resetSensors()
            refreshHiddenButton()
            break
        case editLevel.select:
            let results = sceneView.hitTest(touch.location(in: sceneView), options: nil)
            for s in (actRoom?.getSensors())! {
                let sensor = s as! Sensor
                sensor.setIsSelected(isSelected: false)
            }
            for r in results {
                for s in (actRoom?.getSensors())! {
                    let sensor = s as! Sensor
                    if(sensor.getNode() == r.node) {
                        sensor.invertSelection()
                        return
                    }
                }
            }
            break
        default:
            break
        }
    }
    private func calcSensorVector(sensor: Sensor?) {
        //https://www.uninformativ.de/bin/SpaceSim-2401fee.pdf
        let actRoom = GlobalInfos.getInstance().getActRoom()!
        if _orientationMiddleNode != nil && _orientationXNode != nil && _orientationYNode != nil {
            var disX = (_orientationMiddleNode?.position)! - (_orientationXNode?.position)!
            var disY = (_orientationMiddleNode?.position)! - (_orientationYNode?.position)!
            disX.norm()
            disY.norm()
            var disZ = SCNVector3.crossProduct(lhv: disX, rhv: disY)
            disZ.norm()
            disY = SCNVector3.crossProduct(lhv: disX, rhv: disZ)
            disY.norm()
            if sensor == nil {
                for s in actRoom.getSensors() {
                    let sensor = s as! Sensor
                    sensor.setXVector(v: disX)
                    sensor.setYVector(v: disY)
                    sensor.setZVector(v: disZ)
                }
            } else {
                sensor?.setXVector(v: disX)
                sensor?.setYVector(v: disY)
                sensor?.setZVector(v: disZ)
            }
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
        if gl.getActRoom()?.getOrientationMiddleNode() != nil {
            for node in (gl.getActRoom()?.getOrientationMiddleNode()?.childNodes)! {
                node.removeFromParentNode()
            }
        }
        for s in (gl.getActRoom()?.getSensors())! {
            let sensor = s as! Sensor
            if _orientationMiddleNode != nil && _orientationXNode != nil && _orientationYNode != nil {
                if sensor.getX2Vector() != nil && sensor.getY2Vector() != nil && sensor.getZ2Vector() != nil {
                    //Rotiere
                    let mOrigX:SCNVector3! = sensor.getX1Vector()
                    let mOrigY:SCNVector3! = sensor.getY1Vector()
                    let mOrigZ:SCNVector3! = sensor.getZ1Vector()
                    /*let mOrig = SCNMatrix4.init(m11: mOrigX.x, m12: mOrigY.x, m13: mOrigZ.x, m14: 0, m21: mOrigX.y, m22: mOrigY.y, m23: mOrigZ.y, m24: 0, m31: mOrigX.z, m32: mOrigY.z, m33: mOrigZ.z, m34: 0, m41: 0, m42: 0, m43: 0, m44: 0)*/
                    let mOrig = SCNMatrix4.getSCNMatrix(X: mOrigX, Y: mOrigY, Z: mOrigZ)
                    let mNewX:SCNVector3! = sensor.getX2Vector()
                    let mNewY:SCNVector3! = sensor.getY2Vector()
                    let mNewZ:SCNVector3! = sensor.getZ2Vector()
                    /*let angleX = acos(SCNVector3.scalarProduct(lhv: mOrigX, rhv: mNewX))
                    let angleY = acos(SCNVector3.scalarProduct(lhv: mOrigY, rhv: mNewY))
                    let angleZ = acos(SCNVector3.scalarProduct(lhv: mOrigZ, rhv: mNewZ))
                    print(angleX)
                    print(angleY)
                    print(angleZ)
                    let m11 = cos(angleY) * cos(angleZ)
                    let m12 = -cos(angleX) * sin(angleZ) + sin(angleX) * sin(angleY) * cos(angleZ)
                    let m13 = sin(angleX) * sin(angleZ) + cos(angleX) * sin(angleY) * cos(angleZ)
                    let m21 = cos(angleY) * sin(angleZ)
                    let m22 = cos(angleX) * cos(angleZ) + sin(angleX) * sin(angleY) * sin(angleZ)
                    let m23 = -sin(angleX) * cos(angleZ) + cos(angleX) * sin(angleY) * sin(angleZ)
                    let m31 = -sin(angleY)
                    let m32 = sin(angleX) * cos(angleY)
                    let m33 = cos(angleX) * cos(angleY)
                    rotationMatrix = SCNMatrix4.init(m11: m11, m12: m12, m13: m13, m14: 0, m21: m21, m22: m22, m23: m23, m24: 0, m31: m31, m32: m32, m33: m33, m34: 0, m41: 0, m42: 0, m43: 0, m44: 0)
                    print(rotationMatrix)*/
                    //orthogonal matrix => invers matrix = transponet matrix
                    /*let mNew = SCNMatrix4.init(m11: mNewX.x, m12: mNewX.y, m13: mNewX.z, m14: 0, m21: mNewY.x, m22: mNewY.y, m23: mNewY.z, m24: 0, m31: mNewZ.x, m32: mNewZ.y, m33: mNewZ.z, m34: 0, m41: 0, m42: 0, m43: 0, m44: 0)*/
                    let mNew = SCNMatrix4.getSCNMatrix(X: mNewX, Y: mNewY, Z: mNewZ).trans()
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
