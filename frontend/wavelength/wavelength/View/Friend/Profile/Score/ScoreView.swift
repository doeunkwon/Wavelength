//
//  ScoreView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-28.
//

import SwiftUI

struct ScoreView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private let score: Int
    private let scoreChartData: [ScoreData]
    private let breakdown: [Int]
    private let friendFirstName: String
    
    init(score: Int, scoreChartData: [ScoreData], breakdown: [Int], friendFirstName: String) {
        self.score = score
        self.scoreChartData = scoreChartData
        self.breakdown = breakdown
        self.friendFirstName = friendFirstName
    }
    
    private var highValue: Double {
        return scoreChartData.max(by: { $0.value < $1.value })?.value ?? 0
    }
    
    private var lowValue: Double {
        return scoreChartData.min(by: { $0.value < $1.value })?.value ?? 0
    }
    
    private var latestValue: Double {
        return scoreChartData.max(by: { $0.entry < $1.entry })?.value ?? 0
    }
    
    private var oldestValue: Double {
        return scoreChartData.min(by: { $0.entry < $1.entry })?.value ?? 0
    }
    
    var body: some View {
        NavigationStack {
            ScrollView (showsIndicators: false) {
                VStack (alignment: .leading, spacing: Padding.xlarge) {
                    ScoreHeaderView(score: score, friendFirstName: friendFirstName)
                    
                    VStack (alignment: .leading, spacing: Padding.medium) {
                        Text(Strings.score.history)
                            .font(.system(size: Fonts.body))
                            .foregroundStyle(.wavelengthDarkGrey)
                        DashboardView(
                            firstEntry: (
                                Strings.score.trend,
                                (latestValue - oldestValue > 0 ? "+" : "") + "\(Int((latestValue - oldestValue) / oldestValue * 100))%"
                            ),
                            firstEntryColor: .green,
                            secondEntry: (
                                Strings.score.high,
                                "\(Int(highValue))%"
                            ),
                            secondEntryColor: intToColor(value: 84),
                            thirdEntry: (
                                Strings.score.low,
                                "\(Int(lowValue))%"
                            ),
                            thirdEntryColor: intToColor(value: 67),
                            lineGraphColor: intToColor(value: score),
                            data: scoreChartData)
                    }
                    
                    SliderFieldView(title: Strings.score.breakdown, pairs: ["Memories":breakdown[0], "Goals": breakdown[1], "Values": breakdown[2], "Interests":breakdown[3]])
                    
                }
                .padding(Padding.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.wavelengthBackground)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                DownButtonView()
            })
        }
    }
}

#Preview {
    ScoreView(score: 90, scoreChartData: Mock.scoreChartData, breakdown: [85, 95, 92, 88], friendFirstName: "Austin")
}
