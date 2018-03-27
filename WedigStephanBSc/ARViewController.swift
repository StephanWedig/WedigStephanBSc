//
//  ViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 09.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: GeneralViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var ViewSensor: UIStackView!
    @IBOutlet weak var butSensorType: UIButton!
    @IBOutlet weak var pickerSensorType: UIPickerView!
    
    private let navARBottomBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    private let navARBottomItem = UINavigationItem(title: "");
    
    private var butSelect = UIBarButtonItem(image: UIImage(named: "iconmonstr-square-6-32"), style: .done, target: self, action: #selector(butSelect_Click(_:)))
    private var butAddSensor = UIBarButtonItem(image: UIImage(named: "iconmonstr-plus-4-32"), style: .done, target: self, action: #selector(butAddSensor_Click(_:)))
    private var butSetOrientationPoint = UIBarButtonItem(image: UIImage(named: "iconmonstr-crosshair-4-32"), style: .done, target: self, action: #selector(butOrientationPoint_Click(_:)))
    private var butReposition = UIBarButtonItem(image: UIImage(named: "iconmonstr-crosshair-7-32"), style: .done, target: self, action: #selector(butReposition_Click(_:)))
    private var bottomBarItemArray = [UIBarButtonItem]()
    
    enum editLevel { case addSensor
        case setOrientationPoint
        case select
        case reposition
        case unknown
    }
    var orientationNodeColor = [UIColor]()
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
        
        butAR.customView?.backgroundColor = GlobalInfos.selectedButtonBackgroundColor
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
        
        orientationNodeColor.append(UIColor.cyan)
        orientationNodeColor.append(UIColor.blue)
        orientationNodeColor.append(UIColor.gray)
        
        //create editing buttons
        var but = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        but.layer.cornerRadius = but.frame.size.width/2
        but.setImage(UIImage(named: "iconmonstr-square-6-32"), for: UIControlState.normal)
        but.addTarget(self, action: #selector(butSelect_Click(_:)), for: .touchUpInside)
        butSelect = UIBarButtonItem(customView: but)
        bottomBarItemArray.append(butSelect)
        but = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        but.layer.cornerRadius = but.frame.size.width/2
        but.setImage(UIImage(named: "iconmonstr-plus-4-32"), for: UIControlState.normal)
        but.addTarget(self, action: #selector(butAddSensor_Click(_:)), for: .touchUpInside)
        butAddSensor = UIBarButtonItem(customView: but)
        bottomBarItemArray.append(butAddSensor)
        but = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        but.layer.cornerRadius = but.frame.size.width/2
        but.setImage(UIImage(named: "iconmonstr-crosshair-4-32"), for: UIControlState.normal)
        but.addTarget(self, action: #selector(butOrientationPoint_Click(_:)), for: .touchUpInside)
        butSetOrientationPoint = UIBarButtonItem(customView: but)
        bottomBarItemArray.append(butSetOrientationPoint)
        but = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        but.layer.cornerRadius = but.frame.size.width/2
        but.setImage(UIImage(named: "iconmonstr-crosshair-7-32"), for: UIControlState.normal)
        but.addTarget(self, action: #selector(butReposition_Click(_:)), for: .touchUpInside)
        butReposition = UIBarButtonItem(customView: but)
        butReposition.isEnabled = false
        bottomBarItemArray.append(butReposition)
        
        //build editing bar
        let margins = self.view.layoutMarginsGuide
        navARBottomBar.backgroundColor = nil
        self.view.addSubview(navARBottomBar);
        navARBottomBar.translatesAutoresizingMaskIntoConstraints = false
        navARBottomBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        navARBottomBar.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -50).isActive = true
        navARBottomBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        navARBottomBar.setItems([navARBottomItem], animated: false);
        navARBottomItem.leftBarButtonItems = [butSetOrientationPoint, butAddSensor]
        navARBottomItem.rightBarButtonItems = [butReposition, butSelect]
        
        pickerSensorType.delegate = self
        pickerSensorType.dataSource = self
        
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
        guard let actRoom = GlobalInfos.getInstance().getActRoom() else {return}
        switch _editLevel {
        case editLevel.addSensor:
            if actRoom.getOrientationMiddleNode() == nil {
                return
            }
            deselectAllSensors()
            let node = SCNNode()
            node.geometry = SCNSphere(radius: CGFloat(SPHERESIZE))
            node.geometry?.firstMaterial?.diffuse.contents = gl.calcNodeColor[actRoom.getSensors().count % gl.calcNodeColor.count]
            node.position = hitVector - (actRoom.getOrientationMiddleNode()?.position)!
            actRoom.getOrientationMiddleNode()?.addChildNode(node)
            let s = Sensor(position: node.position, room: actRoom)
            s.setNode(node: node)
            s.setColor(color: gl.calcNodeColor[actRoom.getSensors().count % gl.calcNodeColor.count])
            actRoom.addSensor(sensor: s)
            calcSensorVector(sensor: s)
            let rotationMatrix = SCNMatrix4.getSCNMatrix(X: s.getX1Vector()!,Y: s.getY1Vector()!, Z: s.getZ1Vector()!).trans()
            s.setPosition(pos: rotationMatrix * s.getPosition())
            s.setIsSelected(isSelected: true)
            setViewSensorVisible(hidden: false)
            break
        case editLevel.setOrientationPoint:
            let rootNode = SCNNode()
            rootNode.geometry = SCNSphere(radius: CGFloat(SPHERESIZE * 2))
            rootNode.position = hitVector
            rootNode.geometry?.firstMaterial?.diffuse.contents = orientationNodeColor[_cntOrientationNodes]
            switch _cntOrientationNodes {
            case 0:
                if actRoom.getOrientationMiddleNode() != nil {
                    actRoom.getOrientationMiddleNode()?.removeFromParentNode()
                }
                actRoom.setOrientationMiddleNode(node: rootNode)
                _orientationMiddleNode?.removeFromParentNode()
                _orientationMiddleNode = rootNode
                break
            case 1:
                if actRoom.getOrientationXNode() != nil {
                    actRoom.getOrientationXNode()?.removeFromParentNode()
                }
                actRoom.setOrientationXNode(node: rootNode)
                _orientationXNode?.removeFromParentNode()
                _orientationXNode = rootNode
                break
            case 2:
                if actRoom.getOrientationYNode() != nil {
                    actRoom.getOrientationYNode()?.removeFromParentNode()
                }
                actRoom.setOrientationYNode(node: rootNode)
                _orientationYNode?.removeFromParentNode()
                _orientationYNode = rootNode
                break
            default:
                break
            }
            _cntOrientationNodes = (_cntOrientationNodes + 1) % orientationNodeColor.count
            calcSensorVector(sensor: nil)
            sceneView.scene.rootNode.addChildNode(rootNode)
            resetSensors()
            refreshHiddenButton()
            break
        case editLevel.select:
            let result = sceneView.hitTest(touch.location(in: sceneView), options: nil).first
            /*if result == nil {
                setViewSensorVisible(hidden: true)
                return
            }*/
            var found :Bool = false
            for s in actRoom.getSensors() {
                let sensor = s as! Sensor
                if(sensor.getID() == result?.node.name) {
                    sensor.invertSelection()
                    setViewSensorVisible(hidden: !sensor.getIsSelected())
                    butReposition.isEnabled = sensor.getIsSelected()
                    found = true
                } else {
                    sensor.setIsSelected(isSelected: false)
                }
            }
            if !found {
                setViewSensorVisible(hidden: true)
                butReposition.isEnabled = false
            }
            break
        case editLevel.reposition:
            var sensor:Sensor? = nil
            for s in actRoom.getSensors() {
                let s2 = s as! Sensor
                if s2.getIsSelected() {
                    sensor = s2
                    break
                }
            }
            if sensor == nil {
                return
            }
            sensor?.getNode()?.position = hitVector - (actRoom.getOrientationMiddleNode()?.position)!
            sensor?.nilVectors()
            calcSensorVector(sensor: sensor)
            let rotationMatrix = SCNMatrix4.getSCNMatrix(X: (sensor?.getX1Vector())!,Y: (sensor?.getY1Vector())!, Z: (sensor?.getZ1Vector())!).trans()
            sensor?.setPosition(pos: rotationMatrix * (sensor?.getPosition())!)
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
        deselectAllSensors()
        unmarkedBottomBarItems()
        butAddSensor.customView?.backgroundColor = GlobalInfos.selectedButtonBackgroundColor
    }
    @IBAction func butOrientationPoint_Click(_ sender: Any) {
        _editLevel = editLevel.setOrientationPoint
        deselectAllSensors()
        unmarkedBottomBarItems()
        butSetOrientationPoint.customView?.backgroundColor = GlobalInfos.selectedButtonBackgroundColor
    }
    @IBAction func butSelect_Click(_ sender: Any) {
        _editLevel = editLevel.select
        unmarkedBottomBarItems()
        butSelect.customView?.backgroundColor = GlobalInfos.selectedButtonBackgroundColor
    }
    @IBAction func butReposition_Click(_ sender: Any) {
        _editLevel = editLevel.reposition
        unmarkedBottomBarItems()
        butReposition.customView?.backgroundColor = GlobalInfos.selectedButtonBackgroundColor
    }
    private func unmarkedBottomBarItems() {
        for but in bottomBarItemArray {
            but.customView?.backgroundColor = GlobalInfos.unselectedButtonBackgroundColor
        }
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
                if(sensor.getIsSelected()) {
                    node.geometry?.firstMaterial?.diffuse.contents = gl.selectedNodeColor
                } else {
                    node.geometry?.firstMaterial?.diffuse.contents = sensor.getColor()
                }
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
    func refreshSensorView() {
        let gl = GlobalInfos.getInstance()
        let actRoom = gl.getActRoom()
        for s in (actRoom?.getSensors())! {
            let sensor = s as! Sensor
            if(sensor.getIsSelected()) {
                if sensor.getSensortype() != nil {
                    butSensorType.setTitle(sensor.getSensortype().getDescription(), for: .normal)
                } else {
                    butSensorType.setTitle("Select a sensor type", for: .normal)
                }
                break
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GlobalInfos.getInstance().getSensorTypes().count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        swapPickerDescriptionVisible()
        let gl = GlobalInfos.getInstance()
        let actRoom = gl.getActRoom()
        for s in (actRoom?.getSensors())! {
            let sensor = s as! Sensor
            if(sensor.getIsSelected()) {
                sensor.setSensortype(sensortype: gl.getSensorTypes()[row] as! SensorType)
                break
            }
        }
        refreshSensorView()
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (GlobalInfos.getInstance().getSensorTypes()[row] as! SensorType).getDescription()
    }
    private func swapPickerDescriptionVisible () {
        setPickerDescriptionVisible(hidden: !self.pickerSensorType.isHidden)
    }
    private func setPickerDescriptionVisible(hidden:Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerSensorType.isHidden = hidden
            self.view.layoutIfNeeded()
        })
        refreshSensorView()
    }
    private func setViewSensorVisible(hidden:Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.ViewSensor.isHidden = hidden
            self.view.layoutIfNeeded()
        })
        ViewSensor.isHidden = hidden
        refreshSensorView()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    @IBAction func butSensorType_Click(_ sender: Any) {
        swapPickerDescriptionVisible()
    }
    private func deselectAllSensors() {
        let actRoom = GlobalInfos.getInstance().getActRoom()
        for s in (actRoom?.getSensors())! {
            let sensor = s as! Sensor
            sensor.setIsSelected(isSelected: false)
        }
        butReposition.isEnabled = false
        setViewSensorVisible(hidden: true)
    }
    @IBAction func butAccept_Click(_ sender: Any) {
        deselectAllSensors()
    }
    @IBAction func butDelete_Click(_ sender: Any) {
        guard let actRoom = GlobalInfos.getInstance().getActRoom() else {
            return
        }
        for s in actRoom.getSensors() {
            let sensor = s as! Sensor
            if sensor.getIsSelected() {
                let alert = UIAlertController(title: "Delete " + sensor.toString(), message: "Are you sure you want to delete " + sensor.toString() + "?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (alert: UIAlertAction!) -> Void in
                    sensor.getNode()?.removeFromParentNode()
                    actRoom.getSensors().remove(sensor)
                    actRoom.save()
                    self.setViewSensorVisible(hidden: true)
                }
                let noAction = UIAlertAction(title: "No", style: .destructive) { (alert: UIAlertAction!) -> Void in
                }
                
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                present(alert, animated: true, completion:nil)
                break
            }
        }
    }
}

