//
//  Task.swift
//  MobileConsents
//
//  Created by Jan Lipmann on 23/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

enum Task {
    case request
    case requestWithParameters(parameters: Parameters, encoding: ParameterEncoding)
}
