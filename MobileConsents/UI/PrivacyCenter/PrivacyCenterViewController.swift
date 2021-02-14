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
        ConsentItemSection(title: "Example title 1", text: String.loremIpsum(paragraphs: 1)),
        ConsentItemSection(title: "Example title 2", text: String.loremIpsum(paragraphs: 1)),
        ConsentItemSection(title: "Example title 3", text: String.loremIpsum(paragraphs: 1)),
        ConsentItemSection(title: "Example title 4", text: String.loremIpsum(paragraphs: 1)),
        PreferencesSection(title: "Example switch 2", isOn: true)
    ]
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setup()
    }
    
    private func setup() {
        tableView.separatorInset = .zero
        tableView.separatorColor = .privacyCenterSeparator
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
