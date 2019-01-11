//
//  LifeCellTableViewCell.swift
//  My Weather Diary
//
//  Created by zyh on 2019/1/11.
//  Copyright © 2019 njuzyh. All rights reserved.
//

import UIKit

class LifeCellTableViewCell: UITableViewCell {

    @IBOutlet weak var brf: UILabel!
    @IBOutlet weak var txt: UILabel!
    
    var weatherData: Lifestyle? {
        didSet {
            /// 给子视图赋值
            brf.text = weatherData!.brf
            txt.text = weatherData!.txt
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
        brf.textColor = mainColor
        txt.textColor = mainColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
