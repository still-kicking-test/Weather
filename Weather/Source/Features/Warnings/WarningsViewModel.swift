//
//  WarningsViewModel.swift
//  Warnings
//
//  Created by jonathan saville on 31/08/2023.
//
import Foundation
import Combine

class WarningsViewModel {
    
    @Published var toggleButtonName: String? = ButtonState.start
    @Published var counter = 0
    
    private enum ButtonState {
        static let start = "Start"
        static let pause = "Pause"
        static let resume = "Resume"
    }
    
    private weak var timer: Timer?
    
    deinit {
        timer?.invalidate()
    }

    func toggleTimer() {
        let isRunning = timer != nil
        if isRunning {
            timer?.invalidate()
            timer = nil
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in self.counter += 1 }
        }
        toggleButtonName = isRunning ? ButtonState.resume : ButtonState.pause
    }
}
