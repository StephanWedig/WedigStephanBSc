//
//  SensorTypeListViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 06.03.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

public class SensorTypeListViewController : GeneralViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableSensorType: UITableView!
    public override func viewDidLoad() {
        enumViewController = GlobalInfos.ViewControllers.SensorTypeList
        super.viewDidLoad()
        tableSensorType.delegate = self
        tableSensorType.dataSource = self
        tableSensorType.rowHeight = UITableViewAutomaticDimension
        navTopItem.title = "Sensor Types"
    }
    public override func refresh() {
        super.refresh()
        tableSensorType.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let gl = GlobalInfos.getInstance()
        if(gl.getIsEditing()) {
            return gl.getSensorTypes().count + 1
        }
        return gl.getSensorTypes().count
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gl = GlobalInfos.getInstance()
        let controllerIndex = GlobalInfos.ViewControllers.SensorType.rawValue
        gl.orderedViewControllers[controllerIndex].setActObjectListIndex(index: indexPath.row)
        gl.setActPageIndex(actPageIndex: controllerIndex)
        mainPage.refreshPage()
        //mainPage.nextPage(viewController: self)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GeneralTableDataCell = tableSensorType.dequeueReusableCell(withIdentifier: "cellSensorType", for: indexPath) as! GeneralTableDataCell
        let gl = GlobalInfos.getInstance()
        cell.setParentController(ParentController: self)
        if(indexPath.row == gl.getSensorTypes().count) {
            cell.setIsLast(isLast : true)
            cell.setDataBinding(dataObject: SensorType(description: ""), dataObjectList: gl.getSensorTypes(), viewController: GlobalInfos.ViewControllers.SensorType)
        } else {
            cell.setDataBinding(dataObject: gl.getSensorTypes()[indexPath.row] as! GeneralTableDataObject, dataObjectList:  gl.getSensorTypes(), viewController: GlobalInfos.ViewControllers.SensorType)
        }
        cell.refresh()
        return cell
    }
}
