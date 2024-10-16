//
//  CommonFunctions.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import Foundation
import SwiftUI
import SwiftKeychainWrapper

func intToColor(value: Int) -> Color {
    let greenValue = CGFloat(value) / 100.0
    return Color(hue: greenValue / 3, saturation: 0.7, brightness: 0.8, opacity: 1.0)
}

func updateScore(user: User, friend: Friend) async throws {
    
    print("API CALL: UPDATE FRIEND")

    let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
    do {
        
        let llmScore: LLMScore = try await LLMService.shared.generateLLMScore(fid: friend.fid, bearerToken: bearerToken)
        
        let goalScore = llmScore.goal
        let valueScore = llmScore.value
        let interestScore = llmScore.interest
        let memoryScore = llmScore.memory
        let writtenAnalysis = llmScore.analysis
        let trimmedWrittenAnalysis = writtenAnalysis.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let friends = try await FriendService.shared.getFriends(bearerToken: bearerToken)
        
        let newFriendScore = (goalScore + valueScore + interestScore + memoryScore) / 4
        
        let friendsScoreSum = friends.reduce(0) { $0 + $1.scorePercentage }
        
        let oldFriendScore = friend.scorePercentage
        
        let newUserScore = (friendsScoreSum - oldFriendScore + newFriendScore) / friends.count
        
        _ = try await ScoreService.shared.createUserScore(newData: CodableScore(percentage: newUserScore), bearerToken: bearerToken)
        _ = try await ScoreService.shared.createFriendScore(newData: CodableScore(percentage: newFriendScore, analysis: trimmedWrittenAnalysis), fid: friend.fid, bearerToken: bearerToken)
        _ = try await BreakdownService.shared.updateBreakdown(fid: friend.fid, newData: CodableBreakdown(goal:goalScore, value: valueScore, interest: interestScore, memory: memoryScore), bearerToken: bearerToken)
        try await FriendService.shared.updateFriend(fid: friend.fid, newData: CodableFriend(scorePercentage: newFriendScore, scoreAnalysis: trimmedWrittenAnalysis), bearerToken: bearerToken)
        try await UserService.shared.updateUser(newData: CodableUser(scorePercentage: newUserScore), bearerToken: bearerToken)
        
        DispatchQueue.main.async {
            
            friend.scorePercentage = newFriendScore
            user.scorePercentage = newUserScore
            
        }
    } catch {
        throw error // Re-throw the error for caller handling
    }
}
