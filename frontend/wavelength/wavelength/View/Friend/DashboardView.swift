//
//  DashboardView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import SwiftUI
import Charts

struct DashboardView: View {
    
    let scorePercentage: Int
    let tokenCount: Int
    let memoryCount: Int
    let data: [ScoreData]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: Padding.small) {
                        Text(Strings.dashboard.score)
                            .font(.system(size: Fonts.body2))
                            .foregroundColor(.wavelengthDarkGrey)
                        Text("\(scorePercentage)%")
                            .font(.system(size: Fonts.subtitle))
                            .foregroundColor(intToColor(value: scorePercentage))
                    }
                    .padding(Padding.medium)
                    Spacer()
                }
                DividerLineView(vertical: true)
                HStack {
                    VStack(alignment: .leading, spacing: Padding.small) {
                        Text(Strings.dashboard.tokens)
                            .font(.system(size: Fonts.body2))
                            .foregroundColor(.wavelengthDarkGrey)
                        Text((tokenCount > 0 ? "+" : "") + String(tokenCount))
                            .font(.system(size: Fonts.subtitle))
                            .foregroundColor(.wavelengthTokenOrange)
                    }
                    .padding(Padding.medium)
                    Spacer()
                }
                DividerLineView(vertical: true)
                HStack {
                    VStack(alignment: .leading, spacing: Padding.small) {
                        Text(Strings.dashboard.memories)
                            .font(.system(size: Fonts.body2))
                            .foregroundColor(.wavelengthDarkGrey)
                        Text(String(memoryCount))
                            .font(.system(size: Fonts.subtitle))
                            .foregroundColor(.wavelengthText)
                    }
                    .padding(Padding.medium)
                    Spacer()
                }
            }
            .frame(height:Frame.dashboardTop)
            DividerLineView()
            Chart {
                ForEach(data, id: \.id) { item in
                    LineMark(
                        x: .value("Weekday", item.date),
                        y: .value("Count", item.value)
                    )
                    .interpolationMethod(.catmullRom(alpha: 0.5))
                    .foregroundStyle(intToColor(value: scorePercentage))
                    .shadow(
                        color: ShadowStyle.glow(intToColor(value: scorePercentage)).color,
                        radius: ShadowStyle.glow(intToColor(value: scorePercentage)).radius,
                        x: ShadowStyle.glow(intToColor(value: scorePercentage)).x,
                        y: ShadowStyle.glow(intToColor(value: scorePercentage)).y)
                }
            }
            .chartYScale(domain: (data.min(by: { $0.value < $1.value })?.value ?? 0)...(data.max(by: { $0.value < $1.value })?.value ?? 0))
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                }
            }
            .frame(height:Frame.dashboardBottom)
            .padding(.horizontal, Padding.large)
            .padding(.bottom, Padding.large)
            .padding(.top, Padding.xlarge)
            
        }
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(.wavelengthLightGrey, lineWidth: Border.small)
        )
        .background(Color.wavelengthOffWhite)
        .cornerRadius(CornerRadius.medium)
    }
}

#Preview {
    DashboardView(scorePercentage: 76, tokenCount: 52, memoryCount: 219, data: Mock.scoreChartData)
}
