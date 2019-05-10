//
//  AJFunction.swift
//  EcoLife
//
//  Created by 姚逸晨 on 7/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import Foundation
import UIKit


func NEWFITSCALEX(_ args : CGFloat) -> CGFloat {
    return (ScreenW/414 * args * 1000)/1000.0
}
func NEWTEXTFONTSIZE(_ args : CGFloat) -> CGFloat {
    return  IS_IPHONE_5_LESS ? args * 0.9 : NEWFITSCALEX( args)
    
}
public  let ScreenW =  UIScreen.main.bounds.size.width
public  let ScreenH = UIScreen.main.bounds.size.height
public  let ScreenH_safe = iPhoneX == true  ? ScreenH - 34 : ScreenH

public let IS_IPHONE_5_LESS = ScreenH <= 568 ? true : false
public let IS_IPHONE_4 = ScreenH < 568.0 ? true : false
public let IS_IPHONE_5 = ScreenH == 568.0 ? true : false
public let IS_IPHONE_6 = ScreenH == 667.0 ? true : false
public let IS_IPHONE_6P = ScreenH == 736.0 ? true : false
public let iPhoneX : Bool = (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0) || (UIScreen.main.bounds.width == 414.0 && UIScreen.main.bounds.height == 896.0) || (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 896.0)  ? true : false  //x  xsM  xr  的尺寸

public let tabBarH : CGFloat = UIScreen.main.bounds.height == 812.0  ? 83.00 : 49.00
public let offsetX_heng : CGFloat = iPhoneX == true  ? 30.00 : 0.00 //刘海大致估计高度29 空出刘海高
//var navStatusBarH_heng : CGFloat = iPhoneX == true ? 32 : 44  //32
public let statusBarH : CGFloat = iPhoneX == true  ? 44.00 : 20.00
public let navStatusBarH : CGFloat = iPhoneX == true  ? 88.00 : 64.00
public let navBarH : CGFloat = iPhoneX == true  ? 44.00 : 44.00


var GRAY_BACKGROUND_COLOR = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)//灰底色
var MASK_BACkGROUND_COLOR = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)//遮挡
extension UIColor {
    
    
    class func colorWithHexString(color : String) -> UIColor{
        
        return self.colorWithHexString(color: color, alpha: 1.0)
        
        
    }
    class func colorWithHexString(color : String , alpha : CGFloat) -> UIColor{
        //删除字符串中的空格
        var  cString = color
        
        // String should be 6 or 8 characters
        if cString.lengthOfBytes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) < 6{
            return UIColor.clear
        }
        //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        if cString.hasPrefix("0x") {
            cString = (cString as NSString).substring(from: 2)
        }
        //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        if cString.lengthOfBytes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) !=  6{
            return UIColor.clear
        }
        
        
        // Separate into r, g, b substrings
        var range : NSRange = NSRange(location: 0, length: 2)
        //r
        let rString = (cString as NSString).substring(with: range)
        //g
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        //b
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        let r  = hexTodec(num: rString)
        let g  = hexTodec(num: gString)
        let b  = hexTodec(num: bString)
        return UIColor.init(red:  CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
        //UIColor(colorLiteralRed: Float(r) / 255.0, green: Float(g) / 255.0, blue: Float(b) / 255.0, alpha: Float(alpha))
    }
    
    // MARK: - 十六进制转十进制
    class func hexTodec(num:String) -> Int {
        let str = num.uppercased()//大写
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
}

