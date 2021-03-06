//
//  TestTableCell.swift
//  XEasyListView
//
//  Created by X on 16/6/3.
//  Copyright © 2016年 XEasyListView. All rights reserved.
//

import UIKit

class TestTableCell: UITableViewCell {

    @IBOutlet var ctext: UILabel!
    
    var model:TestModel!
    {
        didSet
        {
            ctext.preferredMaxLayoutWidth = sw-20
            ctext.text = model.content
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
