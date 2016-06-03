//
//  TestCollectionCell.swift
//  XEasyListView
//
//  Created by X on 16/6/3.
//  Copyright © 2016年 XEasyListView. All rights reserved.
//

import UIKit

class TestCollectionCell: UICollectionViewCell {

    @IBOutlet var title: UILabel!
    
    var model:TestModel!
        {
        didSet
        {
            title.text = model.content
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        title.preferredMaxLayoutWidth = title.bounds.size.width
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
