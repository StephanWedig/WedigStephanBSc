//
//  ApartmentViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 05.12.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class ApartmentViewController: GeneralViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    private var actObject:Apartment?
    @IBOutlet weak var butGPS: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtHousenumber: UITextField!
    @IBOutlet weak var txtPLZ: UITextField!
    @IBOutlet weak var txtPlace: UITextField!
    @IBOutlet weak var tableRooms: UITableView!
    var locationManager: CLLocationManager = CLLocationManager()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        enumViewController = GlobalInfos.ViewControllers.Apartment
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //butAppartment.tintColor = GlobalInfos.selectedButtonBackgroundColor
        butAppartment.customView?.backgroundColor = GlobalInfos.selectedButtonBackgroundColor
        tableRooms.delegate = self
        tableRooms.dataSource = self
        txtStreet.delegate = self
        txtName.delegate = self
        txtPLZ.delegate = self
        txtPlace.delegate = self
        txtHousenumber.delegate = self
    }
    override func save() {
        GlobalInfos.getInstance().saveApartements()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let gl = GlobalInfos.getInstance()
        if actObject != nil {
            if gl.getIsEditing() {
                return (actObject?.getRooms().count)! + 1
            }
            return (actObject?.getRooms().count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GeneralTableDataCell = tableRooms.dequeueReusableCell(withIdentifier: "cellRoom", for: indexPath) as! GeneralTableDataCell
        
        cell.setParentController(ParentController: self)
        if(indexPath.row == actObject?.getRooms().count) {
            cell.setIsLast(isLast : true)
            cell.setDataBinding(dataObject: Room(apartment: (actObject)!), dataObjectList: (actObject?.getRooms())!, viewController: GlobalInfos.ViewControllers.Room)
        } else {
            cell.setDataBinding(dataObject: actObject?.getRooms()[indexPath.row] as! GeneralTableDataObject, dataObjectList:  (actObject?.getRooms())!, viewController: GlobalInfos.ViewControllers.Room)
        }
        cell.refresh()
        return cell
    }
    public override func refresh() {
        super.refresh()
        let gl = GlobalInfos.getInstance()
        if txtStreet == nil {
            return;
        }
        actObject = gl.getActApartment()!
        if actObject != nil {
            txtStreet.text = actObject?.getStreet()
            txtHousenumber.text = actObject?.getHousenumber()
            txtPLZ.text = actObject?.getPostalcode()
            txtPlace.text = actObject?.getLocation()
            txtName.text = actObject?.getName()
        }
        tableRooms.reloadData()
        navTopItem.title = "Apartment"
        txtStreet.isEnabled = gl.getIsEditing()
        txtHousenumber.isEnabled = gl.getIsEditing()
        txtPLZ.isEnabled = gl.getIsEditing()
        txtPlace.isEnabled = gl.getIsEditing()
        txtName.isEnabled = gl.getIsEditing()
        butGPS.isEnabled = gl.getIsEditing()
    }
    
    public func refreshGPS() {
        if txtStreet == nil {
            return;
        }
        if actObject != nil {
            txtStreet.text = actObject?.getStreet()
            txtHousenumber.text = actObject?.getHousenumber()
            txtPLZ.text = actObject?.getPostalcode()
            txtPlace.text = actObject?.getLocation()
        }
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {    //delegate method
        super.textFieldDidEndEditing(textField)
        if(actObject == nil) {
            return
        }
        if textField == txtStreet {
            actObject?.setStreet(street: textField.text!)
        }
        if textField == txtPLZ {
            actObject?.setPostalcode(postalcode: textField.text!)
        }
        if textField == txtPlace {
            actObject?.setLocation(location: textField.text!)
        }
        if textField == txtHousenumber {
            actObject?.setHousenumber(housenumber: textField.text!)
        }
        if textField == txtName {
            actObject?.setName(name: textField.text!)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gl = GlobalInfos.getInstance()
        let controllerIndex = GlobalInfos.ViewControllers.Room.rawValue
        gl.setActRoomIndex(index: indexPath.row)
        gl.setActPageIndex(actPageIndex: controllerIndex)
        gl.orderedViewControllers[controllerIndex].setActObjectListIndex(index: indexPath.row)
        mainPage.refreshPage()
        //mainPage.nextPage(viewController: self)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get first location item returned from locations array
        let userLocation = locations.last as CLLocation?
        // Convert location into object with human readable address components
        CLGeocoder().reverseGeocodeLocation(userLocation!, completionHandler: { (placemarks, e) -> Void in
            if e != nil {
                print("Error:  \(String(describing: e?.localizedDescription))")
            } else {
                let placemark = placemarks?.last as CLPlacemark?
                if placemark != nil {
                    self.actObject?.setPostalcode(postalcode: (placemark?.postalCode)!)
                    self.actObject?.setLocation(location: (placemark?.locality)!)
                    if placemark?.subThoroughfare != nil {
                        self.actObject?.setStreet(street: (placemark?.thoroughfare)!)
                        self.actObject?.setHousenumber(housenumber: (placemark?.subThoroughfare)!)
                        self.locationManager.stopUpdatingLocation()
                    }
                    self.refreshGPS()
                }
            }
        })
    }
    @IBAction func butGPS_Click(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
}

