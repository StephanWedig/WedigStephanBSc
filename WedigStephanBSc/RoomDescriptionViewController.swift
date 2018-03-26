//
//  RoomDescriptionViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 19.12.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

public class RoomDescriptionViewController : GeneralViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableRoomDescription: UITableView!
    
    public override func viewDidLoad() {
        enumViewController = GlobalInfos.ViewControllers.RoomDescription
        super.viewDidLoad()
        butRoomDescription.customView?.backgroundColor = GlobalInfos.selectedButtonBackgroundColor
        tableRoomDescription.delegate = self
        tableRoomDescription.dataSource = self
        tableRoomDescription.rowHeight = UITableViewAutomaticDimension
        navTopItem.title = "Room Descriptions"
    }
    public override func refresh() {
        super.refresh()
        tableRoomDescription.reloadData()
    }
    public override func save() {
        GlobalInfos.getInstance().saveRoomDescriptions()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let gl = GlobalInfos.getInstance()
        if(gl.getIsEditing()) {
            return gl.getRoomDescriptions().count + 1
        }
        return gl.getRoomDescriptions().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GeneralTableDataCell = tableRoomDescription.dequeueReusableCell(withIdentifier: "cellRoomDescription", for: indexPath) as! GeneralTableDataCell
        let gl = GlobalInfos.getInstance()
        cell.setParentController(ParentController: self)
        if(indexPath.row == gl.getRoomDescriptions().count) {
            cell.setIsLast(isLast : true)
            cell.setDataBinding(dataObject: RoomDescription(description: ""), dataObjectList: gl.getRoomDescriptions(), viewController: GlobalInfos.ViewControllers.unknown)
        } else {
            cell.setDataBinding(dataObject: gl.getRoomDescriptions()[indexPath.row] as! GeneralTableDataObject, dataObjectList:  gl.getRoomDescriptions(), viewController: GlobalInfos.ViewControllers.unknown)
        }
        cell.refresh()
        return cell
    }
}
