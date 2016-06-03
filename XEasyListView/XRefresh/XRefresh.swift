//
//  XRefresh.swift
//  lejia
//
//  Created by X on 15/9/25.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

typealias RefreshBlock = ()->Void

typealias RefreshProgressBlock = (UIView,Double)->Void
typealias RefreshViewBlock = (UIView)->Void

//状态
enum XRefreshState : NSInteger{
    case Normal
    case Pulling
    case Refreshing
    case WillRefreshing
    case End
}

private var headerV: XHeaderRefreshView?
private var footerV: XFooterRefreshView?

private var RefreshHeaderViewKey : CChar?
private var RefreshFooterViewKey : CChar?
private var XRefreshEnableKey : CChar?

var XRefreshHeaderProgressBlock:RefreshProgressBlock?
var XRefreshHeaderBeginBlock:RefreshViewBlock?
var XRefreshHeaderEndBlock:RefreshViewBlock?

var XRefreshFooterProgressBlock:RefreshProgressBlock?
var XRefreshFooterBeginBlock:RefreshViewBlock?
var XRefreshFooterEndBlock:RefreshViewBlock?
var XRefreshFooterNoMoreBlock:RefreshViewBlock?

func XRefreshConfig(headerProgress:RefreshProgressBlock?,headerBegin:RefreshViewBlock?,headerEnd:RefreshViewBlock?,footerProgress:RefreshProgressBlock?,footerBegin:RefreshViewBlock?,footerEnd:RefreshViewBlock?,noMore:RefreshViewBlock?)
{
    XRefreshHeaderProgressBlock = headerProgress
    XRefreshHeaderBeginBlock = headerBegin
    XRefreshHeaderEndBlock = headerEnd
    
    XRefreshFooterProgressBlock = footerProgress
    XRefreshFooterBeginBlock = footerBegin
    XRefreshFooterEndBlock = footerEnd
    XRefreshFooterNoMoreBlock = noMore
}

extension UIScrollView
{
    var refreshEnable:Bool
    {
        get
        {
            let b = (objc_getAssociatedObject(self, &XRefreshEnableKey) as? Bool) ?? true
            return b
        }
        set(newValue) {
            self.willChangeValueForKey("XRefreshEnableKey")
            objc_setAssociatedObject(self, &XRefreshEnableKey, newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.didChangeValueForKey("XRefreshEnableKey")
            
        }

    }
    
    func hideHeadRefresh()
    {
        self.headRefresh?.hide()
    }
    
    func showHeadRefresh()
    {
        self.headRefresh?.show()
    }
    
    func hideFootRefresh()
    {
        self.footRefresh?.hide()
    }
    
    func showFootRefresh()
    {
        self.footRefresh?.show()
    }
    
    func setHeaderRefresh(block:RefreshBlock)
    {
        let headerRefreshView:XHeaderRefreshView=XHeaderRefreshView(frame: CGRectZero)
        self.addSubview(headerRefreshView)
        self.headRefresh=headerRefreshView
        headerRefreshView.block = block
        
    }
    
    weak var headRefresh:XHeaderRefreshView?
        {
        get
        {
            return objc_getAssociatedObject(self, &RefreshHeaderViewKey) as? XHeaderRefreshView
        }
        set(newValue) {
            self.willChangeValueForKey("RefreshHeaderViewKey")
            objc_setAssociatedObject(self, &RefreshHeaderViewKey, newValue,
                                     .OBJC_ASSOCIATION_ASSIGN)
            self.didChangeValueForKey("RefreshHeaderViewKey")
            
        }
    }
    
    weak var footRefresh:XFooterRefreshView?
        {
        get
        {
            return objc_getAssociatedObject(self, &RefreshFooterViewKey) as? XFooterRefreshView
        }
        set(newValue) {
            self.willChangeValueForKey("RefreshFooterViewKey")
            objc_setAssociatedObject(self, &RefreshFooterViewKey, newValue,
                                     .OBJC_ASSOCIATION_ASSIGN)
            self.didChangeValueForKey("RefreshFooterViewKey")
            
        }
    }
    
    func beginHeaderRefresh()
    {
        self.headRefresh?.beginRefresh()
    }
    
    func endHeaderRefresh()
    {
        self.headRefresh?.endRefresh()
    }
    
    func setFooterRefresh(block:RefreshBlock)
    {
        let footerRefreshView:XFooterRefreshView=XFooterRefreshView(frame: CGRectMake(0, 0, self.frame.width, 0))
        self.addSubview(footerRefreshView)
        self.footRefresh=footerRefreshView
        footerRefreshView.block=block
    }
    
    func beginFooterRefresh()
    {
        self.footRefresh?.beginRefresh()
    }
    
    func endFooterRefresh()
    {
        self.footRefresh?.endRefresh()
    }
    
    func LoadedAll()
    {
        self.footRefresh?.end = true
        self.footRefresh?.setState(.End)
    }
    
}



