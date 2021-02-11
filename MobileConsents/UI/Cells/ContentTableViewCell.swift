//
//  ContentTableViewCell.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class ContentTableViewCell: UITableViewCell {
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        label.text = text
    }
    
    private func setup() {
        label.numberOfLines = 0
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        
        bottomConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bottomConstraint,
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
