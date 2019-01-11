//
//  LocationManager.swift
//  My Weather Diary
//
//  Created by zyh on 2019/1/11.
//  Copyright © 2019 njuzyh. All rights reserved.
//

import Foundation
import CoreLocation

class MyLocation: NSObject {
    /// 单例
    static let shared = MyLocation()
    
    var locationManager = CLLocationManager()
    /// 定位城市
    var city: String = ""
    /// 完成回调
    var compeletion: (_ city: String) -> () = {_ in }
    /// 失败回调
    var failure: () -> () = {}
    
    class func getCurrentCity(compeletion: @escaping (_ city: String) -> (), failure: @escaping () -> () = {}) {
        shared.compeletion = compeletion
        shared.failure = failure
        shared.setupManager()
    }
    
    private func setupManager() {
        // 请求权限
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 开始定位
        locationManager.startUpdatingLocation()
    }
    
    // MARK: 经纬度 => 城市
    fileprivate func locationToCity(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, error) -> Void in
            DispatchQueue.main.async {
                if(error == nil)
                {
                    let mark = placemark![0]
                    let address = "\(mark.thoroughfare ?? ""), \(mark.locality ?? ""), \(mark.subLocality ?? ""), \(mark.administrativeArea ?? ""), \(mark.postalCode ?? ""), \(mark.country ?? "")"
                    //街道，城市，区划，省份，邮编，国家
                    print("\(address)")
                    print("定位详细信息 - \(mark)")
                    // 获取城市
                    let city = mark.locality
                    // 只发送一次通知
                    if self.city == "" || self.city == city {
                        self.city = city!
                        
                        // 执行成功回调
                        self.compeletion(city!)
                    }
                }
                else
                {
                    print("定位转换失败")
                    
                    // 执行失败回调
                    self.failure()
                    return
                }
            }
        }
    }
}

// MARK: CoreLocation代理方法
extension MyLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("定位信息为空")
            return
        }
        print("经度 - \(location.coordinate.latitude)")
        print("纬度 - \(location.coordinate.longitude)")
        locationToCity(location: location)
        
        // 停止定位
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败")
    }
}


