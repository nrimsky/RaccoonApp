//
//  DateStartEndPicker.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 22/07/2022.
//

import SwiftUI

struct DateStartEndPicker: View {
    
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var noEndDate: Bool
    
    
    var body: some View {
        Group {
            if noEndDate {
                DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                Text("No end date")
                AppButton(type: .normal, onPress: {noEndDate = false}, text: "Add End Date")
            } else {
                DatePicker("Start Date", selection: $startDate, in: ...endDate, displayedComponents: [.date])
                DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: [.date])
                AppButton(type: .normal, onPress: {noEndDate = true}, text: "No End Date")
            }
        }
    }
}

