//
//  HomeCollectionViewController.swift
//  asaborake
//
//  Created by Yuji Ogihara on 2019/10/30.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var bannerView: GADBannerView!
    
    let menus = Menu.createMenus()
    var savedIndex:Int = 0
    
    // Huge Value for infinite loop
    let PageCount = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let banner = GoogleMobileAds()
        banner.createBannarView(view: bannerView, parent: self)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        let screenSize = UIScreen.main.bounds
//        let screenSize = collectionView.bounds

        let collectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        collectionViewFlowLayout.itemSize =
            CGSize(width:screenSize.width / 1.2,
                   height:(screenSize.height - 200) / 1.2)
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0
        collectionViewFlowLayout.minimumLineSpacing = 20.0
        
        let screenshotsSectionInset = screenSize.width / 12.0
        collectionViewFlowLayout.sectionInset =
              UIEdgeInsets(top: 0.0, left: screenshotsSectionInset,
                        bottom: 0.0, right: screenshotsSectionInset)
        collectionView.selectItem(at: [0,2], animated: false, scrollPosition: .centeredHorizontally)
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath as IndexPath)as! MenuViewCell
        /*
         let hue = CGFloat(indexPath.item) / 20 // CGFloat(POMAppCount)
         */
        let index = realIndex(index:indexPath.row)
        cell.configurateTheCell(menus[index])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(realIndex(index: indexPath.row))
        savedIndex = realIndex(index: indexPath.row)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier:menus[savedIndex].name) as UIViewController
        navigationController?.pushViewController(secondViewController, animated: true)

    }
    
    private func realIndex(index : Int)->Int {
        /* At this moment, 0-2 is availabe */
        return (index % menus.count)
    }
}
