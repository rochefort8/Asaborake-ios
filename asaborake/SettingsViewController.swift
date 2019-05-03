//
//  SettingsViewController.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2019/05/03.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet var karuta_numberOfShimonokuRepeats: UILabel!
    @IBOutlet var karuta_isAutomaticPlayNext: UISwitch!
    @IBOutlet var yomiage_numberOfShimonokuRepeats: UILabel!
    @IBOutlet var yomiage_isAutomaticPlayNext: UISwitch!
    
    @IBOutlet var yomiagePickerView: UIPickerView!
    @IBOutlet var karutaPickerView: UIPickerView!
    
    let numberOfShimonokuRepeatList: [String] = ["1", "2", "3", "4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        yomiagePickerView.delegate = self
        yomiagePickerView.dataSource = self;
        yomiagePickerView.showsSelectionIndicator = true;
        karutaPickerView.delegate = self
        karutaPickerView.dataSource = self;
        karutaPickerView.showsSelectionIndicator = true;
        karutaPickerView.selectRow(1, inComponent:0, animated:true)

        let k1 = UserDefaults.standard.integer(forKey: "karuta_isAutomaticPlayNext")
        let k2 = UserDefaults.standard.integer(forKey: "karuta_numberOfShimonokuRepeats")
        let y1 = UserDefaults.standard.integer(forKey: "yomiage_isAutomaticPlayNext")
        let y2 = UserDefaults.standard.integer(forKey: "yomiage_numberOfShimonokuRepeats")

        karuta_isAutomaticPlayNext.isOn = (k1 != 0)
        karutaPickerView.selectRow(k2-1, inComponent:0, animated:true)
        yomiage_isAutomaticPlayNext.isOn = (y1 != 0)
        yomiagePickerView.selectRow(y2-1, inComponent:0, animated:true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    @IBAction func karuta_isAutomaticPlayNextChanged(_ sender: Any) {
        var value = 0
        if (karuta_isAutomaticPlayNext.isOn) { value = 1 }
        UserDefaults.standard.set(value,forKey: "karuta_isAutomaticPlayNext")
    }
    @IBAction func yomiage_isAutomaticPlayNextChanged(_ sender: Any) {
        var value = 0
        if (yomiage_isAutomaticPlayNext.isOn) { value = 1 }
        UserDefaults.standard.set(value,forKey: "yomiage_isAutomaticPlayNext")
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

extension SettingsViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        if (pickerView == yomiagePickerView) {
            let value = numberOfShimonokuRepeatList[row]
            UserDefaults.standard.set(value,forKey: "yomiage_numberOfShimonokuRepeats")
        }
        if (pickerView == karutaPickerView) {
            let value = numberOfShimonokuRepeatList[row]
            UserDefaults.standard.set(value,forKey: "karuta_numberOfShimonokuRepeats")
        }
    }
}
