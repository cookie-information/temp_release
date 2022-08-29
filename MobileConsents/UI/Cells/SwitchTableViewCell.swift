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
    private var viewModel: SwitchCellViewModel?

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
    
    func setViewModel(_ viewModel: SwitchCellViewModel) {
        self.viewModel = viewModel
        
        setText(viewModel.text, isRequired: viewModel.isRequired)
        setIsSelected(viewModel.isRequired || viewModel.isSelected)
        uiSwitch.onTintColor = viewModel.accentColor
        uiSwitch.isEnabled = !viewModel.isRequired
        valueChanged = { [weak viewModel] isSelected in
            viewModel?.selectionDidChange(isSelected)
        }
        
        viewModel.onUpdate = { [weak self] viewModel in
            self?.setIsSelected(viewModel.isSelected)
        }
    }
    
    func setIsSelected(_ isSelected: Bool) {
        uiSwitch.isOn = isSelected
        
    }
    
    func setText(_ text: String, isRequired: Bool) {
        textView.htmlText = text + (isRequired ? "<b>*</b>" : "")
    }
    
    func setValue(_ value: Bool) {
        uiSwitch.isOn = value
    }
    
    private func setup() {
        selectionStyle = .none
        self.isSeparatorHidden = true
        uiSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        uiSwitch.onTintColor = .privacyCenterSwitch
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
            // Setting constraint to `uiSwitch.leadingAnchor` causes layout to
            // break when cell is reused
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -80),
            uiSwitch.centerYAnchor.constraint(equalTo: textView.firstBaselineAnchor),
            uiSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -29)
        ])
    }
    
    @objc private func switchValueChanged() {
        valueChanged?(uiSwitch.isOn)
    }
}
