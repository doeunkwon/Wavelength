//
//  ScoreViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-28.
//

import SwiftUI
import SwiftKeychainWrapper

class ScoreViewModel: ObservableObject {
    
    @Published var scores: [Score] = []
    @Published var scoreChartData: [ScoreData] = []
    @Published var latestScore: Score = Score(sid: "", timestamp: Date(), percentage: 0)
    @Published var highValue: Double = 0.0
    @Published var lowValue: Double = 0.0
    @Published var latestValue: Double = 0.0
    @Published var oldestValue: Double = 0.0
    @Published var trendValue: String = ""
    
    
    private let scoreService = ScoreService()
    
    func getFriendScores(fid: String) {
        print("API CALL: GET FRIEND SCORES")
        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        Task {
            do {
                let fetchedScores = try await scoreService.getFriendScores(fid: fid, bearerToken: bearerToken)
                DispatchQueue.main.async {
                    self.scores = fetchedScores
                    self.scoreChartData = prepareChartData(from: fetchedScores)
                    self.latestScore = self.scores.max(by: { $0.timestamp < $1.timestamp })
                    ?? Score(sid: "", timestamp: Date(), percentage: 0, breakdown: [0, 0, 0, 0])
                    self.highValue = self.scoreChartData.map { $0.value }.max() ?? 0
                    self.lowValue = self.scoreChartData.map { $0.value }.min() ?? 0
                    self.latestValue = self.scoreChartData.max(by: { $0.entry < $1.entry })?.value ?? 0
                    self.oldestValue = self.scoreChartData.min(by: { $0.entry < $1.entry })?.value ?? 0
                    let difference = self.latestValue - self.oldestValue
                    self.trendValue = "\(difference > 0 ? "+" : "")\(Int(difference))"
                }
            } catch {
                // Handle error
                print("Error fetching scores: \(error)")
            }
        }
    }
    
}
