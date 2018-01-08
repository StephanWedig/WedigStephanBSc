//
//  RoomViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 12.12.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

class RoomViewController: GeneralViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var tableSensor: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtID.delegate = self
        txtDescription.delegate = self
        tableSensor.delegate = self
        tableSensor.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let gl = GlobalInfos.getInstance()
        if gl.getActRoom() != nil && gl.getActRoom()?.getSensors() != nil {
            return (gl.getActRoom()?.getSensors().count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableSensor.dequeueReusableCell(withIdentifier: "cellSensor", for: indexPath)
        
        let gl = GlobalInfos.getInstance()
        
        if gl.getActRoom() != nil && gl.getActRoom()?.getSensors() != nil {
            cell.textLabel?.text = gl.getActRoom()?.getSensors()[indexPath.row].toString()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GlobalInfos.getInstance().setActRoomIndex(index: indexPath.row)
        mainPage.nextPage(viewController: self)
    }
    public override func refresh() {
        let gl = GlobalInfos.getInstance()
        let r = gl.getActRoom()
        if(r == nil) {
            return
        }
        if txtDescription == nil {
            return
        }
        txtDescription.text = r?.getDescription()
        txtID.text = r?.getID()
        tableSensor.reloadData()
        navItem.title = gl.getApartment()?.toString()
    }
    override func textFieldDidEndEditing(_ textField: UITextField) {    //delegate method
        super.textFieldDidEndEditing(textField)
        let gl = GlobalInfos.getInstance()
        let r = gl.getActRoom()
        if(r == nil) {
            return
        }
        if textField == txtID {
            r?.setID(ID: textField.text!)
        }
        if textField == txtDescription {
            r?.setDescription(description: textField.text!)
        }
    }
}
