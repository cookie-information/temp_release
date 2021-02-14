//
//  SwitchTableViewCell.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class SwitchTableViewCell: UITableViewCell {
    var valueChanged: ((Bool) -> Void)?
    
    private let uiSwitch = UISwitch()
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        label.text = nil
        uiSwitch.isOn = false
        valueChanged = nil
    }
    
    func setTitle(_ title: String) {
        label.text = title
    }
    
    func setValue(_ value: Bool) {
        uiSwitch.isOn = value
    }
    
    private func setup() {
        selectionStyle = .none
        
        uiSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        contentView.addSubview(label)
        contentView.addSubview(uiSwitch)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            uiSwitch.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            uiSwitch.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            uiSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func switchValueChanged() {
        valueChanged?(uiSwitch.isOn)
    }
}
