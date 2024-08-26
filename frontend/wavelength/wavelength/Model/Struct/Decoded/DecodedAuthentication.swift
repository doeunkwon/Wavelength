//
//  DecodedAuthentication.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-23.
//

import SwiftUI

struct DecodedAuthentication: Codable {
    
    let access_token: String
    let token_type: String
    
    enum CodingKeys: String, CodingKey {
        case access_token
        case token_type
    }
}
