//
//  Task.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 23/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

enum Task {
    case request
  case requestWithParameters(parameters: Parameters, encoding: ParameterEncoding, headers: [String: String] = [:])
    
}
