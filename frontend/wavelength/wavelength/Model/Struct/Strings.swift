//
//  Strings.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-18.
//

import SwiftUI

struct Strings {
    
    // MARK: - Authentication
    struct Authentication {
        static let login = "Log in"
        static let signUp = "Sign up"
        static let orCreateProfile = "Or create a profile"
        static let letsGetStarted = "Let's get you started."
        static let chooseStrongPassword = "Choose a strong password."
        static let tellUsAboutYourself = "Tell us about yourself."
        static let incorrectCredentials = "Incorrect username or password."
        static let password = "Password"
        static let currentPassword = "Current password"
        static let newPassword = "New password"
        static let confirmPassword = "Confirm password"
        static let changePassword = "Change password"
        static let passwordUpdated = "Your password has been updated."
        static let signInAgain = "You'll need to sign in again."
    }
    
    // MARK: - Profile
    struct Profile {
        static let edit = "Edit profile"
        static let created = "Your profile has been created."
        static let firstName = "First name"
        static let lastName = "Last name"
        static let username = "Username"
        static let email = "Email"
        static let emoji = "Emoji"
        static let pickEmoji = "Pick an emoji"
        static let chooseColor = "Choose a color"
        static let goals = "Goals"
        static let goalsAndAspirations = "Goals & aspirations"
        static let interests = "Interests"
        static let addInterest = "Add an interest"
        static let addValue = "Add a value"
        static let values = "Values"
        static func percentageScore(int: Int) -> String {return "\(int)% score"}
    }
    
    // MARK: - Memory
    struct Memory {
        static func memories(int: Int) -> String { return "\(int) Memories" }
        static let memories = "Memories"
        static let new = "New memory"
        static let title = "Title"
        static let content = "Content"
        static let date = "Date"
        static let add = "Add a memory"
        static let edit = "Edit memory"
        static let delete = "Delete memory"
        static let deleted = "Your memory has been deleted."
        static let deleteMessage = "This action cannot be undone."
    }
    
    // MARK: - Friends
    struct Friends {
        static let new = "New friend"
        static let add = "Add a friend"
        static let yourCircle = "Your circle"
    }
    
    // MARK: - Settings
    struct Settings {
        static let title = "Settings"
        static let edit = "Edit profile"
        static let changePassword = "Change password"
        static let delete = "Delete profile"
        static let logOut = "Log out"
        static let deleteMessage = "This action cannot be undone."
        static let deleteToast = "Your profile has been deleted."
        static let logOutMessage = "You'll need to sign in again."
    }
    
    // MARK: - Actions
    struct Actions {
        static let create = "Create"
        static let save = "Save"
        static let delete = "Delete"
        static let edit = "Edit"
        static let cancel = "Cancel"
        static let score = "Score"
        static let tapToEdit = "Tap to edit"
    }
    
    // MARK: - Score
    struct Score {
        static let buttonTitle = "Score Wavelength"
        static let overall = "Score"
        static let breakdown = "Breakdown"
        static let progress = "Progress"
        static let change = "Change"
        static let high = "High"
        static let low = "Low"
        static let analysis = "Analysis"
        static let updated = "Your score has been updated."
    }
    
    // MARK: - Errors
    struct Errors {
        static func online(message: String) -> String { return "Online Error: \(message)" }
        static func offline(message: String) -> String { return "Offline Error: \(message)" }
        static let invalidResponse: String = "Invalid response"
        static let serverError: String = "Server error"
        static let decodeFailed: String = "Failed to decode JSON"
        static let urlFailed: String = "Failed to create URL"
    }
    
    // MARK: - Dashboard
    struct Dashboard {
        static func tokens(str: String) -> String { return "\(str) Tokens" }
        static let tokens = "Tokens"
        static let memories = "Memories"
    }
    
    // MARK: - General
    struct General {
        static let cancel = "Cancel"
        static let versionInfo = "Version 0.1 • Made with ❤️ by Doeun"
        static let tokens = "Tokens"
    }
    
    // MARK: - Icons
    struct Icons {
        static let gear = "gear"
        static let gearshape = "gearshape"
        static let grid = "square.grid.2x2"
        static let bubble = "bubble"
        static let person = "person"
        static let lock = "lock"
        static let trash = "trash"
        static let doorOpen = "door.left.hand.open"
        static let arrowRight = "arrow.right"
        static let plus = "plus"
        static let slider = "slider.horizontal.3"
        static let chevronUp = "chevron.up"
        static let chevronDown = "chevron.down"
        static let chevronLeft = "chevron.left"
        static let chevronRight = "chevron.right"
        static let ellipsis = "ellipsis"
        static let pencil = "pencil"
        static let xmark = "xmark"
        static let personTwo = "person.2"
        static let icloudSlash = "icloud.slash"
        static let personDotted = "person.line.dotted.person"
        static let waveform = "waveform.path.ecg"
    }
    
    // MARK: - Images
    struct Images {
        static let wavelengthLogo = "wavelengthLogo"
    }
}
