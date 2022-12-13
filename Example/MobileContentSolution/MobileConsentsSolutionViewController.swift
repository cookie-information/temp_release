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
   
    @IBOutlet weak var showPrivacyCenterButton: UIBarButtonItem!
    
    private enum Constants {
        static let defaultLanguage = "EN"
        static let sampleIdentifier = "4113ab88-4980-4429-b2d1-3454cc81197b"
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

        viewModel.showPrivacyPopUpIfNeeded(for: identifier)
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
    
    @IBAction func openInAppBrowser() {
         let browser = WebViewController(consents: viewModel.mobileConsentsSDK)
        
        self.present(browser, animated: true)
    }
    
    @IBAction private func showPopUpAction() {
        guard identifierTextField.text != nil else { return }
        showSelection()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController, let savedDataViewController = navigationController.viewControllers.first as? SavedDataViewController else { return }
        
        savedDataViewController.savedItems = viewModel.savedConsents
    }
    
    private func showSelection() {
        let alert = UIAlertController(title: "Privacy popup style", message: "Please select a style", preferredStyle: .actionSheet)
        
        let popoverPresenter = alert.popoverPresentationController
        popoverPresenter?.barButtonItem = showPrivacyCenterButton
        
        alert.addAction(UIAlertAction(title: "Default", style: .default, handler: { (_) in
            self.viewModel.showPrivacyPopUp(for: Constants.sampleIdentifier, style: .standard)
        }))
        
        alert.addAction(UIAlertAction(title: "Green terminal", style: .default, handler: { (_) in
            self.viewModel.showPrivacyPopUp(for: Constants.sampleIdentifier, style: .greenTerminal)
        }))
        
        alert.addAction(UIAlertAction(title: "Pink", style: .default, handler: { (_) in
            self.viewModel.showPrivacyPopUp(for: Constants.sampleIdentifier, style: .pink)
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

extension MobileConsentsSolutionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
