//
//  CountdownView.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2019/04/30.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import Foundation
import CircleProgressView

class CountdownView : CircleProgressView {
    var countdownTimer: Timer!
    var countdownSeconds = 3
    var remainedTickCount = 0
    var timerIntervalSecounds = 0.1
    var totalTickCount = 0
    var tickHandler: ((_ remainedTickCount : Int)->Void)? = nil

    
    func start(timeSeconds : Int,intervalSeconds:Double,handler:@escaping ((Int)->Void)) {
        countdownSeconds = timeSeconds
        timerIntervalSecounds = intervalSeconds
        tickHandler = handler

        self.isHidden = false
        self.progress = 0.0
        totalTickCount = Int(Double(countdownSeconds) / Double(timerIntervalSecounds))
        remainedTickCount = totalTickCount
        startTimer()
    }
    
    func cancel() {
        stopTimer()
    }

    private func startTimer() {
        countdownTimer = Timer.scheduledTimer(
            timeInterval: timerIntervalSecounds,
            target: self,
            selector: #selector(self.timerCounter),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func timerCounter() {
        
        // Update progress
        remainedTickCount = remainedTickCount - 1
        self.progress = Double(totalTickCount - remainedTickCount + 1) / Double(totalTickCount)

        // Finished ?
        if (remainedTickCount <= 0) {
            stopTimer()
        }
        if (tickHandler != nil) {
            tickHandler!(remainedTickCount)
        }
    }
    
    func stopTimer() {
        if (countdownTimer != nil) {
            countdownTimer.invalidate()
            countdownTimer = nil
        }
    }
}
