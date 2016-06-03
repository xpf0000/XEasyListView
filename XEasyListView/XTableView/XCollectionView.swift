//
//  XCollectionView.swift
//  XEasyListView
//
//  Created by X on 16/6/3.
//  Copyright © 2016年 XEasyListView. All rights reserved.
//

import UIKit

class XCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource {

    let httpHandle:XHttpHandle=XHttpHandle()
    
    var CellIdentifier:String = ""
    
    var delegates:[UICollectionViewDelegate] = []
    
    let ViewLayout = UICollectionViewFlowLayout()
    
    var itemSize:CGSize!
    {
        didSet
        {
            ViewLayout.itemSize = itemSize
            reloadData()
        }
    }
    
    func Delegate(d:UICollectionViewDelegate)
    {
        if "\(d)" != "\(self)"
        {
            delegates.append(d)
        }
        
    }
    
    var dataSources:[UICollectionViewDataSource] = []
    
    func DataSource(d:UICollectionViewDataSource)
    {
        if "\(d)" != "\(self)"
        {
            dataSources.append(d)
        }
    }
    
    func initSelf()
    {
        backgroundColor = UIColor.whiteColor()
        delegate = self
        dataSource = self
        
        ViewLayout.itemSize = CGSizeMake(1, 1)
        ViewLayout.minimumLineSpacing = 0.0
        ViewLayout.minimumInteritemSpacing = 0.0
        ViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.collectionViewLayout = ViewLayout
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelf()
    }
    
    init()
    {
        super.init(frame: CGRectMake(0, 0, 1, 1), collectionViewLayout: UICollectionViewLayout())
        
        initSelf()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initSelf()
    }
    
    func setHandle(url:String,pageStr:String,keys:[String],model:AnyClass,CellIdentifier:String)
    {
        
        httpHandle.setHandle(self,url:url, pageStr: pageStr, keys: keys, model: model)
        
        self.CellIdentifier = CellIdentifier
        
    }
    
    func show()
    {
        self.setHeaderRefresh { [weak self] () -> Void in
            
            self?.httpHandle.reSet()
            
            self?.httpHandle.handle()
        }
        
        self.setFooterRefresh {[weak self] () -> Void in
            
            self?.httpHandle.handle()
        }
        
        self.httpHandle.handle()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return httpHandle.listArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        let model = httpHandle.listArr[indexPath.row]
        
        cell.setValue(model, forKey: "model")
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        delegates.last?.collectionView?(collectionView, didSelectItemAtIndexPath: indexPath)
    }

}
