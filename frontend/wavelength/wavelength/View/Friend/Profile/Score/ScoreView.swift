//
//  ScoreView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-28.
//

import SwiftUI

struct ScoreView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var scoreViewModel: ScoreViewModel = ScoreViewModel()
    
    private let fid: String
    private let friendFirstName: String
    
    init(fid: String, friendFirstName: String) {
        self.fid = fid
        self.friendFirstName = friendFirstName
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                ScrollView (showsIndicators: false) {
                    VStack (alignment: .leading, spacing: Padding.xlarge) {
                        ScoreHeaderView(score: scoreViewModel.latestScore.percentage, friendFirstName: friendFirstName)
                        
                        VStack (alignment: .leading, spacing: Padding.medium) {
                            Text(Strings.score.progress)
                                .font(.system(size: Fonts.body))
                                .foregroundStyle(.wavelengthDarkGrey)
                            
                            DashboardView(
                                firstEntry: (
                                    Strings.score.change,
                                    scoreViewModel.trendValue
                                ),
                                firstEntryColor: TrendColor.from(value: scoreViewModel.trendValue),
                                secondEntry: (
                                    Strings.score.high,
                                    "\(Int(scoreViewModel.highValue))%"
                                ),
                                secondEntryColor: intToColor(value: Int(scoreViewModel.highValue)),
                                thirdEntry: (
                                    Strings.score.low,
                                    "\(Int(scoreViewModel.lowValue))%"
                                ),
                                thirdEntryColor: intToColor(value: Int(scoreViewModel.lowValue)),
                                lineGraphColor: intToColor(value: scoreViewModel.latestScore.percentage),
                                data: scoreViewModel.scoreChartData)
                        }
                        
                        SliderFieldView(
                            title: Strings.score.breakdown,
                            pairs: [
                                "Memories": scoreViewModel.breakdown.memory,
                                "Goals": scoreViewModel.breakdown.goal,
                                "Values": scoreViewModel.breakdown.value,
                                "Interests": scoreViewModel.breakdown.interest
                            ] /// pretty sketchy
                        )
                        
                    }
                    .padding(Padding.large)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.wavelengthBackground)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: { dismiss() }) {
                    DownButtonView()
                })
                
                if scoreViewModel.isLoading {
                    LoadingView()
                }
                
            }
        }
        .onAppear {
            scoreViewModel.getFriendScores(fid: fid)
        }
    }
}

#Preview {
    ScoreView(fid: "ce78e86b-bc41-41c2-9592-bc11c56839e0", friendFirstName: "Austin")
}
