//
//  ViewController.swift
//  My Weather Diary
//
//  Created by apple on 2018/11/12.
//  Copyright © 2018年 njuzyh. All rights reserved.
//

import UIKit
import CoreLocation
import HeWeather
import AFNetworking
import YYModel
import Pods_My_Weather_Diary

class ViewController: UIViewController {
    
    @IBOutlet weak var cityname: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherview: UIImageView!
    @IBOutlet weak var cityview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
   
}
