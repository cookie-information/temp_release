//
//  PrivacyPopUpViewController.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 18/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PrivacyPopUpViewController: UIViewController {
    private let tableView = UITableView()
    
    private var sections: [Section] = [
        PopUpHeaderSection(),
        PopUpConsentsSection(),
        PopUpButtonsSection()
    ]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        ([
            PopUpHeaderSection.self,
            PopUpConsentsSection.self,
            PopUpButtonsSection.self
        ] as [Section.Type]).forEach { $0.registerCells(in: tableView) }
        
        tableView.dataSource = self
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
