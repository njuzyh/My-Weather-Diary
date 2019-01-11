//
//  DailyCellTableViewCell.swift
//  My Weather Diary
//
//  Created by zyh on 2019/1/11.
//  Copyright © 2019 njuzyh. All rights reserved.
//

import UIKit

class DailyCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var txt: UILabel!
    @IBOutlet weak var tmpmin: UILabel!
    @IBOutlet weak var tmpmax: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    var weatherData: DailyForecast? {
        didSet {
            /// 给子视图赋值
            date.text = weatherData!.date
            txt.text = weatherData!.cond_txt_d
            tmpmin.text = weatherData!.tmp_min
            tmpmax.text = weatherData!.tmp_max
            icon.image = WeatherData.getIcon(condcode: weatherData!.cond_code_d!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    private func setupUI() {
        self.backgroundColor = UIColor.white
        /// 注册 xib
        date.textColor = mainColor
        txt.textColor = mainColor
        tmpmax.textColor = mainColor
        tmpmin.textColor = mainColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
