//
//  ContentView.swift
//  SwiftChartsAudioVisualizer
//
//  Created by Vinicius Nakamura on 22/07/22.
//

import Charts
import SwiftUI

struct ContentView: View {
    @State var data: [Float] = Array(repeating: 0, count: 15)
        .map { _ in Float.random(in: 1 ... 20) }

    var body: some View {
        Chart(Array(data.enumerated()), id: \.0) { index, magnitude in
            BarMark(
                x: .value("Frequency", String(index)),
                y: .value("Magnitude", magnitude)
            )
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
