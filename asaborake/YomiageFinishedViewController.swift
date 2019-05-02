//
//  YomiageFinishedViewController.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2019/04/30.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit
import GoogleMobileAds

class YomiageFinishedViewController: UIViewController {

    @IBOutlet var progressView: UIProgressView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    var countdownTimer: Timer!
    var countdownSeconds = 5
    var remainedTickCount = 0
    var timerIntervalSecounds = 0.1
    var totalTickCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBarController?.tabBar.isHidden = false
        navigationItem.hidesBackButton = true

        let banner = GoogleMobileAds()
        banner.createBannarView(view: bannerView, parent: self)

        totalTickCount = Int(Double(countdownSeconds) / Double(timerIntervalSecounds))
        remainedTickCount = totalTickCount
        startTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if (countdownTimer != nil) {
            countdownTimer.invalidate()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        progressView.progress = Float(Double(totalTickCount - remainedTickCount + 1) / Double(totalTickCount))
        
        // Finished ?
        if (remainedTickCount <= 0) {
            countdownTimer.invalidate()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
