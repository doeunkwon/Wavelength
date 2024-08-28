//
//  ScoreView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-28.
//

import SwiftUI

struct ScoreView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView (showsIndicators: false) {
                VStack (alignment: .leading, spacing: Padding.xlarge) {
                    ScoreHeaderView(score: 78, friendFirstName: "Austin")
                    
                    VStack (alignment: .leading, spacing: Padding.medium) {
                        Text(Strings.score.history)
                            .font(.system(size: Fonts.body))
                            .foregroundStyle(.wavelengthDarkGrey)
                        DashboardView(
                            firstEntry: (Strings.score.trend, "+3%"),
                            firstEntryColor: .green,
                            secondEntry: (Strings.score.high, "84%"),
                            secondEntryColor: intToColor(value: 84),
                            thirdEntry: (Strings.score.low, "67%"),
                            thirdEntryColor: intToColor(value: 67),
                            lineGraphColor: intToColor(value: 78),
                            data: Mock.scoreChartData)
                    }
                    
                    SliderFieldView(title: Strings.score.breakdown, pairs: ["Memories":90, "Goals": 84, "Values": 68, "Interests":90])
                    
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
    ScoreView()
}
