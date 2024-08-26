//
//  Errors.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

enum MemoryUpdateError: Error {
  case encodingError(Error)
  case networkError(Error)
  case unknownError(String)
}

enum ProfileUpdateError: Error {
  case encodingError(Error)
  case networkError(Error)
  case unknownError(String)
}

enum ScoreServiceError: Error {
    case unauthorized
    case networkError(Error)
    case unknownError(String)
}

enum AuthenticationServiceError: Error {
    case invalidCredentials
    case networkError(Error)
    case unknownError(String)
}
