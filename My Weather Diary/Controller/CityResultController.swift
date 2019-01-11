//
//  CityResultController.swift
//  My Weather Diary
//
//  Created by zyh on 2019/1/8.
//  Copyright © 2019 njuzyh. All rights reserved.
//

import Foundation
import UIKit

let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height

private let resultCell = "resultCell"

class CityResultController: UITableViewController {
    
    var resultArray:[String] = []
    var isFrameChange = false
    /// 点击cell回调闭包
    var callBack: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 控制器根据所在界面的status bar，navigationbar，与tabbar的高度，不自动调整scrollview的 inset
        //self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: resultCell)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: resultCell, for: indexPath)
        cell.textLabel?.text = resultArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.cellForRow(at: indexPath)
        // 请求数据
        //NetworkManager.weatherData(cityName: cell?.textLabel?.text ?? "")
        callBack()
    }
    
    override func viewWillLayoutSubviews() {
        print(resultArray[1])
        super.viewWillLayoutSubviews()
        if isFrameChange == false {
            view.frame = CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64)
            isFrameChange = true
        }
    }
}
