//
//  HeaderTableViewCell.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class HeaderTableViewCell: UITableViewCell {
    private let label = UILabel()
    private let chevronIconView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        label.text = title
    }
    
    func setIsExpanded(_ isExpanded: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0.0) { [chevronIconView] in
            chevronIconView.transform = isExpanded ? .init(rotationAngle: -.pi / 2) : .identity
        }
        
        if isExpanded {
            label.attributedText = label.text.map {
                NSAttributedString(string: $0, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
            }
        } else {
            label.text = label.text
        }
    }
    
    private func setup() {
        chevronIconView.image = UIImage(named: "headerChevron", in: Bundle(for: Self.self), compatibleWith: nil)
        
        contentView.backgroundColor = .headerBackground
        label.textColor = .headerText
        label.font = .regular(size: 13)
        
        contentView.addSubview(label)
        contentView.addSubview(chevronIconView)
        label.translatesAutoresizingMaskIntoConstraints = false
        chevronIconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 29),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 27),
            chevronIconView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 9),
            chevronIconView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -27),
            chevronIconView.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
}
