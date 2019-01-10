//
//  CityCell.swift
//  My Weather Diary
//
//  Created by zyh on 2019/1/7.
//  Copyright © 2019 njuzyh. All rights reserved.
//

import Foundation
import UIKit

/// section间距
let sectionMargin: CGFloat = 38

/// 热门城市btn
let btnMargin: CGFloat = 15
let btnWidth: CGFloat = (375 - 90) / 3
let btnHeight: CGFloat = 36
/// 主配色
let mainColor = UIColor(red:0.44, green:0.44, blue:0.44, alpha:1.0)
/// 浅灰 cell背景色
let cellColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
/// btn 高亮背景色
let btnHighlightColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
/// btn 高亮图片
//let btnHighlightImage = UIImage.withBackground(btnHighlightColor)

//MARK: - 自定义cell
class CurrentCityTableViewCell: UITableViewCell {
    
    /// 回调
    var callBack: (() -> ())?
    /// 当前城市
    var currentCity: String? {
        didSet{
            if let city = currentCity {
                currentCityBtn.setTitle(city, for: .normal)
                currentCityBtn.isHidden = false
            }
        }
    }
    /// 当前城市btn
    var currentCityBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: btnMargin, y: btnMargin, width: btnWidth, height: btnHeight))
        btn.setTitleColor(mainColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 1
        //btn.setBackgroundImage(btnHighlightImage, for: .highlighted)
        btn.isHidden = true
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = cellColor
        addSubview(currentCityBtn)
        currentCityBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
    }
    
    @objc private func btnClick(btn: UIButton) {
        //NetworkManager.weatherData(cityName: btn.titleLabel?.text ?? "")
        callBack!()
    }
}

class RecentCityTableViewCell: UITableViewCell {
    
    lazy var dataArray:[String] = {
        let path = Bundle.main.path(forResource: "HotCity", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        return array as! [String]
    }()
    
    /// 点击按钮执行该闭包 (可选)
    var callBack: ((_ btn: UIButton) -> ())?
    
    /// 使用tableView.dequeueReusableCell会自动调用这个方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.selectionStyle = .none
        self.backgroundColor = cellColor
        
        
        // 动态创建最近城市btn
        let dataCount = dataArray.count
        var count = 3
        if dataCount < 4 {
            count = dataCount
        }
        for i in 0..<count {
            let x = btnMargin + CGFloat(i) * (btnMargin + btnWidth)
            let btn = UIButton(frame: CGRect(x: x, y: btnMargin, width: btnWidth, height: btnHeight))
            btn.setTitle(dataArray[i], for: .normal)
            btn.setTitleColor(mainColor, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.backgroundColor = UIColor.white
            //            btn.layer.borderColor = mainColor.cgColor
            //            btn.layer.borderWidth = 0.5
            btn.layer.cornerRadius = 1
            //btn.setBackgroundImage(btnHighlightImage, for: .highlighted)
            btn .addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            
        }
    }
    
    @objc private func btnClick(btn: UIButton) {
        // 执行闭包
        callBack!(btn)
        
    }
    
    
    
}


class HotCityTableViewCell: UITableViewCell {
    
    /// 懒加载 热门城市
    lazy var hotCities: [String] = {
        let path = Bundle.main.path(forResource: "HotCity.plist", ofType: nil)
        let array = NSArray(contentsOfFile: path!) as? [String]
        return array ?? []
    }()
    /// 点击按钮执行该闭包 (可选)
    var callBack: ((_ btn: UIButton) -> ())?
    
    /// 使用tableView.dequeueReusableCell会自动调用这个方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = cellColor
        // 动态创建城市btn
        for i in 0..<hotCities.count {
            // 列
            let column = i % 3
            // 行
            let row = i / 3
            
            let btn = UIButton(frame: CGRect(x: btnMargin + CGFloat(column) * (btnWidth + btnMargin), y: 15 + CGFloat(row) * (btnHeight + btnMargin), width: btnWidth, height: btnHeight))
            btn.setTitle(hotCities[i], for: .normal)
            btn.setTitleColor(mainColor, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.backgroundColor = UIColor.white
            btn.layer.cornerRadius = 1
            //btn.setBackgroundImage(btnHighlightImage, for: .highlighted)
            btn .addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
        }
    }
    
    @objc private func btnClick(btn: UIButton) {
        // 执行闭包
        callBack!(btn)
    }
}
