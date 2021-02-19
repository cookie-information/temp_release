//
//  PopUpHeaderTableViewCell.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 18/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PopUpHeaderTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let descriptionTextView = HTMLTextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setDescription(_ description: String) {
        descriptionTextView.htmlText = description
    }
    
    private func setup() {
        titleLabel.font = .light(size: 28)
        
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.style = contentStyle
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionTextView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
}
