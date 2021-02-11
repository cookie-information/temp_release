//
//  FontLoader.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 11/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import Foundation
import CoreText

final class FontLoader {
    static func loadFonts() {
        [
            "Rubik-Light",
            "Rubik-Medium",
            "Rubik-Regular",
            "Rubik-Bold"
        ].forEach(loadFont)
    }
    
    private static func loadFont(name: String) {
        guard let font = Bundle(for: FontLoader.self)
            .path(forResource: name, ofType: "ttf")
            .flatMap(NSData.init(contentsOfFile:))
            .flatMap(CGDataProvider.init(data:))
            .flatMap(CGFont.init)
        else {
            return
        }
        
        var error: Unmanaged<CFError>? = nil
        
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("Failed to register font: \(error?.takeUnretainedValue().localizedDescription ?? "")")
        }
    }
}
