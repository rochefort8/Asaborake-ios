//
//  YomiageSetupViewController.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2019/04/28.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit
import GoogleMobileAds

class YomiageSetupViewController: UIViewController  {
    /*
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var isAutomaticPlayNextSwitch: UISwitch!
    */
    @IBOutlet var bannerView: GADBannerView!
    
    @IBOutlet var isAutomaticPlayNextSwitch: UISwitch!
    @IBOutlet var pickerView: UIPickerView!
    let numberOfShimonokuRepeatList: [String] = ["1", "2", "3", "4"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let banner = GoogleMobileAds()
        banner.createBannarView(view: bannerView, parent: self)

        pickerView.delegate = self
        pickerView.dataSource = self;
        pickerView.showsSelectionIndicator = true;
        pickerView.selectRow(1, inComponent:0, animated:true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let viewController : YomiageViewController = (segue.destination as? YomiageViewController )!
        viewController.isAutomaticPlayNext = isAutomaticPlayNextSwitch.isOn
        viewController.numberOfShimonokuRepeats =
            Int(numberOfShimonokuRepeatList[pickerView.selectedRow(inComponent: 0)])
    }
}

extension YomiageSetupViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfShimonokuRepeatList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberOfShimonokuRepeatList[row]
    }
}
