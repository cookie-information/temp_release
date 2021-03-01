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
        
        view.backgroundColor = .white
        
        setup()
    }
    
    private func setup() {
        setupLayout()
        setupViewModel()
    }
    
    private func setupLayout() {
        activityIndicator.color = .activityIndicator
        
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.titleLabel?.font = .medium(size: 15)
        acceptButton.contentEdgeInsets = .init(top: 2, left: 13, bottom: 2, right: 13)
        acceptButton.setBackgroundImage(.resizableRoundedRect(color: .privacyCenterAcceptButton, cornerRadius: 4), for: .normal)
        
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "backArrow", in: Bundle(for: Self.self), compatibleWith: nil),
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
            self?.view.isUserInteractionEnabled = !isLoading
        }
        
        viewModel.onAcceptButtonIsEnabledChange = { [weak self] isEnabled in
            self?.acceptButton.isEnabled = isEnabled
        }
        
        viewModel.viewDidLoad()
    }
    
    private func setTitle(_ title: String) {
        navigationItem.titleView = nil
        
        let label = UILabel()
        label.text = title
        label.font = .medium(size: 18)
        
        let imageView = UIImageView(image: UIImage(named: "downChevron", in: Bundle(for: Self.self), compatibleWith: nil))
        
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        stackView.layoutIfNeeded()
        stackView.sizeToFit()
        
        stackView.translatesAutoresizingMaskIntoConstraints = true
        
        navigationItem.titleView = stackView
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
