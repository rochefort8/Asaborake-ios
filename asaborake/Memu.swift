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
}

extension Menu {
    static func createMenus() -> [Menu] {
        return [
            Menu(name:"karuta", title: "かるた対戦",
                 description: "読み上げた歌の下の句を、画面上に並んだ札から選んでください！「お手つき」に注意！"),
            Menu(name:"yomiage", title: "読み上げ",
                 description: "アプリが「読み手」となります。お手元の下の句の札を並べ、みんなで「かるた」をお楽しみください！"),
            Menu(name:"learning", title: "学習〜歌を覚えよう！",
                 description: "復習〜学習〜テストを繰り返して、百人一首の歌を全部覚えましょう！"),
        ]
    }
}
