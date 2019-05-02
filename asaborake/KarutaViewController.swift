//
//  GameViewController.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2017/10/21.
//  Copyright © 2017年 Yuji Ogihara. All rights reserved.
//

import UIKit
import CircleProgressView

class KarutaViewController: UIViewController {
    
    @IBOutlet weak var imageRightBottom: UIImageView!
    @IBOutlet weak var imageLeftBottom: UIImageView!
    @IBOutlet weak var imageRightTop: UIImageView!
    @IBOutlet weak var imageLeftTop: UIImageView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var messageText: UILabel!

    @IBOutlet var countdownView: CountdownView!
    @IBOutlet var countdownText: UILabel!
    @IBOutlet var collectMarkImage: UIImageView!
    
    var numberOfShimonokuRepeats: Int!
    var isAutomaticPlayNext: Bool!

    var tankaImageList: [UIImageView] = [UIImageView]()
    var shimonokuRepeatTimes:Int = 1
    var numberOfShimonokuRepeatedTimes:Int = 0

    // Information about current tanka to be reading
    var readingPosition = 0 ;   /* From 0 to (MAX_TANKA_NUMBER-1) */
    var isKaminoku = true ;
    var isTouchEnabled = false
    var isRunning = true
    var isCorrect = false

    enum  TankaChoices:Int {
        case LeftTop = 0
        case LeftBottom
        case RightTop
        case RigitBottom
        case Number
    }

    var hyakuninIsshu:HyakuninIsshu = HyakuninIsshu()

    var timer :Timer!
    var waitForAudioStart_ms:Int = 2000

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true

        tankaImageList.append(imageLeftTop)
        tankaImageList.append(imageRightTop)
        tankaImageList.append(imageLeftBottom)
        tankaImageList.append(imageRightBottom)

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
    @IBAction func onNext(_ sender: Any) {
        cancelAndStartNextReading()
    }
    
    @IBAction func onStop(_ sender: Any) {
        isRunning = false
        countdownView.cancel()
        hyakuninIsshu.cancelReading()
    }
    
