//
//  UIColor+Extension.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 13/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

extension UIColor {
    static let headerBackground = UIColor(hex: 0xF9F9F9)
    static let headerText = UIColor(hex: 0xA0A0A0)
    static let privacyCenterSeparator = UIColor(hex: 0xE4E8F0)
    static let privacyCenterAcceptButton = UIColor(hex: 0x2E5BFF)
    static let privacyCenterText = UIColor(hex: 0x596075)
    static let popUpOverlay = UIColor(hex: 0x384049, alpha: 0.6)
    static let popUpButton1 = UIColor(hex: 0xC1C1C1)
    static let popUpButton2 = UIColor.black
}

extension UIColor {
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        
        return String(format: "#%06x", rgb)
    }
    
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }

    static func adaptive(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark: return dark
                default: return light
                }
            })
        } else {
            return light
        }
    }
}
