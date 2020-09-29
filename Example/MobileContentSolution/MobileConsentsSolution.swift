//
//  ViewController.swift
//  Example
//
//  Created by Jan Lipmann on 29/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import UIKit
import MobileConsentsSDK

class MobileConsentsSolution: UIViewController {
    var mobileConsentsSDK: MobileConsentsSDK?
    
    @IBOutlet private weak var identifierTextField: UITextField!
    @IBOutlet private weak var getButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    private var consentSolution: ConsentSolution?
    private var selectedItems: [ConsentItem] = []
    
    private var items: [ConsentItem] {
        return consentSolution?.consentItems ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileConsentsSDK = MobileConsentsSDK(withBaseURL: URL(string: "https://google.pl")!)
        setupAppearance()
    }
    
    private func setupAppearance() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        getButton.layer.cornerRadius = 5.0
    }
    
    @IBAction private func getAction() {
        fetchData()
    }
    
    @IBAction private func defaultIdentifierAction() {
        identifierTextField.text = "843ddd4a-3eae-4286-a17b-0e8d3337e767"
    }
}

extension MobileConsentsSolution: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ConsentItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ConsentItemTableViewCellIdentifier", for: indexPath) as! ConsentItemTableViewCell
        if let item = items[safe: indexPath.row] {
            cell.setup(withConsentItem: item)
            cell.setCheckboxSelected(selectedItems.contains(where: { $0.id == item.id }))
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MobileConsentsSolution {
    private func showError(_ error: Error) {
        let controller = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    private func fetchData() {
        guard let identifier = identifierTextField.text else { return }
        
        mobileConsentsSDK?.fetchConsentSolution(forUniversalConsentSolutionId: identifier, completion: { [weak self] solution, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showError(error)
                }
                return
            }
            
            self?.consentSolution = solution
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        })
    }
}

extension MobileConsentsSolution: ConsentItemTableViewCellDelegate {
    func consentItemTableViewCellDidSelectCheckBox(_ cell: ConsentItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell), let item = items[safe: indexPath.row] else { return }
        
        if let index = selectedItems.firstIndex(where: { $0.id == item.id }) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
