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
        let gl = GlobalInfos.getInstance()
        previousPage(viewController: gl.orderedViewControllers[gl.getActMainPageIndex()].first!)
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        let gl = GlobalInfos.getInstance()
        if let firstViewController = gl.orderedViewControllers[gl.getActMainPageIndex()].first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        for vc in GlobalInfos.getInstance().orderedViewControllers {
            for v in vc {
                v.mainPage = self
            }
        }
        /*let svc = GlobalInfos.getInstance().orderedViewControllers[0] as! StartViewController
        svc.mainPage = self
        let avc = GlobalInfos.getInstance().orderedViewControllers[1] as! ApartmentViewController
        avc.mainPage = self*/
    }
    public func refreshPage() {
        let gl = GlobalInfos.getInstance()
        let actMainPageIndex = gl.getActMainPageIndex()
        let actPageIndex = gl.getActPageIndex()
        let vc = gl.orderedViewControllers[actMainPageIndex][actPageIndex]
        setViewControllers([vc],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        vc.refresh()
    }
    
    public func nextPage(viewController: UIViewController) {
        let vc = pageViewController(self, viewControllerAfter: viewController)! as! GeneralViewController
        setViewControllers([vc],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        vc.refresh()
    }
    public func previousPage(viewController: UIViewController) {
        let vc = pageViewController(self, viewControllerBefore: viewController)
        if vc == nil {
            return
        }
        let gvc = vc as! GeneralViewController
        setViewControllers([gvc],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        gvc.refresh()
    }
}
extension MainPageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let gl = GlobalInfos.getInstance()
        guard let viewControllerIndex = gl.orderedViewControllers[gl.getActMainPageIndex()].index(of: viewController as! GeneralViewController) else {
            return nil
        }
        if GlobalInfos.getInstance().getApartment() == nil{
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = gl.orderedViewControllers[gl.getActMainPageIndex()].count
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        gl.setActPageIndex(actPageIndex: nextIndex)
        gl.orderedViewControllers[gl.getActMainPageIndex()][nextIndex].refresh()
        return gl.orderedViewControllers[gl.getActMainPageIndex()][nextIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let gl = GlobalInfos.getInstance()
        guard let viewControllerIndex = gl.orderedViewControllers[gl.getActMainPageIndex()].index(of: viewController as! GeneralViewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        guard gl.orderedViewControllers[gl.getActMainPageIndex()].count > previousIndex else {
            return nil
        }
        gl.setActPageIndex(actPageIndex: previousIndex)
        gl.orderedViewControllers[gl.getActMainPageIndex()][previousIndex].refresh()
        return gl.orderedViewControllers[gl.getActMainPageIndex()][previousIndex]
    }
}
