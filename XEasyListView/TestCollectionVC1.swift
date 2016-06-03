//
//  TestCollectionVC1.swift
//  XEasyListView
//
//  Created by X on 16/6/3.
//  Copyright © 2016年 XEasyListView. All rights reserved.
//

import UIKit

class TestCollectionVC1: UIViewController,UICollectionViewDelegate {

    let collection =  XCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.frame = CGRectMake(0, 0, sw, sh)
        collection.Delegate(self)
        self.view.addSubview(collection)
        
        collection.registerNib(UINib(nibName: "TestCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TestCollectionCell")
        
        collection.setHandle(url, pageStr: "[page]", keys: ["detail"], model: TestModel.self, CellIdentifier: "TestCollectionCell")
        
        collection.itemSize = CGSizeMake(sw/2.0, sw/2.0)
        
        collection.show()
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("indexPath: \(indexPath)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
