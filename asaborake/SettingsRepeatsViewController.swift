//
//  SettingsRepeatsViewController.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2019/05/03.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit

class SettingsRepeatsViewController: UIViewController {

    @IBOutlet var pickerView: UIPickerView!
    let numberOfShimonokuRepeatList: [String] = ["1", "2", "3", "4"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self;
        pickerView.showsSelectionIndicator = true;
        pickerView.selectRow(1, inComponent:0, animated:true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension SettingsRepeatsViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfShimonokuRepeatList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberOfShimonokuRepeatList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(numberOfShimonokuRepeatList[row])
    }
}

