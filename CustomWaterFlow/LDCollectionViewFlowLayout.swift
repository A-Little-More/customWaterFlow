//
//  LDCollectionViewFlowLayout.swift
//  CustomWaterFlow
//
//  Created by lidong on 2019/8/23.
//  Copyright © 2019年 macbook. All rights reserved.
//

import UIKit

protocol LDCollectionViewDelegateFlowLayout: class {
    // 返回item的height
    func ld_setCellHeight(layout: LDCollectionViewFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat
    // 返回列数
    func ld_columnCountInWaterFlowLayout(_ layout: LDCollectionViewFlowLayout) -> Int
    // 列与列间距
    func ld_columnMarginInWaterFlowLayout(_ layout: LDCollectionViewFlowLayout) -> CGFloat
    // 行与行间距
    func ld_rowMarginInWaterFlowLayout(_ layout: LDCollectionViewFlowLayout) -> CGFloat
    // 内边距
    func ld_edgeInsetsInWaterFlowLayout(_ layout: LDCollectionViewFlowLayout) -> UIEdgeInsets
}


// MARK: - 可选协议
extension LDCollectionViewDelegateFlowLayout {
    // 列与列间距
    func ld_columnMarginInWaterFlowLayout(_ layout: LDCollectionViewFlowLayout) -> CGFloat {
        return 0
    }
    // 行与行间距
    func ld_rowMarginInWaterFlowLayout(_ layout: LDCollectionViewFlowLayout) -> CGFloat{
        return 0
    }
    // 内边距
    func ld_edgeInsetsInWaterFlowLayout(_ layout: LDCollectionViewFlowLayout) -> UIEdgeInsets{
        return UIEdgeInsets.zero
    }
}

class LDCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: LDCollectionViewDelegateFlowLayout?
    fileprivate var columnCount: Int {
        get {
            guard let delegate = self.delegate else { return 0 }
            return delegate.ld_columnCountInWaterFlowLayout(self)
        }
    }
    fileprivate var columnMargin: CGFloat {
        get {
            guard let delegate = self.delegate else { return 0 }
            return delegate.ld_columnMarginInWaterFlowLayout(self)
        }
    }
    fileprivate var rowMargin: CGFloat {
        get {
            guard let delegate = self.delegate else { return 0 }
            return delegate.ld_rowMarginInWaterFlowLayout(self)
        }
    }
    fileprivate var edgeInsets: UIEdgeInsets {
        get {
            guard let delegate = self.delegate else { return UIEdgeInsets.zero }
            return delegate.ld_edgeInsetsInWaterFlowLayout(self)
        }
    }
    
    /// 用于储存每个item的layout信息
    fileprivate lazy var attributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    /// 用于存储每一列items的高度
    fileprivate lazy var columnHeights: [CGFloat] = [CGFloat]()
    
    /// 内容的高度
    fileprivate var contentHeight: CGFloat?
    
    /// 准备所有item的layoutAttribute信息
    override func prepare() {
        super.prepare()
        if self.collectionView == nil {return}
        
        // reset数据
        self.attributes.removeAll()
        self.columnHeights.removeAll()
        self.contentHeight = 0
        
        // 将上内边距加到每一列的高速数组中
        for _ in 0..<self.columnCount {
            self.columnHeights.append(self.edgeInsets.top)
        }
        
        // items的总数
        let count: Int = self.collectionView!.numberOfItems(inSection: 0)
        // collectionView的宽度
        let collectionViewWidth: CGFloat = self.collectionView!.bounds.width
        // 列间距的总和
        let totalColumnMargin: CGFloat = self.columnMargin * CGFloat(self.columnCount - 1)
        // item的宽度
        let itemWidth: CGFloat = (collectionViewWidth - self.edgeInsets.left - self.edgeInsets.right - totalColumnMargin) / CGFloat(self.columnCount)
        
        for i in 0..<count {
            // indexPath
            let indexPath: IndexPath = IndexPath(item: i, section: 0)
            // attribute
            let attribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            // itemHeight
            let itemHeight: CGFloat = (self.delegate?.ld_setCellHeight(layout: self, indexPath: indexPath, itemWidth: itemWidth)) ?? 0
            
            // 默认第一列的高度最小
            var minColumn: Int = 0
            var minColumnHeight: CGFloat = self.columnHeights[minColumn]
            
            // 获得最小高度列
            for i in 1..<self.columnHeights.count {
                if self.columnHeights[i] < minColumnHeight {
                    minColumn = i
                    minColumnHeight = self.columnHeights[i]
                }
            }
            // item的X
            let itemX: CGFloat = self.edgeInsets.left + (itemWidth + self.columnMargin) * CGFloat(minColumn)
            // item的Y
            var itemY: CGFloat = minColumnHeight
            // 如果不是第一排的话 需要加上行间距
            if itemY != self.edgeInsets.top {
                itemY = itemY + rowMargin
            }
            
            attribute.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
            
            // 改变最小高度列的高度
            self.columnHeights[minColumn] = itemY + itemHeight
            
            // 找到最大的高度列
            var maxColumnHeight: CGFloat = self.columnHeights[0]
            for i in 1..<self.columnHeights.count {
                if (maxColumnHeight < self.columnHeights[i]) {
                    maxColumnHeight = self.columnHeights[i]
                }
            }
            // 设为内容高度
            self.contentHeight = maxColumnHeight
            self.attributes.append(attribute)
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributes
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: 0, height: self.contentHeight ?? 0)
        }
        set {
            self.collectionViewContentSize = newValue
        }
    }
    
}
