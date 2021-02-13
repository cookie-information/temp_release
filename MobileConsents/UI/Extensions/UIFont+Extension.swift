//
//  UIFont+Extension.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 13/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

extension UIFont {
    static func regular(size: CGFloat) -> UIFont {
        fontWithFallback(name: "Rubik-Regular", size: size, fallbackWeight: .regular)
    }
    
    static func medium(size: CGFloat) -> UIFont? {
        fontWithFallback(name: "Rubik-Medium", size: size, fallbackWeight: .medium)
    }
    
    static func bold(size: CGFloat) -> UIFont? {
        fontWithFallback(name: "Rubik-Bold", size: size, fallbackWeight: .bold)
    }
    
    private static func fontWithFallback(name: String, size: CGFloat, fallbackWeight: UIFont.Weight) -> UIFont {
        UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: fallbackWeight)
    }
}
