//
//  ItemViewCell.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2019/05/03.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit

class ItemViewCell: UITableViewCell {

    @IBOutlet var uiImageView: UIImageView!
    @IBOutlet var uiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configurateTheCell(_ menu: Menu) {
        uiImageView.image = UIImage(named: menu.name)
        uiLabel.text       = menu.title
        
        uiImageView.layer.masksToBounds = true
        uiImageView.layer.cornerRadius = 10.0
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 2, height: 4)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.5
    }
}
