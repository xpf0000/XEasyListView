//
//  XFooterRefreshView.swift
//  refresh
//
//  Created by X on 16/1/15.
//  Copyright © 2016年 refresh. All rights reserved.
//

import UIKit


class XFooterRefreshView: UIView {
    
    weak var scrollView:UIScrollView?
    let msgLabel:UILabel=UILabel()
    let activity:UIActivityIndicatorView=UIActivityIndicatorView()
    var block:RefreshBlock?
    var state:XRefreshState = .Normal
    var end=false
    var height:CGFloat = 60
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    func hide()
    {
        self.hidden = true
    }
    
    func show()
    {
        self.hidden = false
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        self.scrollView = newSuperview as? UIScrollView
        
        if(newSuperview != nil)
        {
            newSuperview!.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
            newSuperview!.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
            newSuperview!.sendSubviewToBack(self)
            self.frame.origin.y = newSuperview!.frame.size.height;
        }
        else
        {
            self.superview?.removeObserver(self, forKeyPath: "contentSize")
            self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        }
    }
    
    override func removeFromSuperview() {
        
        super.removeFromSuperview()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor=UIColor.clearColor()
        
        if XRefreshFooterProgressBlock != nil
        {
            return
        }
        
        msgLabel.text="上拉加载更多"
        msgLabel.textColor=UIColor(red: 51.0/255.0, green: 71.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        msgLabel.textAlignment=NSTextAlignment.Center
        msgLabel.font=UIFont.boldSystemFontOfSize(15)
        
        self.addSubview(msgLabel)
        
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray;
        activity.alpha=0.0
        
        self.addSubview(activity)
        
        msgLabel.translatesAutoresizingMaskIntoConstraints=false
        activity.translatesAutoresizingMaskIntoConstraints=false
        
        
        let cx = NSLayoutConstraint(item: msgLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        let cy = NSLayoutConstraint(item: msgLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        self.addConstraints([cx,cy])
        
        let cy1 = NSLayoutConstraint(item: activity, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        let tr = NSLayoutConstraint(item: activity, attribute: .Trailing, relatedBy: .Equal, toItem: msgLabel, attribute: .Leading, multiplier: 1.0, constant: -15.0)
        
        self.addConstraints([cy1,tr])
        
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(self.scrollView == nil)
        {
            return
        }
        
        if(keyPath == "contentSize")
        {
            if self.scrollView!.contentSize.height < self.scrollView!.frame.size.height
            {
                self.scrollView!.contentSize.height = self.scrollView!.frame.size.height
            }
            
            self.frame=CGRectMake(0, scrollView!.contentSize.height, scrollView!.frame.size.width, height)
            
        }
        
        if(keyPath == "contentOffset")
        {
            
            if(self.state == .End || !scrollView!.refreshEnable || self.hidden)
            {
                return
            }
            
            let y:CGFloat = scrollView!.contentOffset.y
            var sizeY:CGFloat = scrollView!.contentSize.height-scrollView!.frame.height
            sizeY = sizeY < 0 ? 0 : sizeY
            
            if y <= 0
            {
                return
            }
            
            XRefreshFooterProgressBlock?(self,Double((y-sizeY)/height))
            
            if (scrollView!.dragging)
            {
                
                if (self.state == .Normal && y >= sizeY+height)
                {
                    self.setState(.Pulling)
                }
                else if (self.state == .Pulling && y < sizeY+height)
                {
                    self.setState(.Normal)
                }
            }
            else if(self.state == .Pulling)
            {
                self.setState(.Refreshing)
            }
        }
    }
    
    func beginRefresh()
    {
        XRefreshFooterProgressBlock?(self,1.0)
        if(self.window != nil)
        {
            self.setState(.Refreshing)
        }
        else
        {
            self.state = .WillRefreshing
            super.setNeedsDisplay()
        }
    }
    
    func endRefresh()
    {
        let delayInSeconds:Double=0.25
        let popTime:dispatch_time_t=dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
            
            self.setState(.Normal)
            
        })
    }
    
    func reSet()
    {
        self.state = .Normal
        self.activity.alpha=0.0
        self.activity.stopAnimating()
        self.scrollView!.contentInset.bottom = 0
        self.setStateText()
    }
    
    func setState(state:XRefreshState)
    {
        if self.state ==  state || self.state == .End
        {
            return
        }
        
        switch state
        {
        case .Normal:
            
            if(self.state == .Refreshing)
            {
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.activity.alpha=0.0
                    self.scrollView!.contentInset.bottom = 0
                    
                    }, completion: { (finish) -> Void in
                        
                        self.activity.stopAnimating()
                        
                })
                
                let delayInSeconds:Double=0.25
                let popTime:dispatch_time_t=dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                
                dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                    
                    XRefreshFooterEndBlock?(self)
                    
                    self.state = .Pulling
                    self.setState(.Normal)
                    
                    self.scrollView!.refreshEnable = true
                    
                })
                
            }
            else
            {
                self.activity.alpha=0.0
                self.activity.stopAnimating()
            }
            
            
        case .Pulling:
            ""
            
        case .Refreshing:
            
            scrollView!.refreshEnable = false
            
            self.activity.hidden = false
            self.activity.alpha=1.0
            self.activity.startAnimating()
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                
                self.scrollView!.contentInset.bottom=self.height
                
                var y:CGFloat = self.scrollView!.contentSize.height-self.scrollView!.frame.height+self.height
                
                if y < 0 && y > -self.height
                {
                    y = self.height + y
                }
                else if y < -self.height
                {
                    y = self.height
                }
                
                self.scrollView?.setContentOffset(CGPointMake(0, y), animated: false)
                
                }, completion: { (finish) -> Void in
                    
                    XRefreshFooterBeginBlock?(self)
                    self.block?()
            })
            
        case .WillRefreshing:
            ""
            
        case .End:
            
            self.activity.stopAnimating()
            self.activity.hidden = true
            self.scrollView!.contentInset.bottom=0
            XRefreshFooterNoMoreBlock?(self)
            
            scrollView!.refreshEnable = true
        }
        self.state=state
        
        self.setStateText()
    }
    
    func setStateText()
    {
        switch self.state
        {
        case .Normal:
            
            self.msgLabel.text = "上拉加载更多"
            
        case .Pulling:
            
            self.msgLabel.text = "松开进行加载"
            
        case .Refreshing:
            
            self.msgLabel.text = "正在玩命加载"
            
        case .WillRefreshing:
            ""
        case .End:
            self.msgLabel.text = "已无更多内容"
            
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        if (self.state == .WillRefreshing) {
            self.setState(.Refreshing)
        }
    }
    
    
    deinit
    {
        self.superview?.removeObserver(self, forKeyPath: "contentSize")
        self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        self.scrollView = nil
        self.block = nil
        self.removeFromSuperview()
        
    }
    
    
}

