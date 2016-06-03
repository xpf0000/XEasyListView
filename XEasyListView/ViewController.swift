//
//  ViewController.swift
//  XEasyListView
//
//  Created by X on 16/6/3.
//  Copyright © 2016年 XEasyListView. All rights reserved.
//

import UIKit

class TestModel: Reflect {
    
    var content = ""
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

let url = "http://api.1-blog.com/biz/bizserver/xiaohua/list.do?page=[page]&size=20"

let sw = UIScreen.mainScreen().bounds.size.width
let sh = UIScreen.mainScreen().bounds.size.height

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

