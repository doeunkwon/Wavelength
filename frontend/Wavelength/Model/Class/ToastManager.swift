//
//  ToastManager.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-30.
//

import SwiftUI

class ToastManager: ObservableObject {
    
    @Published var toast: Toast? = nil
    
    func insertToast(style: ToastStyle, message: String) {
        toast = Toast(style: style, message: message)
    }
    
}
