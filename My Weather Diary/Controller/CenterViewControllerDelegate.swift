//
//  DrawerViewControllerDelegate.swift
//  My Weather Diary
//
//  Created by zyh on 2018/12/2.
//  Copyright © 2018 njuzyh. All rights reserved.
//

import Foundation
import UIKit

//单独一个文件写代理，增加扩展性
@objc
protocol CenterViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    //@objc optional func toggleRightPanel()
    //@objc optional func collapseSidePanels()
    //@objc optional func solvePanGesture()
    //@objc optional func solveTapGesture()
}
