//
//  Color_Ext.swift
//  SwiftUI_AnimatedLoading1
//
//  Created by Janice on 2025/10/26.
//

import SwiftUI

extension Color {
    init(r: Int, g: Int, b: Int, a: Int = 255) {
        let redValue = Double(r) / 255
        let greenValue = Double(g) / 255
        let blueValue = Double(b) / 255
        let alphaValue = Double(a) / 255
        
        self.init(red: redValue, green: greenValue, blue: blueValue, opacity: alphaValue)
    }
    
    /// Initializing Color using hexadecimal values
    /// - Parameter hex: Hex string
    /// 1st character: #
    /// 2nd~3rd characters: Red
    /// 4th~5th characters: Green
    /// 6th~7th characters: Blue
    /// 8th~9th characters: Alpha (transparency)
    /// Ex: UIColor(hex: "#777777") -> Opaque, UIColor(hex: "#77777777") -> Translucent
    init(hex: String) {
        var r: Double = 0, g: Double = 0, b: Double = 0, a: Double = 1

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                switch hexColor.count {
                case 6:
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    //a = 1
                case 8:
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                default:
                    break
                }
            }
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
        return
    }
}
