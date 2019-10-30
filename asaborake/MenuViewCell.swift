//
//  MenuViewCell.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2019/10/30.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit

class MenuViewCell: UICollectionViewCell {
    
    
    @IBOutlet var titleText: UILabel!
    @IBOutlet var descriptionText: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    func configurateTheCell(_ menu: Menu) {
    
        let name = menu.name + ".jpg"
        imageView.image         = UIImage(named: name)
        titleText.text          = menu.title
        descriptionText.text    = menu.description
    }
}
