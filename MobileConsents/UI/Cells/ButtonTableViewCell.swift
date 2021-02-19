//
//  ButtonTableViewCell.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 18/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class ButtonTableViewCell: UITableViewCell {
    private let button = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }
    
    func setButtonColor(_ color: UIColor) {
        button.setBackgroundImage(.resizableRoundedRect(color: color, cornerRadius: 4), for: .normal)
    }
    
    private func setup() {
        button.titleLabel?.font = .medium(size: 15)
        
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
