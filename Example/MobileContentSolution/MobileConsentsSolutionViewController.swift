//
//  ViewController.swift
//  Example
//
//  Created by Jan Lipmann on 29/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import UIKit
import MobileConsentsSDK

enum MobileConsentsSolutionSectionType {
    case info
    case items
}

enum MobileConsentsSolutionCellType {
    case solutionDetails
    case consentItem
}

final class MobileConsentsSolutionViewController: UIViewController {
    @IBOutlet private weak var identifierTextField: UITextField!
    @IBOutlet private weak var languageTextField: UITextField!
    @IBOutlet private weak var getButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    private enum Constants {
        static let defaultLanguage = "EN"
        static let sampleIdentifier = "843ddd4a-3eae-4286-a17b-0e8d3337e767"
        static let buttonCornerRadius: CGFloat = 5.0
    }
    
    private var viewModel: MobileConsentSolutionViewModelProtocol = MobileConsentSolutionViewModel()
    
    private var language: String {
        guard let language = languageTextField.text, !language.isEmpty else { return Constants.defaultLanguage }
        
        return language
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    private func setupAppearance() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        getButton.layer.cornerRadius = Constants.buttonCornerRadius
    }
    
    @IBAction private func getAction() {
        fetchData()
    }
    
    @IBAction private func defaultIdentifierAction() {
        identifierTextField.text = Constants.sampleIdentifier
    }
}

extension MobileConsentsSolutionViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.rowsCount(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType: MobileConsentsSolutionCellType = viewModel.cellType(forIndexPath: indexPath) else { return UITableViewCell() }
        
        switch cellType {
        case .solutionDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: SolutionDetailsTableViewCell.identifier(), for: indexPath) as! SolutionDetailsTableViewCell
            if let solution = viewModel.consentSolution {
                cell.setup(withConsentsSolution: solution)
            }
            return cell
        case .consentItem:
            let cell: ConsentItemDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: ConsentItemDetailsTableViewCell.identifier(), for: indexPath) as! ConsentItemDetailsTableViewCell
            if let item = viewModel.item(forIndexPath: indexPath) {
                cell.setup(withConsentItem: item, language: language)
                cell.setCheckboxSelected(viewModel.isItemSelected(item))
            }
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MobileConsentsSolutionViewController {
    private func showError(_ error: Error) {
        let controller = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    private func fetchData() {
        guard let identifier = identifierTextField.text else { return }
        
        viewModel.fetchData(forIdentifier: identifier) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showError(error)
                } else {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension MobileConsentsSolutionViewController: ConsentItemDetailsTableViewCellDelegate {
    func consentItemDetailsTableViewCellDidSelectCheckBox(_ cell: ConsentItemDetailsTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell), let item = viewModel.item(forIndexPath: indexPath) else { return }

        viewModel.handleItemCheck(item)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
