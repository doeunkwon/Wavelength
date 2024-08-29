//
//  DashboardView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import SwiftUI
import Charts

struct DashboardView: View {
    
    let firstEntry: (String, String)
    let firstEntryColor: Color
    let secondEntry: (String, String)
    let secondEntryColor: Color
    let thirdEntry: (String, String)
    let thirdEntryColor: Color
    let lineGraphColor: Color
    let data: [ScoreData]
    
    init(firstEntry: (String, String), firstEntryColor: Color, secondEntry: (String, String), secondEntryColor: Color, thirdEntry: (String, String), thirdEntryColor: Color, lineGraphColor: Color, data: [ScoreData]) {
        self.firstEntry = firstEntry
        self.firstEntryColor = firstEntryColor
        self.secondEntry = secondEntry
        self.secondEntryColor = secondEntryColor
        self.thirdEntry = thirdEntry
        self.thirdEntryColor = thirdEntryColor
        self.lineGraphColor = lineGraphColor
        self.data = data
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: Padding.small) {
                        Text(firstEntry.0)
                            .font(.system(size: Fonts.body2))
                            .foregroundColor(.wavelengthDarkGrey)
                        Text(firstEntry.1)
                            .font(.system(size: Fonts.subtitle))
                            .foregroundColor(firstEntryColor)
                    }
                    .padding(Padding.medium)
                    Spacer()
                }
                DividerLineView(vertical: true)
                HStack {
                    VStack(alignment: .leading, spacing: Padding.small) {
                        Text(secondEntry.0)
                            .font(.system(size: Fonts.body2))
                            .foregroundColor(.wavelengthDarkGrey)
                        Text(secondEntry.1)
                            .font(.system(size: Fonts.subtitle))
                            .foregroundColor(secondEntryColor)
                    }
                    .padding(Padding.medium)
                    Spacer()
                }
                DividerLineView(vertical: true)
                HStack {
                    VStack(alignment: .leading, spacing: Padding.small) {
                        Text(thirdEntry.0)
                            .font(.system(size: Fonts.body2))
                            .foregroundColor(.wavelengthDarkGrey)
                        Text(thirdEntry.1)
                            .font(.system(size: Fonts.subtitle))
                            .foregroundColor(thirdEntryColor)
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
                        x: .value("", item.entry),
                        y: .value("", item.value)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    .interpolationMethod(.monotone)
                    .foregroundStyle(lineGraphColor)
                    .shadow(
                        color: ShadowStyle.glow(lineGraphColor).color,
                        radius: ShadowStyle.glow(lineGraphColor).radius,
                        x: ShadowStyle.glow(lineGraphColor).x,
                        y: ShadowStyle.glow(lineGraphColor).y)
                }
            }
            .chartYScale(domain: (data.min(by: { $0.value < $1.value })?.value ?? 0)...(data.max(by: { $0.value < $1.value })?.value ?? 0))
            .chartYAxis {AxisMarks(values: .automatic) {
                    AxisValueLabel()
                    .foregroundStyle(.wavelengthGrey)

                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(.wavelengthLightGrey)
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                }
            }
            .frame(height:Frame.dashboardBottom)
            .padding(Padding.large)
            
        }
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(.wavelengthLightGrey, lineWidth: Border.small)
        )
        .background(Color.wavelengthOffWhite)
        .cornerRadius(CornerRadius.medium)
    }
}
