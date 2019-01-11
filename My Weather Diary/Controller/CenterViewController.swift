//
//  DrawerViewController.swift
//  My Weather Diary
//
//  Created by zyh on 2018/12/2.
//  Copyright © 2018 njuzyh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVKit
import AVFoundation

class CenterViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var cityview: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var cityname: UILabel!
    @IBOutlet weak var weatherview: UIImageView!
    
    var delegate: CenterViewControllerDelegate?
    var temperature: String?
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    var locality: String?
    
    let apiId = "80697a31b403e5973752c4b6331206b5"
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    
    override func viewDidLoad() {
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    @IBAction func triggerMenu(_ sender: Any) {
        self.delegate?.toggleLeftPanel!()
    }
    
    @IBAction func triggerCity(_ sender: Any) {
        self.performSegue(withIdentifier: "displayCity", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayCity" {
            if segue.destination is CityViewController {
                print("city")
            }
        }
        else if segue.identifier == "displayMenu"
        {
            if segue.destination is MenuViewController {
                print("menu")
            }
        }
        else if segue.identifier == "displayAV"{
            if let vc = segue.destination as? AVPlayerViewController {
                vc.player = AVPlayer(url: NSURL(string: "https://v.qq.com/x/page/d07886sjb6g.html")! as URL)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. 還沒有詢問過用戶以獲得權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus() == .denied {
            showAlert("Location services were previously denied. Please enable location services for this app in Settings.")
        }
        // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //取得locations数组的最后一个
        let location:CLLocation = locations.last!
        //判断是否为空
        if(location.horizontalAccuracy > 0){
            locationManager.stopUpdatingLocation()
            print(location)
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            print("经度:\(long!)")
            print("纬度:\(lat!)")
            //getForcastWeatherData()
            LonLatToCity()
        }
    }
    
    //出现错误
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print(error!)
        cityname.text = "找不到所在地"
    }
    
    func getlocation(placemark: CLPlacemark) {
        // Do stuff with placemark
        self.locality = placemark.locality!
        weatherData.city = placemark.locality!
        getCurrentWeatherData()
        updateWeatherData()
    }
    
    ///将经纬度转换为城市名
    func LonLatToCity() {
        let currLocation:CLLocation = CLLocation(latitude: lat!, longitude: long!)
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in
            DispatchQueue.main.async {
                if(error == nil)
                {
                    let mark = placemark![0]
                    let address = "\(mark.thoroughfare ?? ""), \(mark.locality ?? ""), \(mark.subLocality ?? ""), \(mark.administrativeArea ?? ""), \(mark.postalCode ?? ""), \(mark.country ?? "")"
                    //街道，城市，区划，省份，邮编，国家
                    print("\(address)")
                    print("\(String(describing: self.locality))")
                    self.getlocation(placemark: placemark![0])
                    //self.cityname.text = self.locality
                }
                else
                {
                    print(error!)
                }
            }
        }
    }
    
    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateWeatherData()
    {
        print(weatherData.city)
        //cityname.text = "\(weatherData.city)"
        //temp.text = "\(weatherData.temperature)" + "°C"
    }
    
    func getCurrentWeatherData(){
        //let tempcity = "nanjing"
        //let urlStr = "http://api.openweathermap.org/data/2.5/weather?q=\(self.locality ?? tempcity)&units=metric&appid=\(apiId)"
        let urlStr = "http://api.openweathermap.org/data/2.5/weather?lat=\(self.lat ?? 35)&lon=\(self.long ?? 139)&units=metric&appid=\(apiId)"
        let url = NSURL(string: urlStr)!
        guard let weatherData = NSData(contentsOf: url as URL) else { return }
        
        //将获取到的数据转为json对象
        let jsonData = try! JSON(data: weatherData as Data)
        print(jsonData)
        
        //日期格式化输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        
        //self.cityname.text
        let city = "\(jsonData["name"].string!)"
        print("地点：\(city)")
        
        let weather = jsonData["weather"][0]["main"].string!
        print("天气：\(weather)")
        let weatherDes = jsonData["weather"][0]["description"].string!
        print("详细天气：\(weatherDes)")
        
        let temp = jsonData["main"]["temp"].number!
        //self.weatherData.temperature = temp
        print("温度：\(temp)°C")
        
        let humidity = jsonData["main"]["humidity"].number!
        print("湿度：\(humidity)%")
        
        let pressure = jsonData["main"]["pressure"].number!
        print("气压：\(pressure)hpa")
        
        let windSpeed = jsonData["wind"]["speed"].number!
        print("风速：\(windSpeed)m/s")
        
        let lon = jsonData["coord"]["lon"].number!
        let lat = jsonData["coord"]["lat"].number!
        print("坐标：[\(lon),\(lat)]")
        
        let timeInterval1 = TimeInterval(truncating: jsonData["sys"]["sunrise"].number!)
        let date1 = NSDate(timeIntervalSince1970: timeInterval1)
        print("日出时间：\(dformatter.string(from: date1 as Date))")
        
        let timeInterval2 = TimeInterval(truncating: jsonData["sys"]["sunset"].number!)
        let date2 = NSDate(timeIntervalSince1970: timeInterval2)
        print("日落时间：\(dformatter.string(from: date2 as Date))")
        
        let timeInterval3 = TimeInterval(truncating: jsonData["dt"].number!)
        let date3 = NSDate(timeIntervalSince1970: timeInterval3)
        print("数据时间：\(dformatter.string(from: date3 as Date))")
    }

    //获取未来天气数据（北京）
    func getForcastWeatherData(){
        //let city = "nanjing"
        let urlStr = "http://api.openweathermap.org/data/2.5/forecast?q=\(self.locality)&units=metric&appid=\(apiId)"
        let url = NSURL(string: urlStr)!
        guard let weatherData = NSData(contentsOf: url as URL) else { return }
        
        //将获取到的数据转为json对象
        let weatherJson = try! JSON(data: weatherData as Data)
        
        print("城市：\(weatherJson["city"]["name"].string!)")
        
        let lon = weatherJson["city"]["coord"]["lon"].number!
        let lat = weatherJson["city"]["coord"]["lat"].number!
        print("坐标：[\(lon),\(lat)]")
        
        //日期格式化输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        
        //遍历数据
        for (_,jsonData):(String, JSON) in weatherJson["list"] {
            let timeInterval = TimeInterval(truncating: jsonData["dt"].number!)
            let date = NSDate(timeIntervalSince1970: timeInterval)
            print("--- 时间：\(dformatter.string(from: date as Date)) ---")
            
            let weather = jsonData["weather"][0]["main"].string!
            print("天气：\(weather)")
            let weatherDes = jsonData["weather"][0]["description"].string!
            print("详细天气：\(weatherDes)")
            
            let temp = jsonData["main"]["temp"].number!
            print("温度：\(temp)°C")
            
            let humidity = jsonData["main"]["humidity"].number!
            print("湿度：\(humidity)%")
            
            let pressure = jsonData["main"]["pressure"].number!
            print("气压：\(pressure)hpa")
            
            let windSpeed = jsonData["wind"]["speed"].number!
            print("风速：\(windSpeed)m/s")
        }
    }
}
