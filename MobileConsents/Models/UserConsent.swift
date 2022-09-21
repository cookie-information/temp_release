import Foundation

/// UserConsent
public struct UserConsent {
    public let consentItem: ConsentItem
    public let purpose: ConsentPurpose
    public let isSelected: Bool
}

public enum ConsentPurpose {
    case necessary
    case marketing
    case functional
    case statistical
    case custom(title: String)
    
    public init(_ rawValue: String) {
        switch rawValue.lowercased() {
        case "strictly necessary": self = .necessary
        case "marketing": self = .marketing
        case "functional": self = .functional
        case "statistical": self = .statistical
        default: self = .custom(title: rawValue)
        }
    }
}
