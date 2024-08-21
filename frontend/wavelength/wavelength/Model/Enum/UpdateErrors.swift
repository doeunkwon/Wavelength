//
//  UpdateErrors.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

enum MemoryUpdateError: Error {
  case encodingError(Error)
  case networkError(Error)
  case unknownError(String)
}
