//
//  GoogleMobileAds.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2019/04/28.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import Foundation
import GoogleMobileAds

class GoogleMobileAds {
    func getSdkVersion() -> String {
        return GADRequest.sdkVersion()
    }

    func createBannarView(view : GADBannerView, parent : UIViewController) {
        // FIXME later
        view.adUnitID = "ca-app-pub-6855950830684583/9909216322"
        view.rootViewController = parent
        let gadRequest:GADRequest = GADRequest()
        // テスト用の広告を表示する時のみ使用（申請時に削除）
        gadRequest.testDevices = ["12345678abcdefgh"]
        view.load(gadRequest)
    }
}
