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
    let data: [LineChartData]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(Strings.dashboard.score)
                            .font(.system(size: Fonts.body2))
                            .foregroundColor(.wavelengthDarkGrey)
                            .padding(.bottom, Padding.xxsmall)
                        Text("\(scorePercentage)%")
                            .font(.system(size: Fonts.subtitle))
                            .foregroundColor(intToColor(value: scorePercentage))
                    }
                    .padding(Padding.medium)
                    Spacer()
                }
                DividerLineView(vertical: true)
                HStack {
                    VStack(alignment: .leading) {
                        Text(Strings.dashboard.tokens)
                            .font(.system(size: Fonts.body2))
                            .foregroundColor(.wavelengthDarkGrey)
                            .padding(.bottom, Padding.xxsmall)
                        Text((tokenCount > 0 ? "+" : "") + String(tokenCount))
                            .font(.system(size: Fonts.subtitle))
                            .foregroundColor(.wavelengthTokenOrange)
                    }
                    .padding(Padding.medium)
                    Spacer()
                }
                DividerLineView(vertical: true)
                HStack {
                    VStack(alignment: .leading) {
                        Text(Strings.dashboard.memories)
                            .font(.system(size: Fonts.body2))
                            .foregroundColor(.wavelengthDarkGrey)
                            .padding(.bottom, Padding.xxsmall)
                        Text(String(memoryCount))
                            .font(.system(size: Fonts.subtitle))
                            .foregroundColor(.wavelengthBlack)
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
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(intToColor(value: scorePercentage))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                }
            }
            .frame(height:Frame.dashboardBottom)
            .padding(.top, Padding.large)
            .padding(.horizontal, Padding.large)
            
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
    DashboardView(scorePercentage: 76, tokenCount: 52, memoryCount: 219, data: {
        let sampleDate = Date().startOfDay.adding(.month, value: -10)!
        var temp = [LineChartData]()
        
        for i in 0..<20 {
            let value = Double.random(in: 5...20)
            temp.append(
                LineChartData(
                    date: sampleDate.adding(.day, value: i)!,
                    value: value
                )
            )
        }
        
        return temp
    }())
}
