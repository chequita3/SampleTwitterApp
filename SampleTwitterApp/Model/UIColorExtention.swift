//
//  UIColorExtention.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2022/01/15.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
