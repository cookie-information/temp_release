//
//  ContentTableViewCell.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class ContentTableViewCell: UITableViewCell {
    private let textView = HTMLTextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        let htmlString = "Lorem ipsum privacy <a href=\"https://www.apple.com\">I accept terms and conditions</a> The data collected includes:<br><ul><li>Your <b>shoe</b> <i>size</i></li><li>Your <b><em>head</em></b> size</li></ul>"
        
        textView.htmlText = htmlString
    }
    
    private func setup() {
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 18)
        textView.delegate = self
        textView.linkTextAttributes = [:]
        
        let bodyColor: UIColor
        
        if #available(iOS 13.0, *) {
            bodyColor = UIColor(dynamicProvider: { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark: return UIColor.white
                default: return UIColor.black
                }
            })
        } else {
            bodyColor = .black
        }
        
        textView.style = [
            "body": [
                "font-family": "Rubik",
                "font-size": "12pt",
                "color": .init { bodyColor.hexString }
            ],
            "a": [
                "font-weight": "bold",
                "text-decoration": "none",
                "color": .init { bodyColor.hexString }
            ],
            "li": [
                "list-style-position": "inside"
            ]
        ]
        
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
