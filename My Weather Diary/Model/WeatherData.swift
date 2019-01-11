//
//  WeatherData.swift
//  My Weather Diary
//
//  Created by zyh on 2018/12/5.
//  Copyright © 2018 njuzyh. All rights reserved.
//

import Foundation
import UIKit
import HandyJSON

/// document路径
let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
/// 天气数据路径
let dataArrPath = documentPath + "/dataArray.data"
/// 全局天气数据
var dataArray: [WeatherData]? = NSKeyedUnarchiver.unarchiveObject(withFile: dataArrPath) as? [WeatherData]

var weather : WeatherData = WeatherData()

class Weather{
    /// 城市
    var city: String?
    /// 日期
    var date: String?
    /// 天气
    var weather: String?
    /// 温度
    var temp: String?
    var temp_max: String?
    var temp_min: String?
    /// 湿度
    var humidity: String?
    /// 气压
    var pressure: String?
    /// 风速
    var windspeed: String?
    /// 风向
    var winddir: String?
    /// 风力
    var windpower: String?
    /// 更新时间
    var updatetime: String?
    /// 降水量
    var pcpn: String?
    /// 天气状态码
    var condcode: Int?
    /// 图标
    var icon: UIImage?
}

class WeatherData: HandyJSON{
    /// 生活指数
    var lifestyle: [Lifestyle]?
    /// 天气预报
    var daily_forecast: [DailyForecast]?
    var hourly: [HourlyForecast]?
    
    var update: Update?
    var now: CurrentWeather?
    var basic: Basic?
    
    
    required init() {}
    
    
    
    /// 根据天气类型返回天气图标
    ///
    /// - Parameters:
    ///   - weather: 天气类型
    ///   - isBigPic: 是否是大图（若为ture则 返回大图）
    /// - Returns: 返回天气图标
    
    class func getIcon(condcode: String) -> UIImage {
        if UIImage(named: condcode) == nil
        {
            return UIImage(named: "999")!
        }
        return UIImage(named: condcode)!
    }
}

class Basic: HandyJSON{
    var cid: String?
    var location: String?
    var lon: String?
    var lat: String?
    
    required init() {}
}

class Update: HandyJSON{
    var loc: String?
    
    required init() {}
}
class CurrentWeather: HandyJSON{
    /// 天气
    var cond_txt: String?
    /// 温度
    var tmp: String?
    /// 湿度
    var hum: String?
    /// 气压
    var pres: String?
    /// 风速
    var wind_spd: String?
    /// 风向
    var wind_dir: String?
    /// 风力
    var wind_sc: String?
    /// 降水量
    var pcpn: String?
    /// 天气状态码
    var cond_code: String?

    required init() {}
}

class Lifestyle: HandyJSON{
    /// 类型
    var type: String?
    /// 简介
    var brf: String?
    /// 具体
    var txt: String?
    
    required init() {}
}

/// 未来天气预报
class DailyForecast: HandyJSON{
    
    var date: String?
    var cond_code_d: String?
    var cond_txt_d: String?
    var tmp_max: String?
    var tmp_min: String?
    var hum: String?
    var pres: String?
    var wind_spd: String?
    var wind_dir: String?
    var pop: String?

    required init() {}
}

class HourlyForecast: HandyJSON{
    var time: String?
    var cond_code: String?
    var cond_txt: String?
    var tmp: String?
    var hum: String?
    var pres: String?
    var wind_spd: String?
    var wind_dir: String?
    var pop: String?
    
    required init() {}
}
