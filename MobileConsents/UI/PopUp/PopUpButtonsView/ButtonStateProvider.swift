//
//  ButtonStateProvider.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 23/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import Foundation

protocol ButtonStateProvider: AnyObject {
    var isEnabled: Bool { get }
    var onChange: (() -> Void)? { get set }
}

final class ConstantButtonStateProvider: ButtonStateProvider {
    let isEnabled: Bool
    var onChange: (() -> Void)?
    
    init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
}

final class NotificationButtonStateProvider: ButtonStateProvider {
    var isEnabled: Bool { _isEnabled() }
    var onChange: (() -> Void)?
    
    private let _isEnabled: () -> Bool
    private let notificationCenter: NotificationCenter
    
    private var observationToken: Any?
    
    init(isEnabled: @escaping () -> Bool, notificationName: Notification.Name, notificationCenter: NotificationCenter = .default) {
        _isEnabled = isEnabled
        self.notificationCenter = notificationCenter
        
        observationToken = notificationCenter.addObserver(
            forName: notificationName,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.onChange?()
        }
    }
    
    deinit {
        if let observationToken = observationToken {
            notificationCenter.removeObserver(observationToken)
        }
    }
}
