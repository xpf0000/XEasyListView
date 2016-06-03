//
//  TestTableVC2.swift
//  XEasyListView
//
//  Created by X on 16/6/3.
//  Copyright © 2016年 XEasyListView. All rights reserved.
//

import UIKit

class TestTableVC2: UIViewController {
    
    let table = XTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.frame = CGRectMake(0, 0, sw, sh)
        
        self.view.addSubview(table)
        
        table.registerClass(TestTableCell1.self, forCellReuseIdentifier: "TestTableCell1")
        
        table.setHandle(url, pageStr: "[page]", keys: ["detail"], model: TestModel.self, CellIdentifier: "TestTableCell1")
        
        table.cellHeight = 60
        
        table.show()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
