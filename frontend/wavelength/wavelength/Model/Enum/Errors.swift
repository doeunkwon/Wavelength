//
//  Errors.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI

enum ServiceError: LocalizedError {
    
    case unauthorized
    case onlineError(String)
    case offlineError(String)
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return Strings.Authentication.incorrectCredentials
        case .onlineError(let message):
            return "An online error occurred: \(message)"
        case .offlineError(let message):
            return "An offline error occurred: \(message)"
        }
    }
}
