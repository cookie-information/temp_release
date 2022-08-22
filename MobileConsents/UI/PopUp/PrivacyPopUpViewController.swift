//
//  PrivacyPopUpViewController.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 18/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PrivacyPopUpViewController: UIViewController {
    private let titleView = PopUpTitleView()
    private let tableView = UITableView()
    private lazy var buttonsView = { PopUpButtonsView(accentColor: accentColor) }()
    private let gradientContainer: GradientContainer<UITableView>
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let accentColor: UIColor
    private let viewModel: PrivacyPopUpViewModelProtocol
    
    private var sections = [Section]()
    
    init(viewModel: PrivacyPopUpViewModelProtocol, accentColor: UIColor) {
        self.viewModel = viewModel
        self.accentColor = accentColor
        gradientContainer = GradientContainer(
            tableView,
            config: .init(
                color: .popUpGradient,
                gradientHeight: 20,
                gradientHorizontalInset: 15,
                gradientBottomOffset: 2
            )
        )
        
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
        
        view.addSubview(titleView)
        view.addSubview(gradientContainer)
        view.addSubview(buttonsView)
        view.addSubview(activityIndicator)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        gradientContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientContainer.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            gradientContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
            self?.titleView.setText(data.title)
            self?.buttonsView.setButtonViewModels(data.buttonViewModels)
            self?.sections = data.sections
            self?.tableView.reloadData()
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
