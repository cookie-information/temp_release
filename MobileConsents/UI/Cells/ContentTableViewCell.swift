//
//  ContentTableViewCell.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class ContentTableViewCell: UITableViewCell {
    private let textView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
//        textView.text = text
        
        let htmlString = "<a href=\"https://www.apple.com\">Visit website</a> The data collected includes:<br><ul><li>Your <b>shoe</b> size</li></ul>"
        
        textView.setHTMLText(htmlString)
    }
    
    private func setup() {
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 18)
        textView.delegate = self
        textView.linkTextAttributes = [:]
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        
        bottomConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bottomConstraint,
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

extension ContentTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print(URL)
        
        return false
    }
}

extension NSAttributedString {
     static func fromHTML(_ html: String) -> NSAttributedString? {
        guard let data = html.data(using: .utf8) else {
            return nil
        }
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        return try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        )
    }
}

extension UITextView {
    func setHTMLText(_ htmlText: String) {
        let htmlTemplate = """
            <!doctype html>
            <html>
              <head>
                <style>
                  body {
                    font-family: -apple-system;
                    font-size: 12pt;
                  }
                  a {
                    font-weight: bold;
                    text-decoration: none;
                    color: black;
                  }
                  li {
                    list-style-position: inside;
                  }
                </style>
              </head>
              <body>
                \(htmlText)
              </body>
            </html>
            """
        
        attributedText = NSAttributedString.fromHTML(htmlTemplate)
    }
}
