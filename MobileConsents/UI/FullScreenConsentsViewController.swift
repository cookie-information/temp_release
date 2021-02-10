//
//  FullScreenConsentsViewController.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

enum CellType {
    case header(String)
    case description(String)
}

final class FullScreenConsentsViewController: UIViewController {
    private let content: [CellType] = [
        .header("A"),
        .description(String.loremIpsum(paragraphs: 1))
    ]
    
    private let tableView = UITableView()
    
    private var isExpanded = true
    
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
        
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: "Header")
        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: "Content")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension FullScreenConsentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch content[indexPath.item] {
        case .header(let header):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath)
            
            (cell as? HeaderTableViewCell)?.setTitle("\(header) \(indexPath)")
            
            return cell
        case .description(let description):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath)
            
            (cell as? ContentTableViewCell)?.setText(description)
            
            return cell
        }
    }
}

extension FullScreenConsentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch content[indexPath.row] {
        case .header: return UITableView.automaticDimension
        case .description: return isExpanded ? UITableView.automaticDimension : .zero
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch content[indexPath.row] {
        case .header:
            isExpanded.toggle()
            
            tableView.beginUpdates()
            tableView.endUpdates()
        case .description:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

final class HeaderTableViewCell: UITableViewCell {
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        label.text = title
    }
    
    private func setup() {
        contentView.backgroundColor = .lightGray
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstrant = label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        bottomConstrant.priority = .fittingSizeLevel
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bottomConstrant,
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

final class ContentTableViewCell: UITableViewCell {
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        label.text = text
    }
    
    private func setup() {
        label.numberOfLines = 0
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
