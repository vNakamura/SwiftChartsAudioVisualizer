//
//  ContentView.swift
//  SwiftChartsAudioVisualizer
//
//  Created by Vinicius Nakamura on 22/07/22.
//

import Charts
import SwiftUI

enum Constants {
    static let updateInterval = 0.05
    static let barAmount = 40
    static let magnitudeLimit: Float = 32
}

struct ContentView: View {
    let audioProcessing = AudioProcessing.shared
    let timer = Timer.publish(
        every: Constants.updateInterval,
        on: .main,
        in: .common
    ).autoconnect()

    @State var isPlaying = false
    @State var data: [Float] = Array(repeating: 0, count: Constants.barAmount)
        .map { _ in Float.random(in: 1 ... Constants.magnitudeLimit) }

    var body: some View {
        VStack {
            Chart(Array(data.enumerated()), id: \.0) { index, magnitude in
                BarMark(
                    x: .value("Frequency", String(index)),
                    y: .value("Magnitude", magnitude)
                )
            }
            .onReceive(timer, perform: updateData)
            .chartYScale(domain: 0 ... Constants.magnitudeLimit)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 100)

            Button(action: playButtonTapped) {
                Image(systemName: "\(isPlaying ? "pause" : "play").circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
        .padding()
    }

    func updateData(_: Date) {
        if isPlaying {
            withAnimation(.easeOut(duration: 0.08)) {
                data = audioProcessing.fftMagnitudes.map {
                    min($0, Constants.magnitudeLimit)
                }
            }
        }
    }

    func playButtonTapped() {
        if isPlaying {
            audioProcessing.player.pause()
        } else {
            audioProcessing.player.play()
        }
        isPlaying.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
