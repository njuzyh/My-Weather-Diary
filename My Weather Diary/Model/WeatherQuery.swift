//
//  WeatherQuery.swift
//  My Weather Diary
//
//  Created by zyh on 2019/1/11.
//  Copyright © 2019 njuzyh. All rights reserved.
//

import HandyJSON
import Foundation

/// 请求数据完成通知
let WeatherDataNotificationName = Notification.Name(rawValue: "GetWeatherDataSuccessfuly")

class WeatherQuery {
    private let key = "&key=c68be47d0d4f4b8c872aaaba34661372"
    private let host = "https://free-api.heweather.net/s6/weather"
    
    
    /// 创建单例
    static let shared = WeatherQuery()
    
    /// 给外界提供 请求'天气数据'方法
    /// - Parameters:
    ///   - cityName: 城市名
    ///   - isUpdateData: 是否是首页更新数据（默认不是）
    class func weatherData(cityName: String, isUpdateData: Bool = false) {
        self.shared.getWeatherData(cityName: cityName, isUpdateData: isUpdateData)
    }
    
    
    func getWeatherData(cityName: String, isUpdateData: Bool = false){
        let querys = "?location=\(cityName)"
        let urlStr = host + querys + key
        //let urlStr = "https://free-api.heweather.net/s6/weather?location=beijing&key=c68be47d0d4f4b8c872aaaba34661372"
        // 带中文的URL创建 必须将编码方式改为utf8 否则 URL为空
        let encodedUrl = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: encodedUrl)
        
        
        guard let weatherData = NSData(contentsOf: url!) else { return }
        
        //将获取到的数据转为json对象
        let jsonData = try! JSON(data: weatherData as Data)
        
        let weatherjson = jsonData["HeWeather6"][0]
        //let dict = weatherjson.dictionaryObject as NSDictionary?
        print(weatherjson)
        
        //let weather = WeatherData.deserialize(from: dict) ?? WeatherData()
        let weather = JSONDeserializer<WeatherData>.deserializeFrom(json: weatherjson.rawString())
        
        print("天气数据请求完毕,请求城市 " + (weather!.basic!.location ?? "nil"))
        
        // 全局数据数组增加数据
        self.dataArrayaddData(data: weather!, isUpdateData: isUpdateData)
        // 数据请求完毕后 发送通知
        NotificationCenter.default.post(name: WeatherDataNotificationName, object: nil, userInfo: nil)
    }
    
    // MARK: 全局数据数组增加数据
    private func dataArrayaddData(data: WeatherData, isUpdateData: Bool = false) {
        
        guard var dataArr = dataArray else {
            // 若 dataArray为空 则初始化数组 并添加数据
            dataArray = []
            dataArray?.append(data)
            return
        }
        if isUpdateData == true {
            // 若是更新首页数据 且 数据数组存在同名城市数据 则 替换该数据
            for i in 0..<dataArr.count {
                if data.basic!.location == dataArr[i].basic!.location{
                    dataArr[i] = data
                    dataArray = dataArr
                    return
                }
            }
        }else {
            // 若不是更新首页数据 且 数据存在同名城市数据 则 删除该数据 将新数据插入0号位置
            for i in 0..<dataArr.count {
                if data.basic!.location == dataArr[i].basic!.location {
                    dataArr.remove(at: i)
                    dataArr.insert(data, at: 0)
                    dataArray = dataArr
                    return
                }
            }
            // 若数据量超过规定大小则删除末尾数据 插入新数据
            if dataArr.count == 4 {
                dataArr.removeLast()
            }
            dataArr.insert(data, at: 0)
        }
        dataArray = dataArr
    }
    
}
