//
//  ActivityView.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 19/07/2022.
//

import SwiftUI
import UIKit

struct ActivityView: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        return vc
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}

