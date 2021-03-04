//
//  SwitchTableViewCell.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class SwitchTableViewCell: BaseTableViewCell {
    var valueChanged: ((Bool) -> Void)?
    
    private let uiSwitch = UISwitch()
    private let textView = HTMLTextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textView.htmlText = nil
        uiSwitch.isOn = false
        valueChanged = nil
        isSeparatorHidden = true
    }
    
    func setText(_ text: String, isRequired: Bool) {
        textView.htmlText = text + (isRequired ? "<b>*</b>" : "")
    }
    
    func setValue(_ value: Bool) {
        uiSwitch.isOn = value
    }
    
    private func setup() {
        selectionStyle = .none
        
        uiSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        uiSwitch.onTintColor = .privacyCenterSwitch
        uiSwitch.thumbTintColor = .privacyCenterSwitchThumb
        
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainerInset = .zero
        textView.style = StyleConstants.textViewStyle
        
        contentView.addSubview(textView)
        contentView.addSubview(uiSwitch)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 27),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -80),
            uiSwitch.centerYAnchor.constraint(equalTo: textView.firstBaselineAnchor),
            uiSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -29)
        ])
    }
    
    @objc private func switchValueChanged() {
        valueChanged?(uiSwitch.isOn)
    }
}
