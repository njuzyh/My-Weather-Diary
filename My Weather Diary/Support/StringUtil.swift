//
//  StringUtil.swift
//  My Weather Diary
//
//  Created by zyh on 2019/1/8.
//  Copyright © 2019 njuzyh. All rights reserved.
//

import Foundation


extension String {
    // MARK: 汉字 -> 拼音
    func chineseToPinyin() -> String {
        
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false)
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = stringRef as String
        
        return pinyin
    }
    
    // MARK: 判断是否含有中文
    func isIncludeChineseIn() -> Bool {
        
        for (_, value) in self.enumerated() {
            
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        
        return false
    }
    
    // MARK: 获取第一个字符
    func first() -> String {
        let index = self.index(self.startIndex, offsetBy: 1)
        return String(self[..<index])
    }
    
}
