import UIKit
import MobileConsentsSDK

protocol MobileConsentSolutionViewModelProtocol {
    var consentSolution: ConsentSolution? { get }
    var savedConsents: [UserConsent] { get }
    var mobileConsentsSDK: MobileConsents { get }
    func showPrivacyPopUp(for identifier: String, style: PrivacyPopupStyle)
    func showPrivacyPopUpIfNeeded(for identifier: String)
    

}

final class MobileConsentSolutionViewModel: MobileConsentSolutionViewModelProtocol {
    public var mobileConsentsSDK = MobileConsents(clientID: "40dbe5a7-1c01-463a-bb08-a76970c0efa0",
                                                   clientSecret: "bfa6f31561827fbc59c5d9dc0b04bdfd9752305ce814e87533e61ea90f9f8da8743c376074e372d3386c2a608c267fe1583472fe6369e3fa9cf0082f7fe2d56d",
                                                   accentColor: .systemGreen,
                                                   fontSet: FontSet(largeTitle: .boldSystemFont(ofSize: 34),
                                                                    body: .monospacedSystemFont(ofSize: 14, weight: .regular),
                                                                    bold: .monospacedSystemFont(ofSize: 14, weight: .bold))
                                                                )
    
    
    
    private var selectedItems: [ConsentItem] = []
    private var language: String?
    private var items: [ConsentItem] {
        return consentSolution?.consentItems ?? []
    }
    
    private var sectionTypes: [MobileConsentsSolutionSectionType] {
        guard consentSolution != nil else { return [] }
    
        var sectionTypes: [MobileConsentsSolutionSectionType] = [.info]
        if !items.isEmpty {
            sectionTypes.append(.items)
        }
        return sectionTypes
    }

    var consentSolution: ConsentSolution?

    var savedConsents: [UserConsent] {
        return mobileConsentsSDK.getSavedConsents()
    }
    
    private var consent: Consent? {
        guard let consentSolution = consentSolution, let language = language else { return nil }
        
        let customData = ["email": "mobile@cookieinformation.com", "device_id": "824c259c-7bf5-4d2a-81bf-22c09af31261"]
        var consent = Consent(consentSolutionId: consentSolution.id, consentSolutionVersionId: consentSolution.versionId, customData: customData, userConsents: [UserConsent]())
        
        items.forEach { item in
            let selected = selectedItems.contains(where: { $0.id == item.id })
            let purpose = ProcessingPurpose(consentItemId: item.id, consentGiven: selected, language: language)
            consent.addProcessingPurpose(purpose)
        }
        
        return consent
    }
    
    
   
    
    func isItemSelected(_ item: ConsentItem) -> Bool {
        return selectedItems.contains(where: { $0.id == item.id })
    }
    
    func showPrivacyPopUp(for identifier: String, style: PrivacyPopupStyle = .standard) {
        // Display the popup and provide a closure for handling the user constent.
        // This completion closure is the place to display
        
        mobileConsentsSDK = MobileConsents(clientID: "40dbe5a7-1c01-463a-bb08-a76970c0efa0",
                                           clientSecret:" 68cbf024407a20b8df4aecc3d9937f43c6e83169dafcb38b8d18296b515cc0d5f8bca8165d615caa4d12e236192851e9c5852a07319428562af8f920293bc1db",
                                           accentColor: style.accentColor,
                                           fontSet: style.fontSet)
        
        mobileConsentsSDK.showPrivacyPopUp(forUniversalConsentSolutionId: identifier) { settings in
            settings.forEach { consent in
                switch consent.purpose {
                case .statistical: break
                case .functional: break
                case .marketing: break
                case .necessary: break
                case .custom(title: let title):
                    if title.lowercased() == "age consent" {
                        // handle user defined consent items such as age consent
                    }
                @unknown default:
                    break
                }
                print("Consent given for:\(consent.purpose): \(consent.isSelected)")
            }
        }
    }
    
    func showPrivacyPopUpIfNeeded(for identifier: String) {
        // Display the popup and provide a closure for handling the user constent.
        // This completion closure is the place to display
      
        mobileConsentsSDK.showPrivacyPopUpIfNeeded(forUniversalConsentSolutionId: identifier) { settings in
            settings.forEach { consent in
                switch consent.purpose {
                case .statistical: break
                case .functional: break
                case .marketing: break
                case .necessary: break
                case .custom(title: let title):
                    if title.lowercased() == "age consent" {
                        // handle user defined consent items such as age consent
                    }
                @unknown default:
                    break
                }
                print("Consent given for:\(consent.purpose): \(consent.isSelected)")
            }
        }
    }
    
}

struct PrivacyPopupStyle {
    var accentColor: UIColor
    var fontSet: FontSet
    
    static let standard: PrivacyPopupStyle = {
        PrivacyPopupStyle(accentColor: .systemBlue, fontSet: .standard)
    }()
    
    static let greenTerminal: PrivacyPopupStyle = {
        PrivacyPopupStyle(accentColor:.systemGreen , fontSet: FontSet(largeTitle:.monospacedSystemFont(ofSize: 26, weight: .bold),
                                                                      body: .monospacedSystemFont(ofSize: 14, weight: .regular),
                                                                      bold: .monospacedSystemFont(ofSize: 14, weight: .bold)))
    }()
    
    static let pink: PrivacyPopupStyle = {
        PrivacyPopupStyle(accentColor: .systemPink, fontSet: .standard)
    }()

}
