import UIKit

protocol SwitchCellViewModel: AnyObject {
    var text: String { get }
    var isRequired: Bool { get }
    var isSelected: Bool { get }
    var onUpdate: ((SwitchCellViewModel) -> Void)? { get set }
    var accentColor: UIColor { get set }
    func selectionDidChange(_ isSelected: Bool)
}
