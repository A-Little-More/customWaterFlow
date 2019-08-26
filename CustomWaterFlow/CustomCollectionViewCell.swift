//
//  CustomCollectionViewCell.swift
//  CustomWaterFlow
//
//  Created by lidong on 2019/8/23.
//  Copyright © 2019年 macbook. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.randomColor()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.label)
        self.label.frame = self.contentView.bounds

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
