//
//  GeneralTableDataCell.swift
//  WedigStephanBSc
//
//  Created by Admin on 15.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

public class GeneralTableDataCell : UITableViewCell, UITextFieldDelegate {
    
    private var _isLast = false
    private var _DataObjectList = NSMutableArray()
    private var _DataObject : GeneralTableDataObject!
    private var _ParentController : GeneralViewController!
    private var _DataObjectViewController : GlobalInfos.ViewControllers!
    private var labTitle: UILabel!
    private var butReaction: UIButton!
    private var txtTitle: UITextField!
    public var savePath = ""
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createScreen()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createScreen()
    }
    public func createScreen () {
        butReaction = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        butReaction.addTarget(self, action: #selector(self.butReaction_Click(_:)), for: .touchUpInside)
        self.addSubview(butReaction)
        labTitle = UILabel(frame: CGRect(x: 40, y: 0, width: 0, height: 50))
        labTitle.text = "Label"
        self.addSubview(labTitle)
        txtTitle = UITextField(frame: CGRect(x: 40, y: 0, width: 0, height: 50))
        txtTitle.text = "Textfield"
        self.addSubview(txtTitle);
        txtTitle.delegate = self
        
        let butReactionLeadingConstraint = NSLayoutConstraint(item: butReaction, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let butReactionTopConstraint = NSLayoutConstraint(item: butReaction, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let butReactionBottomConstraint = NSLayoutConstraint(item: butReaction, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let butReactionWidthConstraint = NSLayoutConstraint(item: butReaction, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 45)
        let butReactionHeightConstraint = NSLayoutConstraint(item: butReaction, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 45)
        
        NSLayoutConstraint.activate([butReactionLeadingConstraint, butReactionTopConstraint, butReactionBottomConstraint, butReactionWidthConstraint, butReactionHeightConstraint])
        butReaction.translatesAutoresizingMaskIntoConstraints = false
        
        
        let labTitleLeadingConstraint = NSLayoutConstraint(item: labTitle, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal            , toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 45)
        let labTitleTopConstraint = NSLayoutConstraint(item: labTitle, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let labTitleBottomConstraint = NSLayoutConstraint(item: labTitle, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal            , toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let labTitleTrailingConstraint = NSLayoutConstraint(item: labTitle, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([labTitleLeadingConstraint, labTitleTopConstraint, labTitleBottomConstraint, labTitleTrailingConstraint])
        labTitle.translatesAutoresizingMaskIntoConstraints = false
        
        
        let txtTitleLeadingConstraint = NSLayoutConstraint(item: txtTitle, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal            , toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 45)
        let txtTitleTopConstraint = NSLayoutConstraint(item: txtTitle, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let txtTitleBottomConstraint = NSLayoutConstraint(item: txtTitle, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal            , toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let txtTitleTrailingConstraint = NSLayoutConstraint(item: txtTitle, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([txtTitleLeadingConstraint, txtTitleTopConstraint, txtTitleBottomConstraint, txtTitleTrailingConstraint])
        txtTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    public func setIsLast(isLast : Bool) {
        _isLast = isLast;
    }
    public func setParentController (ParentController : GeneralViewController ) {
        _ParentController = ParentController
    }
    public func setDataBinding (dataObject : GeneralTableDataObject, dataObjectList : NSMutableArray, viewController : GlobalInfos.ViewControllers) {
        _DataObjectList = dataObjectList
        _DataObject = dataObject
        _DataObjectViewController = viewController
        labTitle.text = _DataObject.toString()
        txtTitle.text = _DataObject.toString()
    }
    public func refresh() {
        let gl = GlobalInfos.getInstance()
        if _isLast {
            butReaction.setImage(UIImage(named: "iconmonstr-plus-4-32"), for: .normal)
            txtTitle.isHidden = true
            labTitle.isHidden = true
        } else {
            if gl.getIsEditing() {
                if _DataObject != nil {
                    butReaction.setImage(UIImage(named: "iconmonstr-x-mark-4-32"), for: .normal)
                } else {
                    butReaction.setImage(UIImage(named: "iconmonstr-plus-4-32"), for: .normal)
                }
                if _DataObject.isOnlySmallObject() {
                    txtTitle.isHidden = false
                    labTitle.isHidden = true
                } else {
                    txtTitle.isHidden = true
                    labTitle.isHidden = false
                }
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
                _isLast = false
                createNewObject()
                refresh()
                _ParentController.refresh()
            } else {
                _DataObjectList.remove(_DataObject)
                if savePath != "" {
                    NSKeyedArchiver.archiveRootObject(_DataObjectList, toFile: savePath)
                }
            }
            _ParentController.refresh()
        }
    }
    public func createNewObject() {
        _DataObjectList.add(_DataObject)
        _DataObject.initForAdd()
        if(!_DataObject.isOnlySmallObject() && _DataObjectViewController != GlobalInfos.ViewControllers.unknown) {
            let gl = GlobalInfos.getInstance()
            gl.orderedViewControllers[_DataObjectViewController.rawValue].setActObjectListIndex(index: _DataObjectList.count - 1)
            gl.setActPageIndex(actPageIndex: _DataObjectViewController.rawValue)
            _ParentController.mainPage.refreshPage()
        }
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {    //delegate method
        _DataObject.setValue(value: textField.text!)
        if savePath != "" {
            NSKeyedArchiver.archiveRootObject(_DataObjectList, toFile: savePath)
        }
    }
}

