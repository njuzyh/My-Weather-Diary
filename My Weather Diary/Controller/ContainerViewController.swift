//
//  ContainerViewController.swift
//  My Weather Diary
//
//  Created by zyh on 2018/12/2.
//  Copyright © 2018 njuzyh. All rights reserved.
//

import UIKit
import QuartzCore

class ContainerViewController: UIViewController {
    //当前滑出框的状态
    enum MenuState {
        case Collapsed  // 未显示(收起)
        case Expanding   // 展开中
        case Expanded   // 展开
    }
    
    //当前状态，并做观察者以便处理阴影效果
    var currentState = MenuState.Collapsed {
        didSet {
            //菜单展开的时候，给主页面边缘添加阴影
            let shouldShowShadow = currentState != .Collapsed
            showShadowForMainViewController(shouldShowShadow: shouldShowShadow)
        }
    }
    
    // 主页导航控制器
    var mainNavigationController:UINavigationController!
    
    // 主页面控制器
    var mainViewController:CenterViewController!
    //左边栏
    var menuViewController:MenuViewController?
    
    let menuViewExpandedOffset: CGFloat = 60//在展开边栏后中心视图还剩多少可见
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化主视图
        mainNavigationController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "mainNavigaiton")
            as? UINavigationController
        view.addSubview(mainNavigationController.view)
        mainViewController = mainNavigationController.viewControllers.first
            as? CenterViewController
        mainViewController.delegate = self
        //mainViewController.navigationItem.leftBarButtonItem!.action = #selector(showMenu)
        //添加拖动手势
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(solvePanGesture(_:)))
        mainNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        
        //单击收起菜单手势
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(solveTapGesture))
        mainNavigationController.view.addGestureRecognizer(tapGestureRecognizer)
    
    }
}

//实现代理里面的方法，以便委托者在自己的controller里面直接调用
//里面有些方法并不是协议规定的
extension ContainerViewController: CenterViewControllerDelegate {
    func toggleLeftPanel() {
        print("did show")
        if currentState == .Expanded {
            animateMainView(shouldExpand: false)
        }else {
            addMenuViewController()
            animateMainView(shouldExpand: true)
        }
    }
    
    @objc func solvePanGesture(_ recognizer: UIPanGestureRecognizer)
    {
        switch(recognizer.state) {
        // 刚刚开始滑动
        case .began:
            // 判断拖动方向
            let dragFromLeftToRight = (recognizer.velocity(in: view).x > 0)
            // 如果刚刚开始滑动的时候还处于主页面，从左向右滑动加入侧面菜单
            if (currentState == .Collapsed && dragFromLeftToRight) {
                currentState = .Expanding
                addMenuViewController()
            }
            
        // 如果是正在滑动，则偏移主视图的坐标实现跟随手指位置移动
        case .changed:
            let positionX = recognizer.view!.frame.origin.x +
                recognizer.translation(in: view).x
            //页面滑到最左侧的话就不许要继续往左移动
            recognizer.view!.frame.origin.x = positionX < 0 ? 0 : positionX
            recognizer.setTranslation(.zero, in: view)
            
        // 如果滑动结束
        case .ended:
            //根据页面滑动是否过半，判断后面是自动展开还是收缩
            let hasMovedhanHalfway = recognizer.view!.center.x > view.bounds.size.width
            animateMainView(shouldExpand: hasMovedhanHalfway)
        default:
            break
        }
    }
    
    @objc func solveTapGesture()
    {
        //如果菜单是展开的点击主页部分则会收起
        if currentState == .Expanded {
            animateMainView(shouldExpand: false)
        }
    }
    
    // 添加菜单页
    func addMenuViewController() {
        if (menuViewController == nil) {
            menuViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "menuView")
                as? MenuViewController
            
            // 插入当前视图并置顶
            view.insertSubview(menuViewController!.view, at: 0)
            
            // 建立父子关系
            addChild(menuViewController!)
            menuViewController!.didMove(toParent: self)
        }
    }
    
    //主页自动展开、收起动画
    func animateMainView(shouldExpand: Bool) {
        // 如果是用来展开
        if (shouldExpand) {
            // 更新当前状态
            currentState = .Expanded
            // 动画
            animateMainViewXPosition(targetPosition:
                mainNavigationController.view.frame.width - menuViewExpandedOffset)
        }
            // 如果是用于隐藏
        else {
            // 动画
            animateMainViewXPosition(targetPosition: 0) { finished in
                // 动画结束之后s更新状态
                self.currentState = .Collapsed
                // 移除左侧视图
                self.menuViewController?.view.removeFromSuperview()
                // 释放内存
                self.menuViewController = nil;
            }
        }
    }
    
    //主页移动动画（在x轴移动）
    func animateMainViewXPosition(targetPosition: CGFloat,
                                  completion: ((Bool) -> Void)! = nil) {
        //usingSpringWithDamping：1.0表示没有弹簧震动动画
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        self.mainNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    //给主页面边缘添加、取消阴影
    func showShadowForMainViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            mainNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            mainNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

