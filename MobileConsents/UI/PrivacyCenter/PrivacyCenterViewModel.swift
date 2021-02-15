//
//  PrivacyCenterViewModel.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 15/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import Foundation

protocol PrivacyCenterViewModelProtocol: AnyObject {
    var onDataLoaded: (([Section]) -> Void)? { get set }
    
    func viewDidLoad()
    func acceptButtonTapped()
}

final class PrivacyCenterViewModel {
    var onDataLoaded: (([Section]) -> Void)?
}

extension PrivacyCenterViewModel: PrivacyCenterViewModelProtocol {
    func viewDidLoad() {
        let sections: [Section] = [
            ConsentItemSection(title: "Example title 1", text: ""),
            ConsentItemSection(title: "Example title 2", text: ""),
            ConsentItemSection(title: "Example title 3", text: ""),
            ConsentItemSection(title: "Example title 4", text: ""),
            PreferencesSection(isOn: [true, false, true, false])
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.onDataLoaded?(sections)
        }
    }
    
    func acceptButtonTapped() {
        print("Accept button tapped")
    }
}
