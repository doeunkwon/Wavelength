//
//  Errors.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

enum ScoreServiceError: Error {
    case networkError(Error)
    case unknownError(String)
}

enum BreakdownServiceError: Error {
    case networkError(Error)
    case unknownError(String)
}

enum AuthenticationServiceError: Error {
    case invalidCredentials
    case networkError(Error)
    case unknownError(String)
}

enum UserServiceError: Error {
    case unauthorized
    case networkError(Error)
    case unknownError(String)
}

enum FriendServiceError: Error {
    case networkError(Error)
    case unknownError(String)
}

enum MemoryServiceError: Error {
    case networkError(Error)
    case unknownError(String)
}
