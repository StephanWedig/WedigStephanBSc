//
//  RoomDescription.swift
//  WedigStephanBSc
//
//  Created by Admin on 15.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

public class RoomDescription : GeneralTableDataObject {
    private var _description : String = ""
    public init (description : String) {
        _description = description
    }
    public func getDescription() -> String {
        return _description
    }
    public func setDescription( description : String) {
        _description = description
    }
    public override func toString() -> String {
        return _description
    }
}

/*public class RoomDescriptionCell : UITableViewCell {
    private var _isLast = false
    private var _createNew = false
    private var _RoomDescription : RoomDescription!
    private var _ParentController : GeneralViewController!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var butReaction: UIButton!
    @IBOutlet weak var txtTitle: UITextField!
    public func setIsLast(isLast : Bool) {
        _isLast = isLast;
    }
    public func setParentController (ParentController : GeneralViewController ) {
        _ParentController = ParentController
    }
    public func setRoomDescription (description : RoomDescription ) {
        _RoomDescription = description
        labTitle.text = _RoomDescription.toString()
        txtTitle.text = _RoomDescription.getDescription()
    }
    public func refresh() {
        let gl = GlobalInfos.getInstance()
        if _isLast {
            if !_createNew {
                butReaction.setImage(UIImage(named: "iconmonstr-plus-4-32"), for: .normal)
                txtTitle.isHidden = true
                labTitle.isHidden = true
            }
        } else {
            if gl.getIsEditing() {
                if _RoomDescription != nil {
                    butReaction.setImage(UIImage(named: "iconmonstr-x-mark-4-32"), for: .normal)
                } else {
                    butReaction.setImage(UIImage(named: "iconmonstr-plus-4-32"), for: .normal)
                }
                txtTitle.isHidden = false
                labTitle.isHidden = true
            } else {
                butReaction.setImage(UIImage(named: "iconmonstr-shape-19-16"), for: .normal)
                txtTitle.isHidden = true
                labTitle.isHidden = false
            }
        }
    }
    @IBAction func butReaction_Click(_ sender: Any) {
        let gl = GlobalInfos.getInstance()
        if gl.getIsEditing() {
            if _isLast {
                _createNew = true
                refresh()
            } else {
                var descIndex = -1
                for index in 1...gl.getRoomDescriptions().count {
                    if _RoomDescription.getID() == gl.getRoomDescriptions()[index].getID() {
                        descIndex = index
                        break
                    }
                }
                if descIndex != -1 {
                    var rs = gl.getRoomDescriptions()
                    rs.remove(at: descIndex)
                }
            }
            _ParentController.refresh()
        }
    }
}*/
