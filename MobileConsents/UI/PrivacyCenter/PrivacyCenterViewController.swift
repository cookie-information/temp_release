//
//  PrivacyCenterViewController.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PrivacyCenterViewController: UIViewController {
    private let sections: [Section] = [
        ConsentItemSection(title: "Example title 1", text: ""),
        ConsentItemSection(title: "Example title 2", text: ""),
        ConsentItemSection(title: "Example title 3", text: ""),
        ConsentItemSection(title: "Example title 4", text: ""),
        PreferencesSection(isOn: [true, false, true, false])
    ]
    
    private let tableView = UITableView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
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
        let acceptButton = UIButton()
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.titleLabel?.font = .medium(size: 15)
        acceptButton.contentEdgeInsets = .init(top: 2, left: 13, bottom: 2, right: 13)
        acceptButton.setBackgroundImage(.resizableRoundedRect(color: .privacyCenterAcceptButton, cornerRadius: 4), for: .normal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: acceptButton)
        
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
        
        tableView.dataSource = self
        tableView.delegate = self
        
        ([
            ConsentItemSection.self,
            PreferencesSection.self
        ] as [Section.Type]).forEach {
            $0.registerCells(in: tableView)
        }
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
