//
//  CheckboxTableViewCell.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 18/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class CheckboxTableViewCell: UITableViewCell {
    private let checkbox = UIButton()
    private let textView = HTMLTextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String, isRequired: Bool) {
        textView.htmlText = text + (isRequired ? "<b>*</b>" : "")
    }
    
    private func setup() {
        selectionStyle = .none
        
        checkbox.setImage(UIImage(named: "checkbox", in: Bundle(for: Self.self), compatibleWith: nil), for: .normal)
        checkbox.setImage(UIImage(named: "checkboxSelected", in: Bundle(for: Self.self), compatibleWith: nil), for: .selected)
        
        checkbox.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.style = contentStyle
        
        contentView.addSubview(checkbox)
        contentView.addSubview(textView)
        
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkbox.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkbox.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5),
            textView.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func checkboxTapped() {
        checkbox.isSelected.toggle()
    }
}
