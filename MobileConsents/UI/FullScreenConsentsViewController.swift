//
//  FullScreenConsentsViewController.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class FullScreenConsentsViewController: UIViewController {
    
    private let items: ItemCollection = ItemCollection(items: [
        LongTextItem(title: "Example title 1", text: String.loremIpsum(paragraphs: 1)),
        LongTextItem(title: "Example title 2", text: String.loremIpsum(paragraphs: 1)),
        LongTextItem(title: "Example title 3", text: String.loremIpsum(paragraphs: 1)),
        LongTextItem(title: "Example title 4", text: String.loremIpsum(paragraphs: 1)),
        SwitchItem(title: "Example switch 2", isOn: true),
        SwitchItem(title: "Example switch 1", isOn: false)
    ])
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setup()
    }
    
    private func setup() {
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
            LongTextItem.self,
            SwitchItem.self
        ] as [Item.Type]).forEach {
            $0.registerCells(in: tableView)
        }
    }
}

extension FullScreenConsentsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        items.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        items[indexPath].cell(for: indexPath, in: tableView)
    }
}

extension FullScreenConsentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        items[indexPath].height(forCellAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath].didSelectCell(at: indexPath, in: tableView)
    }
}
