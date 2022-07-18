//
//  BarChart.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 17/07/2022.
//


import SwiftUI

struct ChartData {
     var label: String
     var value: Bool
}

struct BarChartCell: View {
    
    var value: Bool
    var barColor: Color
                             
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(value ? barColor : .white)
            .frame(idealWidth: .infinity, maxWidth: .infinity, minHeight: 20, maxHeight: 20, alignment: .bottom)
    }
}

struct BarChart: View {
    var barColor: Color
    var data: [ChartData]

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(0..<data.count, id: \.self) { i in
                    Text(data[i].label.split(separator: " ").first ?? "")
                        .font(Font.custom(Helpers.fontName, size: 16))
                        .frame(height: 24)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                ForEach(0..<data.count, id: \.self) { i in
                    BarChartCell(value: data[i].value, barColor: barColor)
                        .frame(height: 24)
                }
            }
        }
    }
}
