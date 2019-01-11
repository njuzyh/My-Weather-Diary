//
//  HourlyCellTableViewCell.swift
//  My Weather Diary
//
//  Created by zyh on 2019/1/11.
//  Copyright © 2019 njuzyh. All rights reserved.
//

import UIKit

class HourlyCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var txt: UILabel!
    @IBOutlet weak var tmp: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    var weatherData: HourlyForecast?
    {
        didSet {
    /// 给子视图赋值
        time.text = weatherData!.time
        txt.text = weatherData!.cond_txt
        tmp.text = weatherData!.tmp
        icon.image = WeatherData.getIcon(condcode: weatherData!.cond_code!)
        }
    }
    
    //var id: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.white
        /// 注册 xib
        print(time)
        time.textColor = mainColor
        txt.textColor = mainColor
        tmp.textColor = mainColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
