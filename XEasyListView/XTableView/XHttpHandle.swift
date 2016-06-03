//
//  XHttpHandle.swift
//  chengshi
//
//  Created by X on 15/11/20.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

typealias XHttpHandleBlock = (AnyObject?)->Void

class XHttpHandle: NSObject {

    var autoReload=true
    var pageSize=20
    var page=1
    var end=false
    var url:String=""
    var pageStr=""
    var replace:[String:String]?
    var modelClass:AnyClass!
    
    private var beforeBlock:XHttpHandleBlock?
    
    func BeforeBlock(b:XHttpHandleBlock)
    {
        beforeBlock = b
    }
    
    private var afterBlock:XHttpHandleBlock?
    
    func AfterBlock(b:XHttpHandleBlock)
    {
        afterBlock = b
    }
    
    private var resetBlock:XHttpHandleBlock?
    
    func ResetBlock(b:XHttpHandleBlock)
    {
        afterBlock = b
    }
    
    
    lazy var listArr:[AnyObject] = []
    lazy var keys:[String]=[]
    
    weak var scrollView:UIScrollView?
    
    var running = false
    
    override init() {
        super.init()
    }
    
    func setHandle(scrollView:UIScrollView?, url:String,pageStr:String,keys:[String],model:AnyClass)
    {
        self.scrollView = scrollView
        self.url=url
        self.pageStr=pageStr
        self.keys=keys
        modelClass=model
    }
    
    func reSet()
    {
        resetBlock?(listArr)
        
        scrollView?.footRefresh?.end = false
        scrollView?.footRefresh?.state = .Pulling
        scrollView?.footRefresh?.setState(.Normal)
        
        self.page=1
        self.end=false
    }
    
    func handle()
    {
        if(self.end || self.running)
        {
            return
        }
        
        self.running = true
        
        let url=self.url.stringByReplacingOccurrencesOfString(pageStr, withString: "\(page)")
        
        XHttpPool.requestJson(url, body: nil, method: .GET) {[weak self] (o) -> Void in
            
            if(self == nil){return}
            
            if(o != nil)
            {
                
                var temp:Array<AnyObject> = []
                
                var items=o
                
                for key in self!.keys
                {
                    items=items![key]
                }
                
                let info = items?.arrayValue
                if(info?.count > 0)
                {
                    let elementModelType = self!.modelClass as! Reflect.Type
                    
                    for item in info!
                    {
                         let elementModel = elementModelType.parse(json: item,replace: self!.replace)
                        
                        temp.append(elementModel)
                    }
                    
                    if(info!.count < self!.pageSize)
                    {
                        self!.end = true
                    }
                }
                else
                {
                    self!.end = true
                }
                
                if(self!.page == 1)
                {
                    self!.listArr.removeAll(keepCapacity: false)
                }
                
                self!.listArr += temp
                
                self?.beforeBlock?(self?.listArr)
                
                if(self!.autoReload)
                {
                    if let table = self?.scrollView as? UITableView
                    {
                        table.reloadData()
                    }
                    
                    if let collection = self?.scrollView as? UICollectionView
                    {
                        collection.reloadData()
                    }
                
                }
                
                self?.afterBlock?(self?.listArr)
                
                self!.page += 1

                if(self!.end)
                {
                    self!.scrollView?.LoadedAll()
                }
                
                self!.scrollView?.endHeaderRefresh()
                self!.scrollView?.endFooterRefresh()
                self!.scrollView?.showFootRefresh()
                
            }
            else
            {
                self!.scrollView?.showFootRefresh()
                self!.scrollView?.endHeaderRefresh()
                self!.scrollView?.endFooterRefresh()
            }
          
            self?.running = false
            
        }
 
    }
    
    deinit
    {
        replace?.removeAll(keepCapacity: false)
        replace = nil
        keys.removeAll(keepCapacity: false)
        listArr.removeAll(keepCapacity: false)
        scrollView = nil
        beforeBlock = nil
        afterBlock = nil
    }
}
