//
//  Memu.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2019/04/28.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import Foundation

struct Menu {
    let name: String
    let title: String
    let description: String
    let image: String
}

extension Menu {
    static func createMenus() -> [Menu] {
        return [
            Menu(name:"karuta", title: "かるた対戦", description: "", image: "karuta"),
            Menu(name:"yomiage", title: "読み上げ",   description: "", image: "yomiage")
        ]
    }
}
