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
    /*@IBAction func butBack_Click(_ sender: Any) {
        mainPage.previousPage(viewController: self)
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let gl = GlobalInfos.getInstance()
        if gl.getApartment() != nil && gl.getApartment()?.getRooms() != nil {
            return (gl.getApartment()!.getRooms().count)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableRooms.dequeueReusableCell(withIdentifier: "cellRoom", for: indexPath)
        
        let gl = GlobalInfos.getInstance()
        
        if gl.getApartment() != nil && gl.getApartment()?.getRooms() != nil {
            cell.textLabel?.text = gl.getApartment()!.getRooms()[indexPath.row].toString()
        }
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
        GlobalInfos.getInstance().setActRoomIndex(index: indexPath.row)
        mainPage.nextPage(viewController: self)
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
    @IBAction func butAddRoom_Click(_ sender: Any) {
        let gl = GlobalInfos.getInstance()
        gl.getApartment()?.appendRoom(room: Room(apartment: gl.getApartment()!))
        gl.setActRoomIndex(index: (gl.getApartment()?.getRooms().count)! - 1)
        
        mainPage.nextPage(viewController: self)
    }
    @IBAction func butGPS_Click(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
}

