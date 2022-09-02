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

final class MobileConsentsSolutionViewController: BaseViewController {
    @IBOutlet private weak var identifierTextField: UITextField!
   
    
    private enum Constants {
        static let defaultLanguage = "EN"
        static let sampleIdentifier = "1d8ab51d-4423-4853-b05e-65802e63b886"
        static let buttonCornerRadius: CGFloat = 5.0
    }
    
    private var viewModel: MobileConsentSolutionViewModelProtocol = MobileConsentSolutionViewModel()
    
    private var language: String {
        Constants.defaultLanguage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let identifier = identifierTextField.text else { return }

        viewModel.showPrivacyPopUp(for: identifier)
    }
    private func setupAppearance() {
       
        
        identifierTextField.delegate = self
        identifierTextField.text = Constants.sampleIdentifier
        
    }
    
    @IBAction private func getAction() {
        view.endEditing(true)
    }
    
    @IBAction private func defaultIdentifierAction() {
        identifierTextField.text = Constants.sampleIdentifier
    }
    
    
    @IBAction private func showPopUpAction() {
        guard let identifier = identifierTextField.text else { return }
        
        viewModel.showPrivacyPopUp(for: identifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController, let savedDataViewController = navigationController.viewControllers.first as? SavedDataViewController else { return }
        
        savedDataViewController.savedItems = viewModel.savedConsents
    }
}

extension MobileConsentsSolutionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
