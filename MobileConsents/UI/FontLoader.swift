//
//  FontLoader.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 11/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import Foundation
import CoreText

private final class BundleLocator {}

enum FontLoader {
    static func loadFontsIfNeeded() {
        _ = loadFontsOnce
    }
    
    private static let loadFontsOnce: Void = {
        [
            "Rubik-Light",
            "Rubik-LightItalic",
            "Rubik-Medium",
            "Rubik-MediumItalic",
            "Rubik-Regular",
            "Rubik-Italic",
            "Rubik-Bold",
            "Rubik-BoldItalic"
        ].forEach(loadFont)
    }()
    
    private static func loadFont(name: String) {
        guard let font = Bundle(for: BundleLocator.self)
            .path(forResource: name, ofType: "ttf")
            .flatMap(NSData.init(contentsOfFile:))
            .flatMap(CGDataProvider.init(data:))
            .flatMap(CGFont.init)
        else {
            return
        }
        
        if !CTFontManagerRegisterGraphicsFont(font, nil) {
            NSLog("MobileConsentsSDK - failed to register font \(name). Font might be already loaded")
        }
    }
}
