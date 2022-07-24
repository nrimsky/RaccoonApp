//
//  YearMonthCalendarView.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 18/07/2022.
//

import SwiftUI

struct YearMonthCalendarView: View {
    
    @State var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State var selectedMonth: String = Helpers.monthShortFormatter.string(from: Date())
    let months: [String] = Calendar.current.shortMonthSymbols
    @Binding var dateRange: Range<Date>
    
    var body: some View {
        // Year View
        VStack(spacing: 0) {
            Group {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .frame(width: 24.0)
                        .onTapGesture {
                            selectedYear -= 1
                            setPeriod(selectedMonth: selectedMonth)
                        }
                    Text(String(selectedYear)).foregroundColor(.white).font(Font.custom(Helpers.fontName, size: 21))
                        .transition(.move(edge: .trailing))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .frame(width: 24.0)
                        .onTapGesture {
                            selectedYear += 1
                            setPeriod(selectedMonth: selectedMonth)
                        }
                }.padding(.all, 12.0)
                    .background(Color.accentColor)
            }
            Group {
                ScrollView(.horizontal) {
                    HStack() {
                        ForEach(months, id: \.self) { item in
                            Text(item)
                                .font(Font.custom(Helpers.fontName, size: 18))
                                .foregroundColor((item == selectedMonth) ? .accentColor: .black)
                                .padding(.all, 12.0)
                                .onTapGesture {
                                    self.setPeriod(selectedMonth: item)
                                }
                        }
                    }
                }
            }
            Divider()
        }
        .onAppear() {
            selectedYear = Int(Helpers.yearShortFormatter.string(from: dateRange.lowerBound))!
            selectedMonth = Helpers.monthShortFormatter.string(from: dateRange.lowerBound)
        }
    }
    
    func setPeriod(selectedMonth: String) {
        self.selectedMonth = selectedMonth
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyy"
        let startDate = dateFormatter.date(from: "01/" + selectedMonth + "/" + String(selectedYear))
        let endDate = startDate?.endOfMonth()
        self.dateRange = .init(uncheckedBounds: (lower: startDate!, upper: endDate!))
    }
}

