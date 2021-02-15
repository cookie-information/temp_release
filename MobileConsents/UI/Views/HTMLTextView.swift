//
//  HTMLTextView.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 12/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class HTMLTextView: UITextView {
    struct StyleValue: ExpressibleByStringLiteral {
        let expression: () -> String
        
        init(stringLiteral value: String) {
            self.expression = { value }
        }
        
        init(_ expression: @escaping () -> String) {
            self.expression = expression
        }
    }
    
    var style: [String: [String: StyleValue]] = [:] {
        didSet {
            updateHTML()
        }
    }
    
    var htmlText: String? {
        didSet {
            updateHTML()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            // Fixes crash caused by trait collection change when link in text view is tapped and external Safari opens
            DispatchQueue.main.async {
                self.updateHTML()
            }
        }
    }
    
    private func updateHTML() {
        guard let htmlText = htmlText else {
            attributedText = nil
            
            return
        }
        
        let htmlTemplate = """
            <!doctype html>
            <html>
              <head>
                <style>
                  \(css(from: style))
                </style>
              </head>
              <body>
                \(htmlText)
              </body>
            </html>
            """
        
        attributedText = NSAttributedString.fromHTML(htmlTemplate)
    }
    
    private func css(from style: [String: [String: StyleValue]]) -> String {
        var css = ""
        
        for (tag, styles) in style {
            css += tag + "{"
            
            for (key, value) in styles {
                css += key + ":" + value.expression() + ";"
            }
            
            css += "}"
        }
        
        return css
    }
}

private extension NSAttributedString {
     static func fromHTML(_ html: String) -> NSAttributedString? {
        guard let data = html.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) else { return nil }
        
        if attributedString.string.last == "\n" {
            attributedString.deleteCharacters(in: NSRange(location: attributedString.length - 1, length: 1))
        }
        
        return attributedString
    }
}
