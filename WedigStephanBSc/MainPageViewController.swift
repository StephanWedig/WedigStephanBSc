//
//  MainPageViewController.swift
//  WedigStephanBSc
//
//  Created by Admin on 21.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

public class MainPageViewController : UIPageViewController {
    @IBAction func butBack_Click(_ sender: Any) {
        /*let gl = GlobalInfos.getInstance()
        previousPage(viewController: gl.orderedViewControllers[gl.getActMainPageIndex()].first!)*/
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        let gl = GlobalInfos.getInstance()
        setViewControllers([gl.orderedViewControllers[GlobalInfos.ViewControllers.OpenSave.rawValue]],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        for vc in GlobalInfos.getInstance().orderedViewControllers {
            vc.mainPage = self
        }
        /*let svc = GlobalInfos.getInstance().orderedViewControllers[0] as! StartViewController
        svc.mainPage = self
        let avc = GlobalInfos.getInstance().orderedViewControllers[1] as! ApartmentViewController
        avc.mainPage = self*/
    }
    public func refreshPage() {
        let gl = GlobalInfos.getInstance()
        let vc = gl.getActViewController()
        setViewControllers([vc],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        vc.refresh()
    }
    
    /*public func nextPage(viewController: UIViewController) {
        //let vc = pageViewController(self, viewControllerAfter: viewController)! as! GeneralViewController
        
        let gl = GlobalInfos.getInstance()
        if GlobalInfos.getInstance().getApartment() == nil {
            return
        }
        let nextIndex = gl.getActPageIndex() + 1
        
        let orderedViewControllersCount = gl.orderedViewControllers[gl.getActMainPageIndex()].count
        if orderedViewControllersCount <= nextIndex {
            return
        }
        gl.setActPageIndex(actPageIndex: nextIndex)
        gl.orderedViewControllers[gl.getActMainPageIndex()][nextIndex].refresh()
        let vc = gl.orderedViewControllers[gl.getActMainPageIndex()][nextIndex]
        setViewControllers([vc],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        vc.refresh()
    }*/
    public func previousPage(viewController: UIViewController) {
        //let vc = pageViewController(self, viewControllerBefore: viewController)
        
        let gl = GlobalInfos.getInstance()
        gl.setToPreviousViewController()
        //let previousIndex = gl.getActPageIndex() - 1
        /*let previousIndex = gl.getActPageIndex()
        
        if previousIndex < 0 {
            return
        }
        if gl.orderedViewControllers.count <= previousIndex {
            return
        }
        //gl.setActPageIndex(actPageIndex: previousIndex)
        gl.orderedViewControllers[previousIndex].refresh()*/
        let vc = gl.getActViewController()
        if vc != viewController {
            setViewControllers([vc],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            vc.refresh()
        }
    }
}
extension MainPageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        /*let gl = GlobalInfos.getInstance()
        if GlobalInfos.getInstance().getApartment() == nil{
            return nil
        }
        let nextIndex = gl.getActPageIndex() + 1
        
        let orderedViewControllersCount = gl.orderedViewControllers[gl.getActMainPageIndex()].count
        if orderedViewControllersCount <= nextIndex {
            return nil
        }
        gl.setActPageIndex(actPageIndex: nextIndex)
        gl.orderedViewControllers[gl.getActMainPageIndex()][nextIndex].refresh()
        return gl.orderedViewControllers[gl.getActMainPageIndex()][nextIndex]*/
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        /*let gl = GlobalInfos.getInstance()
        let previousIndex = gl.getActPageIndex() - 1
        
        if previousIndex < 0 {
            return nil
        }
        if gl.orderedViewControllers[gl.getActMainPageIndex()].count <= previousIndex {
            return nil
        }
        gl.setActPageIndex(actPageIndex: previousIndex)
        gl.orderedViewControllers[gl.getActMainPageIndex()][previousIndex].refresh()
        return gl.orderedViewControllers[gl.getActMainPageIndex()][previousIndex]*/
        return nil
    }
}
