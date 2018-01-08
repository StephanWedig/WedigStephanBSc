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
        previousPage(viewController: gl.orderedViewControllers[gl.getMainPageIndex()].first!)
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        let gl = GlobalInfos.getInstance()
        if let firstViewController = gl.orderedViewControllers[gl.getMainPageIndex()].first {
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
    public func nextPage(viewController: UIViewController) {
        let vc = pageViewController(self, viewControllerAfter: viewController)! as! GeneralViewController
        setViewControllers([vc],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        vc.refresh()
    }
    public func previousPage(viewController: UIViewController) {
        let vc = pageViewController(self, viewControllerBefore: viewController)! as! GeneralViewController
        setViewControllers([vc],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        vc.refresh()
    }
}
extension MainPageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let gl = GlobalInfos.getInstance()
        guard let viewControllerIndex = gl.orderedViewControllers[gl.getMainPageIndex()].index(of: viewController as! GeneralViewController) else {
            return nil
        }
        if GlobalInfos.getInstance().getApartment() == nil{
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = gl.orderedViewControllers[gl.getMainPageIndex()].count
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        gl.orderedViewControllers[gl.getMainPageIndex()][nextIndex].refresh()
        return gl.orderedViewControllers[gl.getMainPageIndex()][nextIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let gl = GlobalInfos.getInstance()
        guard let viewControllerIndex = gl.orderedViewControllers[gl.getMainPageIndex()].index(of: viewController as! GeneralViewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        guard gl.orderedViewControllers[gl.getMainPageIndex()].count > previousIndex else {
            return nil
        }
        gl.orderedViewControllers[gl.getMainPageIndex()][previousIndex].refresh()
        return gl.orderedViewControllers[gl.getMainPageIndex()][previousIndex]
    }
}
