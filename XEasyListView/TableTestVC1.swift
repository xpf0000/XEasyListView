//
//  TableTestVC1.swift
//  XEasyListView
//
//  Created by X on 16/6/3.
//  Copyright © 2016年 XEasyListView. All rights reserved.
//

import UIKit

class TableTestVC1: UIViewController {

    let table = XTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.frame = CGRectMake(0, 0, sw, sh)
        
        self.view.addSubview(table)
        
        table.registerNib(UINib(nibName: "TestTableCell", bundle: nil), forCellReuseIdentifier: "TestTableCell")
        
        table.setHandle(url, pageStr: "[page]", keys: ["detail"], model: TestModel.self, CellIdentifier: "TestTableCell")
        
        //table.cellHeight = 60
        
        table.show()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   
}
