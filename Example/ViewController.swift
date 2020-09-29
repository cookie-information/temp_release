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
    var moblieConsentsSDK: MobileConsentsSDK?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moblieConsentsSDK = MobileConsentsSDK(withBaseURL: URL(string: "https://google.pl")!)
    }
}
