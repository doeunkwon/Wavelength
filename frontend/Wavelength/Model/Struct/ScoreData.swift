//
//  ScoreData.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-19.
//

import SwiftUI

struct ScoreData {
    var id = UUID()
    var entry: Int
    var value: Double
}

func prepareChartData(from scores: [Score]) -> [ScoreData] {
//    let maxEntries = 20
    let sortedScores = scores.sorted { $0.timestamp < $1.timestamp }

    var chartData = [ScoreData]()
    var entryNumber = 0

    // Take the last 20 scores if there are more than 20
//    let scoresToProcess = sortedScores.count > maxEntries ? sortedScores.suffix(maxEntries) : sortedScores

//    // Fill with zeros if there are less than 20 scores
//    for _ in 0..<maxEntries - scoresToProcess.count {
//        chartData.append(ScoreData(entry: entryNumber, value: 0))
//        entryNumber += 1
//    }

    // Add actual scores
    for score in sortedScores {
        chartData.append(ScoreData(entry: entryNumber, value: Double(score.percentage)))
        entryNumber += 1
    }

    return chartData
}
