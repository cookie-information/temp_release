//
//  ContentTableViewCell.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class ContentTableViewCell: BaseTableViewCell {
    private let textView = HTMLTextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        textView.htmlText = text
    }
    
    private func setup() {
        isSeparatorHidden = false
        
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.linkTextAttributes = [:]
        
        let bodyColor = UIColor.adaptive(light: .privacyCenterText, dark: .white)
        
        let fontSize = { UIFontMetrics(forTextStyle: .body).scaledValue(for: 13) }
        
        textView.style = [
            "body": [
                "font-family": "Rubik",
                "font-size": .init { "\(fontSize())px" },
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
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}

extension ContentTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print(URL)
        
        return true
    }
}
