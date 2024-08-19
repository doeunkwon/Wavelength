//
//  ScoreData.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-19.
//

import SwiftUI

struct ScoreData {
    
    var id = UUID()
    var date: Date
    var value: Double
}

func prepareChartData(from scores: [Score]) -> [ScoreData] {
    var chartData = [ScoreData]()
    for score in scores {
        chartData.append(ScoreData(date: score.timestamp, value: Double(score.percentage)))
    }
    return chartData
}
