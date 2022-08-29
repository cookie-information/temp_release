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
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
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
}
