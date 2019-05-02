//
//  YomiageViewController.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2017/10/01.
//  Copyright © 2017年 Yuji Ogihara. All rights reserved.
//

import UIKit
import CircleProgressView

class YomiageViewController: UIViewController {

    @IBOutlet var nextButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var messageText: UILabel!
    @IBOutlet weak var tankaImage: UIImageView!
    @IBOutlet var countdownText: UILabel!
    @IBOutlet var countdownView: CountdownView!

    var numberOfShimonokuRepeats: Int!
    var isAutomaticPlayNext: Bool!
    
    var hyakuninIsshu:HyakuninIsshu = HyakuninIsshu()

//    let MAX_TANKA_NUMBER = 100
    let touchTankaTag = 1

    var timer :Timer!
    var waitForAudioStart_ms:Int = 2000
    
    // Information about current tanka to be reading
    var readingPosition = 0 ;   /* From 0 to (MAX_TANKA_NUMBER-1) */
    var isKaminoku = true ;
    var isTouchEnabled = false
    var isRunning = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide tabbar and back button in navigation bar for this view
        // not neccesary when reading..
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true

        // Set parameters/callback to hyakuninisshu instance
        hyakuninIsshu.numberOfShimonokuRepeats = numberOfShimonokuRepeats
        hyakuninIsshu.setDidFinishReadingClosure(closure:didFinishReading)

        isRunning = true
        startCountdown()
        updateMessage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     *   Button/Touch actions
     */
    
    @IBAction func onNextButton(_ sender: Any) {
        cancelAndStartNextReading()
    }
    
    @IBAction func onStopButton(_ sender: Any) {
        isRunning = false
        countdownView.cancel()
        hyakuninIsshu.cancelReading()
    }

    // Touch event
    override func touchesEnded( _ touches: Set<UITouch>,  with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            switch tag {
            case touchTankaTag:
                cancelAndStartNextReading()
                break
            default:
                break
            }
        }
    }

    /*
     *   Reading controls
     */
    
    private func startReading() {
        
        let readingNumber = hyakuninIsshu.getTankaNumberAt(position: readingPosition)

        isKaminoku = true ;
        setImage()
        hyakuninIsshu.startReading(tankaNumber: readingNumber)
        
        print(readingNumber,hyakuninIsshu.getBodyKana(number: readingNumber))
    }

    func didFinishReading(successfully : Bool, isKaminoku :Bool) {
        if (successfully == true) {
            if (isKaminoku == true) {
                self.isKaminoku = false
                setImage()
            } else {
                if (isRunning == false) {
                    print("Alread finished, do nothing")
                    return
                }
                
                if (readingPosition >= hyakuninIsshu.MAX_TANKA_NUMBER - 1) {
                    
                    // Force to move final view regardless the automatic play next setting
                    moveToFinalView()
                } else {
                    if (isAutomaticPlayNext == true) {
                        startNextCountdown()
                    } else {
                        // Do nothing. waiting for next button or display tap
                    }
                }
            }
        } else {
            print("didFinishReading", successfully)
        }
    }

    private func cancelAndStartNextReading() {
        hyakuninIsshu.cancelReading()
        startNextCountdown()
    }

    private func setImage() {
        let tankaNumber:Int = hyakuninIsshu.getTankaNumberAt(position: readingPosition)
        tankaImage.image = hyakuninIsshu.getTankaImage(
            tankaNumber:tankaNumber, isKaminoku:self.isKaminoku)
        tankaImage.isHidden = false
    }
    
    private func updateMessage() {
        messageText.text = String(format: "%d 句目 / 残り %d 句",
                                  readingPosition + 1,
                                  hyakuninIsshu.MAX_TANKA_NUMBER - (readingPosition + 1))
    }

    private func startNextCountdown() {
        
        if (readingPosition < hyakuninIsshu.MAX_TANKA_NUMBER - 1) {
            isKaminoku = true ;
            readingPosition += 1
            updateMessage()
            startCountdown()
        } else {
            // Force to go into the final view
            moveToFinalView()
        }
    }
    
    private func moveToFinalView() {
        self.performSegue(withIdentifier: "toYomiageFinishedView", sender: nil)
    }

    /*
     *   Countdown before reading
     */
    
    let countdownSeconds = 3
    let timerIntervalSecounds = 0.1
    
    func startCountdown() {
        showMainView(isShown: false)
        showCountdownView(isShown: true)
        countdownText.text = String(countdownSeconds) ;
        countdownView.start(timeSeconds: countdownSeconds,
                            intervalSeconds: timerIntervalSecounds,
                            handler: countdownTickHandler)
    }
    
    func countdownTickHandler(tickCount : Int) {
        
        let divider:Int = Int(1.0 / timerIntervalSecounds)
        if ((tickCount % divider) == 0) {
            countdownText.text = String(tickCount / divider)
        }
        if (tickCount <= 0) {
            showCountdownView(isShown: false)
            showMainView(isShown: true)
            startReading()
        }
    }
    
    private func showCountdownView(isShown:Bool) {
        countdownView.isHidden  = !isShown
        countdownText.isHidden  = !isShown
        nextButton.isEnabled    = !isShown
    }
    
    private func showMainView(isShown:Bool) {
        tankaImage.isHidden = !isShown
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
