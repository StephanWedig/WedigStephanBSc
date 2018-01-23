//
//  StartViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 23.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: GeneralViewController {
    
    @IBOutlet weak var butNew: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func refresh() {
        super.refresh()
        navTopBar.isHidden = true
    }
    
    @IBAction func butNew_Click(_ sender: Any) {
        let gl = GlobalInfos.getInstance()
        gl.setApartment(apartment: Apartment())
        gl.addActControllerToNavigationOrder()
        gl.setActMainPageIndex(actMainPageIndex: 1)
        mainPage.refreshPage()
    }
}
