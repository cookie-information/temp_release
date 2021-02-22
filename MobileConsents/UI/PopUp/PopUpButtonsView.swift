//
//  PopUpButtonsView.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 19/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

protocol PopUpButtonViewModelProtocol {
    var title: String { get }
    var color: UIColor { get }
    
    func onTap()
}

protocol PopUpButtonViewModelDelegate: AnyObject {
    func buttonTapped(type: PopUpButtonViewModel.ButtonType)
}

final class PopUpButtonViewModel: PopUpButtonViewModelProtocol {
    enum ButtonType {
        case privacyCenter
        case rejectAll
        case acceptAll
        case acceptSelected
    }
    
    let title: String
    let color: UIColor
    let type: ButtonType
    
    weak var delegate: PopUpButtonViewModelDelegate?
    
    init(title: String, color: UIColor, type: ButtonType) {
        self.title = title
        self.color = color
        self.type = type
    }
    
    func onTap() {
        delegate?.buttonTapped(type: type)
    }
}

final class PopUpButtonsView: UIView {
    private let stackView = UIStackView()
    
    private var viewModels = [PopUpButtonViewModelProtocol]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonViewModels(_ viewModels: [PopUpButtonViewModelProtocol]) {
        self.viewModels = viewModels
        
        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        viewModels
            .enumerated()
            .map(button)
            .forEach(stackView.addArrangedSubview)
    }
    
    private func setup() {
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    private func button(index: Int, viewModel: PopUpButtonViewModelProtocol) -> UIButton {
        let button = UIButton(type: .custom)
        
        button.tag = index
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        button.setTitle(viewModel.title, for: .normal)
        button.setBackgroundImage(.resizableRoundedRect(color: viewModel.color, cornerRadius: 4), for: .normal)
        button.titleLabel?.font = .medium(size: 15)
        
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }
    
    @objc private func buttonTapped(_ button: UIButton) {
        let index = button.tag
        let viewModel = viewModels[index]
        
        viewModel.onTap()
    }
}
