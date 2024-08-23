//
//  DecodedUUID.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-22.
//

import SwiftUI

struct DecodedUID: Decodable {
    
    let uid: String
    
    enum CodingKeys: String, CodingKey {
        case uid
    }
}

struct DecodedFID: Decodable {
    
    let fid: String
    
    enum CodingKeys: String, CodingKey {
        case fid
    }
}

struct DecodedMID: Decodable {
    
    let mid: String
    
    enum CodingKeys: String, CodingKey {
        case mid
    }
}
