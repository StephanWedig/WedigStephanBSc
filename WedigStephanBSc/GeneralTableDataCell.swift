//
//  GeneralTableDataCell.swift
//  WedigStephanBSc
//
//  Created by Admin on 15.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

public class GeneralTableDataCell : UITableViewCell {
    private var _isLast = false
    private var _createNew = false
    private var _DataObjectList = [GeneralTableDataObject]()
    private var _DataObject : GeneralTableDataObject!
    private var _ParentController : GeneralViewController!
    private var labTitle: UILabel!
    private var butReaction: UIButton!
    private var txtTitle: UITextField!
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createScreen()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createScreen()
    }
    public func createScreen () {
        print("Hallo")
        butReaction = UIButton()
        butReaction.setTitle("but", for: .normal)
        butReaction.contentRect(forBounds: CGRect(x: 0, y: 0, width: 50, height: 44))
        self.addSubview(butReaction)
        labTitle = UILabel()
        labTitle.text = "Label"
        labTitle.textRect(forBounds: CGRect(x: 50, y: 0, width: 50, height: 44), limitedToNumberOfLines: 1)
        self.addSubview(labTitle)
        txtTitle = UITextField()
        txtTitle.text = "Textfield"
        txtTitle.textRect(forBounds: CGRect(x: 100, y: 0, width: 50, height: 44))
        self.addSubview(txtTitle);
    }
    public func setIsLast(isLast : Bool) {
        _isLast = isLast;
    }
    public func setParentController (ParentController : GeneralViewController ) {
        _ParentController = ParentController
    }
    public func setDataObject (dataObject : GeneralTableDataObject, dataObjectList : [GeneralTableDataObject] ) {
        _DataObjectList = dataObjectList
        _DataObject = dataObject
        labTitle.text = _DataObject.toString()
        txtTitle.text = _DataObject.toString()
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
                if _DataObject != nil {
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
                for index in 1..._DataObjectList.count {
                    if _DataObject.getID() == _DataObjectList[index].getID() {
                        descIndex = index
                        break
                    }
                }
                if descIndex != -1 {
                    var rs = _DataObjectList
                    rs.remove(at: descIndex)
                }
            }
            _ParentController.refresh()
        }
    }
}

