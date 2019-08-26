//
//  ViewController.swift
//  CustomWaterFlow
//
//  Created by lidong on 2019/8/23.
//  Copyright © 2019年 macbook. All rights reserved.
//

import UIKit


let cellReuseIdentifier = "cellReuseIdentifier"

class ViewController: UIViewController {

    private lazy var itemHeights: [CGFloat] = {
        var itemHeights: [CGFloat] = []
        for _ in 0..<30 {
            itemHeights.append(CGFloat(arc4random() % (200 - 50) + 50))
        }
        return itemHeights
    }()
    
    private lazy var collectionView: UICollectionView = {
        let ldLayout = LDCollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ldLayout)
        ldLayout.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        self.collectionView.frame = self.view.bounds
        self.collectionView.reloadData()
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemHeights.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        cell.label.text = indexPath.item.description
        cell.backgroundColor = UIColor.randomColor()
        return cell;
    }
    
}

extension ViewController: LDCollectionViewDelegateFlowLayout {
    func ld_setCellHeight(layout: LDCollectionViewFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        return self.itemHeights[indexPath.item]
    }
    
    func ld_columnCountInWaterFlowLayout(_ layout: LDCollectionViewFlowLayout) -> Int {
        return 3
    }
    
    func ld_edgeInsetsInWaterFlowLayout(_ layout: LDCollectionViewFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func ld_columnMarginInWaterFlowLayout(_ layout: LDCollectionViewFlowLayout) -> CGFloat {
        return 10
    }
    
    func ld_rowMarginInWaterFlowLayout(_ layout: LDCollectionViewFlowLayout) -> CGFloat {
        return 10
    }
    
}
