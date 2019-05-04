//
//  HyakuninIsshu.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2017/10/21.
//  Copyright © 2017年 Yuji Ogihara. All rights reserved.
//

import Foundation
import AVFoundation

import SwiftyJSON

class HyakuninIsshu: NSObject, AVAudioPlayerDelegate {
    
    var MAX_TANKA_NUMBER:Int = 100
//    var MAX_TANKA_NUMBER:Int = 5

    var tankaInfo: JSON = JSON.null
    var audioPlayer:AVAudioPlayer!
    
    // Constructor
    override init(){
        super.init()
        parseJsonData()
        createRandomOrder()
    }
    
    // Public method
    // Tanka
    func getBodyKana(number:Int) -> String{
        return tankaInfo[number-1]["bodyKana"].stringValue
    }
    func getBodyKanji(number:Int) -> String{
        return tankaInfo[number-1]["bodyKanji"].stringValue
    }
    // Author
    func getNameKana(number:Int) -> String{
        return tankaInfo[number-1]["nameKana"].stringValue
    }
    func getNameKanji(number:Int) -> String{
        return tankaInfo[number-1]["nameKanji"].stringValue
    }
    // Minimal strings to determine specified tanka
    func getKimariji(number:Int) -> String{
        return tankaInfo[number-1]["kimariji"].stringValue
    }
    
    func getTankaImage(tankaNumber:Int, isKaminoku:Bool)->UIImage {
        var prefix = "kaminoku_", suffix=".jpg"
        var resourceName = ""
        
        if (isKaminoku == false) {
            prefix = "shimonoku_"
            suffix = ".png"
        }
        resourceName = prefix + String(format: "%03d",tankaNumber) + suffix
        return UIImage(named: resourceName)!
    }
    
    
    var randomOrder = [Int](repeating: 0, count: 100)
    
    func getTankaNumberAt(position:Int)->Int {
        if (position < MAX_TANKA_NUMBER) {
            return randomOrder[position]
        }
        return 0;
    }

    private func createRandomOrder() {
        let offset:Int = Int.init(arc4random_uniform(UInt32(MAX_TANKA_NUMBER)))
        
        for i in 1...MAX_TANKA_NUMBER {
            randomOrder[(offset + i)%MAX_TANKA_NUMBER] = i
        }
        
        // Shuffle order
        for i in 0..<MAX_TANKA_NUMBER {
            // Choose random position from i to
            let replaced_pos:Int = Int.init(arc4random_uniform(UInt32.init(MAX_TANKA_NUMBER-i))) + i ;
            let value = randomOrder[replaced_pos]
            randomOrder[replaced_pos] = randomOrder[i]
            randomOrder[i] = value
        }
        /*
         for i in 0...99 {
             print(readingOrder[i])
         }
         for i in 0...99 {
             for j in 0...99 {
                 if (readingOrder[j] == i + 1) {
                     break
                 }
                 if (j == 99) {
                     print("Strange")
                 }
             }
         }
         */

    }

    var numberOfShimonokuRepeats:Int = 3

    var readingTankaNumber = 0;
    var isKaminoku = true ;
    var timer :Timer!
    var timeIntervalToShimonoku:Int = 2
    var timeIntervalToShimonokuAgain:Int = 1

    var numberOfShimonokuRepeatsRemained = 0;

    func startReading(tankaNumber:Int) {
        readingTankaNumber = tankaNumber
        isKaminoku = true
        startAudio(tankaNumber: tankaNumber, isKaminoku: true)
    }
    
    func cancelReading() {
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
        stopAudio()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        var _timeInterval:Int = 0 ;
        if (isKaminoku == true) {
            _timeInterval = timeIntervalToShimonoku
        } else {
            _timeInterval = timeIntervalToShimonokuAgain
        }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(_timeInterval), target: self, selector: #selector(self.startShimonokuReading), userInfo: nil, repeats: false)
    }
    
    @objc func startShimonokuReading() {
        
        if (isKaminoku == true) {
            isKaminoku = false
            numberOfShimonokuRepeatsRemained = numberOfShimonokuRepeats
            didFinishReadingClosure!(true,true)
        } else {
            numberOfShimonokuRepeatsRemained -= 1
            if (numberOfShimonokuRepeatsRemained <= 0) {
                didFinishReadingClosure!(true, false)
                timer.invalidate()
                return
            }
        }
        startAudio(tankaNumber: readingTankaNumber, isKaminoku: false)
    }
    
    private func startAudio(tankaNumber:Int, isKaminoku:Bool) {
        
        var resourceName = String(format: "%03d",tankaNumber)
        if (isKaminoku == true) {
            resourceName += "_k"
        } else {
            resourceName += "_s"
        }
        //        print (resourceName)
        
        let audioPath = Bundle.main.path(forResource: resourceName, ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        var audioError:NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        audioPlayer.delegate = self
        audioPlayer.play();
    }


    func pauseAudio() {
        if (audioPlayer != nil) {
            audioPlayer.pause()
        }
    }
    
    func stopAudio() {
        if (audioPlayer != nil) {
            audioPlayer.stop()
            audioPlayer = nil
        }
    }
    
    var didFinishReadingClosure: ((_ successfully : Bool, _ isKaminoku : Bool)->Void)? = nil
    
    func setDidFinishReadingClosure(closure:@escaping ((Bool,Bool)->Void)) {
        didFinishReadingClosure = closure
    }

    
/*
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayerDidFinishPlayingClosure!(flag)
    }
*/
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print(error!)
    }

    private func parseJsonData() {
        do {
            if let file = Bundle.main.url(forResource: "hyakunin", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                tankaInfo = JSON(jsonObject)
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

