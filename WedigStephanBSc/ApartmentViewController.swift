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
        tableRooms.delegate = self
        tableRooms.dataSource = self
        txtStreet.delegate = self
        txtName.delegate = self
        txtPLZ.delegate = self
        txtPlace.delegate = self
        txtHousenumber.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let gl = GlobalInfos.getInstance()
        if gl.getApartment() != nil && gl.getApartment()?.getRooms() != nil {
            if gl.getIsEditing() {
                return gl.getApartment()!.getRooms().count + 1
            }
            return gl.getApartment()!.getRooms().count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GeneralTableDataCell = tableRooms.dequeueReusableCell(withIdentifier: "cellRoom", for: indexPath) as! GeneralTableDataCell
        
        let gl = GlobalInfos.getInstance()
        
        cell.setParentController(ParentController: self)
        if(indexPath.row == gl.getApartment()?.getRooms().count) {
            cell.setIsLast(isLast : true)
            cell.setDataBinding(dataObject: Room(apartment: gl.getApartment()!), dataObjectList: (gl.getApartment()?.getRooms())!, viewController: GlobalInfos.ViewControllers.Room)
        } else {
            cell.setDataBinding(dataObject: gl.getApartment()?.getRooms()[indexPath.row] as! GeneralTableDataObject, dataObjectList:  (gl.getApartment()?.getRooms())!, viewController: GlobalInfos.ViewControllers.Room)
        }
        cell.refresh()
        return cell
    }
    public override func refresh() {
        super.refresh()
        let gl = GlobalInfos.getInstance()
        let ap = gl.getApartment()
        if txtStreet == nil {
            return;
        }
        if ap != nil {
            txtStreet.text = ap?.getStreet()
            txtHousenumber.text = ap?.getHousenumber()
            txtPLZ.text = ap?.getPostalcode()
            txtPlace.text = ap?.getLocation()
            txtName.text = ap?.getName()
        }
        tableRooms.reloadData()
        navTopItem.title = "Apartment"
    }
    
    public func refreshGPS() {
        let gl = GlobalInfos.getInstance()
        let ap = gl.getApartment()
        if txtStreet == nil {
            return;
        }
        if ap != nil {
            txtStreet.text = ap?.getStreet()
            txtHousenumber.text = ap?.getHousenumber()
            txtPLZ.text = ap?.getPostalcode()
            txtPlace.text = ap?.getLocation()
        }
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {    //delegate method
        super.textFieldDidEndEditing(textField)
        let gl = GlobalInfos.getInstance()
        let ap = gl.getApartment()
        if(ap == nil) {
            return
        }
        if textField == txtStreet {
            ap?.setStreet(street: textField.text)
        }
        if textField == txtPLZ {
            ap?.setPostalcode(postalcode: textField.text)
        }
        if textField == txtPlace {
            ap?.setLocation(location: textField.text)
        }
        if textField == txtHousenumber {
            ap?.setHousenumber(housenumber: textField.text)
        }
        if textField == txtName {
            ap?.setName(name: textField.text)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gl = GlobalInfos.getInstance()
        let controllerIndex = GlobalInfos.ViewControllers.Room.rawValue
        gl.orderedViewControllers[controllerIndex].setActObjectListIndex(index: indexPath.row)
        gl.setActRoomIndex(index: indexPath.row)
        gl.setActPageIndex(actPageIndex: controllerIndex)
        mainPage.refreshPage()
        //mainPage.nextPage(viewController: self)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get first location item returned from locations array
        let userLocation = locations.last as CLLocation!
        // Convert location into object with human readable address components
        CLGeocoder().reverseGeocodeLocation(userLocation!, completionHandler: { (placemarks, e) -> Void in
            if e != nil {
                print("Error:  \(String(describing: e?.localizedDescription))")
            } else {
                let placemark = placemarks?.last as CLPlacemark?
                if placemark != nil {
                    let gl = GlobalInfos.getInstance()
                    if gl.getApartment() == nil {
                        gl.setApartment(apartment: Apartment())
                    }
                    let ap = gl.getApartment()!
                    ap.setPostalcode(postalcode: placemark?.postalCode)
                    ap.setLocation(location: placemark?.locality)
                    if placemark?.subThoroughfare != nil {
                        ap.setStreet(street: placemark?.thoroughfare)
                        ap.setHousenumber(housenumber: placemark?.subThoroughfare)
                        gl.setApartment(apartment: ap)
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

