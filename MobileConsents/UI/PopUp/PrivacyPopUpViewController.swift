//
//  PrivacyPopUpViewController.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 18/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PrivacyPopUpViewController: UIViewController {
    private lazy var navigationBar = {
        let bar = UINavigationBar()
        bar.prefersLargeTitles = true
        bar.isTranslucent = false
        bar.delegate = self.viewModel
        bar.backgroundColor = .navigationBarbackground
        bar.items = [self.barItem]
        return bar
    }()
    
    private lazy var barItem: UINavigationItem = {
        let item = UINavigationItem()
        item.leftBarButtonItem = UIBarButtonItem(title: "Accept selected", style: .plain, target: self, action: #selector(acceptSelected))
        item.rightBarButtonItem = UIBarButtonItem(title: "Accept all", style: .plain, target: self, action: #selector(acceptAll))
        
        item.leftBarButtonItem?.tintColor = accentColor
        item.rightBarButtonItem?.tintColor = accentColor
        
        return item
    }()
    
    private lazy var readModeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(.init(key: "readMoreButton") + " >", for: .normal)
        btn.setTitleColor(accentColor, for: .normal)
        btn.addTarget(self, action: #selector(openProvacyPolicy), for: .touchUpInside)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return btn
    }()
    
    private lazy var privacyDescription: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let tableView = UITableView()
    private lazy var buttonsView = { PopUpButtonsView(accentColor: accentColor) }()
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let accentColor: UIColor
    private let viewModel: PrivacyPopUpViewModelProtocol
    private var sections = [Section]()
    
    init(viewModel: PrivacyPopUpViewModelProtocol, accentColor: UIColor) {
        self.viewModel = viewModel
        self.accentColor = accentColor
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupViewModel()
        
    }
    
    private func setupLayout() {
        view.backgroundColor = .popUpBackground
        
        activityIndicator.color = .activityIndicator
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(privacyDescription)
        view.addSubview(readModeButton)
        
        readModeButton.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        privacyDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            privacyDescription.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 15),
            privacyDescription.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            privacyDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            readModeButton.topAnchor.constraint(equalTo: privacyDescription.bottomAnchor, constant: 15),
            readModeButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            tableView.topAnchor.constraint(equalTo: readModeButton.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        ([
            PopUpDescriptionSection.self,
            PopUpConsentsSection.self
        ] as [Section.Type]).forEach { $0.registerCells(in: tableView) }
        
        tableView.dataSource = self
    }
    
    private func setupViewModel() {
        viewModel.onDataLoaded = { [weak self] data in
            self?.sections = data.sections
            self?.tableView.reloadData()
            self?.barItem.title = data.title
            self?.barItem.leftBarButtonItem?.title = data.saveSelectionButtonTitle
            
            self?.privacyDescription.text = data.privacyDescription
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
}

extension PrivacyPopUpViewController: UITableViewDataSource {
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

extension PrivacyPopUpViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PopUpPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
extension PrivacyPopUpViewController {
    @objc func acceptAll() {
        viewModel.acceptAll()
    }
    
    @objc func acceptSelected() {
        viewModel.acceptSelected()
    }
    
    @objc func openProvacyPolicy() {
        print("Privacy policy open")
    }
}

extension String {
    init(key: String) {
        self = NSLocalizedString(key, bundle: Bundle(for: PrivacyPopUpViewController.self), comment: "")
    }
}