    // Touch event
    override func touchesEnded( _ touches: Set<UITouch>,  with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if (0 <= tag && tag < tankaImageList.count) {
                print(tag)
                if ((isCorrect == false) &&
                    (choicesOfTankaPosition[tag] != -1)) {
                    if (choicesOfTankaPosition[tag] == readingPosition) {
                        print("CORRECT!!")
                        isCorrect = true
                        
                        // Show "CORRECT" mark image
                        collectMarkImage.isHidden  = false
                        
                        // Paint border color for correct card image
                        paintImageBorderColor(imageView: tankaImageList[tag])

                    } else {
                        print("InCorrect!!")
                        // Show user the answer was incorrect by shaking all cards
                        shakeMainView()
                        
                        // Shuffle all cards
                        setChoicesOfTankaPosition()
                        setImage()
                    }
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
 
    private func startReading() {
        
        let readingNumber = hyakuninIsshu.getTankaNumberAt(position: readingPosition)
        
        isKaminoku = true
        isCorrect = false
        
        setChoicesOfTankaPosition()
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
    
    private func setImage() {
        
        for i in 0..<TankaChoices.Number.rawValue {
            if (choicesOfTankaPosition[i] != -1) {
                
                let tankaNumber = hyakuninIsshu.getTankaNumberAt(position: choicesOfTankaPosition[i])
                let tankaImage = hyakuninIsshu.getTankaImage(tankaNumber: tankaNumber, isKaminoku: false)
                tankaImageList[i].image = tankaImage
            } else {
                tankaImageList[i].image = hyakuninIsshu.getTankaImage(tankaNumber: 1, isKaminoku: true)
            }
        }
    }
    
    private func cancelAndStartNextReading() {
        hyakuninIsshu.cancelReading()
        startNextCountdown()
    }
    
    private func showCountdownView(isShown:Bool) {
        countdownView.isHidden      = !isShown
        countdownText.isHidden      = !isShown
        collectMarkImage.isHidden   = true
        nextButton.isEnabled        = !isShown
    }

    private func showMainView(isShown:Bool) {
        removeAllImageBorderColor()

        for i in 0..<tankaImageList.count {
            tankaImageList[i].isHidden = !isShown
        }
    }
    
    private func shakeMainView() {
        for i in 0..<tankaImageList.count {
            tankaImageList[i].shake(duration: 1)
        }
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
        self.performSegue(withIdentifier: "toKarutaFinishedView", sender: nil)
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
            nextButton.isEnabled = true
            startReading()
        }
    }
    
    /*
     * Choose Shimonoku
     */
    var choicesOfTankaPosition = [Int](repeating: 0, count: TankaChoices.Number.rawValue)
    
    private func setChoicesOfTankaPosition() {
        // Correct
        choicesOfTankaPosition[0] = readingPosition ;
        
        var maxRandomValue = hyakuninIsshu.MAX_TANKA_NUMBER
        var positionOffset = 0 ;
        var numberOfChoices = TankaChoices.Number.rawValue ;
        
        maxRandomValue = hyakuninIsshu.MAX_TANKA_NUMBER - readingPosition - 1
        positionOffset = readingPosition + 1
        if (readingPosition < hyakuninIsshu.MAX_TANKA_NUMBER - 3 ) {
            
        } else {
            numberOfChoices = hyakuninIsshu.MAX_TANKA_NUMBER - readingPosition
        }
        
        
        for i in 1..<TankaChoices.Number.rawValue {
            choicesOfTankaPosition[i] = -1
        }
        
        
        for i in 1..<numberOfChoices {
            // Choose random position from i to
            
            while true {
                let random_pos:Int = Int.init(arc4random_uniform(
                    UInt32.init(maxRandomValue))) + positionOffset
                
                var isUniqueRandomValue:Bool = true
                for j in 1..<i {
                    if (random_pos == choicesOfTankaPosition[j]) {
                        isUniqueRandomValue = false
                        break
                    }
                }
                if (isUniqueRandomValue == true) {
                    choicesOfTankaPosition[i] = random_pos
                    break;
                }
            }
        }
        if (numberOfChoices == TankaChoices.Number.rawValue) {
            shuffleChoicesOfTankaPosition()
        }
        /*
         print("---",readingPosition,"----");
         for i in 0..<TankaChoices.Number.rawValue{
         if (choicesOfTankaPosition[i] != -1) {
         let readingNumber = hyakuninIsshu.getTankaNumberAt(position: choicesOfTankaPosition[i])
         print(i,":",choicesOfTankaPosition[i],":",readingNumber,":",
         hyakuninIsshu.getBodyKana(number: readingNumber))
         }
         }
         */
    }
    
    private func shuffleChoicesOfTankaPosition() {
        for _ in 0..<10 {
            let replaced_pos:Int = Int.init(arc4random_uniform(UInt32.init((TankaChoices.Number).rawValue)))
            let v = choicesOfTankaPosition[replaced_pos]
            choicesOfTankaPosition[replaced_pos] = choicesOfTankaPosition[0]
            choicesOfTankaPosition[0] = v
        }
    }

    /*
     *  Image painting for notification
    */
    private func paintImageBorderColor(imageView : UIImageView) {
        let borderColor = UIColor(red:  CGFloat(145)/255.0,
                                  green:CGFloat(0)/255.0,
                                  blue: CGFloat(0)/255.0,
                                  alpha:1.0)
        // Paint frameborder
        imageView.layer.borderColor = borderColor.cgColor
        imageView.layer.borderWidth = 8
    }
    
    private func removeAllImageBorderColor() {
        for i in 0..<tankaImageList.count {
            tankaImageList[i].layer.borderWidth = 0
        }
    }
    
    
    /* Test code */
    private func test() {
        
        hyakuninIsshu = HyakuninIsshu()
        
        var table = [Int](repeating: 0, count: hyakuninIsshu.MAX_TANKA_NUMBER)
        for i in 0..<hyakuninIsshu.MAX_TANKA_NUMBER {
            table[i] = i + 1;
        }
        var isOK : Bool = true
        //        prepareFirstTanka()
        readingPosition = -1
        for _ in 0..<hyakuninIsshu.MAX_TANKA_NUMBER {
            isKaminoku = false
            numberOfShimonokuRepeatedTimes = 0
            
//            prepareNextTanka()
            readingPosition += 1
            setChoicesOfTankaPosition()
            
            for j in 0..<TankaChoices.Number.rawValue{
                if (choicesOfTankaPosition[j] != -1) {
                    let readingNumber = hyakuninIsshu.getTankaNumberAt(position: choicesOfTankaPosition[j])
                    /*
                     print(j,":",choicesOfTankaPosition[j],":",readingNumber,":",
                     hyakuninIsshu.getBodyKana(number: readingNumber))
                     */
                    let check = table[readingNumber - 1]
                    if (check != readingNumber) {
                        print("NO:table=",check,":readingNumber=",readingNumber)
                        isOK = false
                        break;
                    }
                }
            }
            if (isOK == false) {
                break
            }
            let readingNumber = hyakuninIsshu.getTankaNumberAt(position: readingPosition)
            print("POS=",readingPosition,"Number=",readingNumber,hyakuninIsshu.getBodyKana(number: readingNumber))
            isOK = false
            for j in 0..<TankaChoices.Number.rawValue{
                if (choicesOfTankaPosition[j] != -1) {
                    let n = hyakuninIsshu.getTankaNumberAt(position: choicesOfTankaPosition[j])
                    
                    if (n == readingNumber) {
                        table[n-1] = 0;
                        isOK = true
                        break;
                    }
                }
            }
            if (isOK == false) {
                break
            }
        }
        for i in 0..<hyakuninIsshu.MAX_TANKA_NUMBER {
            if (table[i] != 0) {
                isOK = false
                print(i,":",table[i])
            }
        }
        print("isOK=",isOK)
    }

}

/*
 * Shaker
 * https://gist.github.com/mourad-brahim/cf0bfe9bec5f33a6ea66
 */
extension UIView {
    func shake(duration: CFTimeInterval) {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
            ( degrees: Double) -> Double in
            let radians: Double = (.pi * degrees) / 180.0
            return radians
        }
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = duration
        self.layer.add(shakeGroup, forKey: "shakeIt")
    }
}
