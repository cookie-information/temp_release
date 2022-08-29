//
//  PrivacyCenterViewController.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PrivacyCenterViewController: UIViewController {
    private var sections = [Section]()
    
    private let viewModel: PrivacyCenterViewModelProtocol
    private let tableView = UITableView()
    private let acceptButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    init(viewModel: PrivacyCenterViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        FontLoader.loadFontsIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else {
            return
        }
    }
    
    private func setup() {
        setupLayout()
        setupViewModel()
    }
    
    private func setupLayout() {
        view.backgroundColor = .privacyCenterBackground
        
        activityIndicator.color = .activityIndicator
        
        acceptButton.setTitleColor(.privacyCenterAcceptButtonTitle, for: .normal)
        acceptButton.setTitleColor(.privacyCenterAcceptButtonDisabledTitle, for: .disabled)

        acceptButton.titleLabel?.font = .medium(size: 15)        
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "xmark", in: Bundle(for: Self.self), compatibleWith: nil),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        ([
            ConsentItemSection.self,
            PreferencesSection.self
        ] as [Section.Type]).forEach {
            $0.registerCells(in: tableView)
        }
    }
    
    private func setupViewModel() {
        viewModel.onDataLoaded = { [weak self] data in
            guard let self = self else { return }
            
            self.setTitle(data.translations.title)
            self.acceptButton.setTitle(data.translations.acceptButtonTitle, for: .normal)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.acceptButton)
            self.sections = data.sections
            self.tableView.reloadData()
        }
        
        viewModel.onLoadingChange = { [weak self, activityIndicator] isLoading in
            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            self?.setInteractionEnabled(!isLoading)
        }
        
        viewModel.onError = { [weak self] alert in
            self?.showErrorAlert(alert)
        }
        
        viewModel.viewDidLoad()
    }
    
    private func setTitle(_ title: String) {
        navigationItem.titleView = nil
        
        let titleView = PrivacyCenterTitleView()
        titleView.text = title
        
        navigationItem.titleView = titleView
    }
    
    @objc private func acceptButtonTapped() {
        viewModel.acceptButtonTapped()
    }
    
    @objc private func backButtonTapped() {
        viewModel.backButtonTapped()
    }
}

extension PrivacyCenterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sections[indexPath.section].cell(for: indexPath, in: tableView)
    }
}

extension PrivacyCenterViewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].didSelectCell(at: indexPath, in: tableView)
    }
}

final class PrivacyCenterTitleView: UIView {
    private enum Constants {
        static let spacing: CGFloat = 10
    }
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    private let label = UILabel()
    private let chevronView = UIImageView(image: UIImage(named: "downChevron", in: Bundle(for: PrivacyCenterTitleView.self), compatibleWith: nil))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        label.font = .medium(size: 18)
        
        addSubview(label)
        addSubview(chevronView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.sizeToFit()
        
        label.frame.origin.x = 0
        label.center.y = bounds.midY
        
        chevronView.frame.origin.x = label.frame.maxX + Constants.spacing
        chevronView.center.y = bounds.midY
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelSize = label.sizeThatFits(size)
        let chevronSize = chevronView.sizeThatFits(size)
        
        return CGSize(
            width: labelSize.width + chevronSize.width + Constants.spacing,
            height: max(labelSize.height, chevronSize.height)
        )
    }
}
