//
//  XHeaderRefreshView.swift
//  refresh
//
//  Created by X on 16/1/15.
//  Copyright © 2016年 refresh. All rights reserved.
//

import UIKit

class XHeaderRefreshView: UIView {
    
    weak var scrollView:UIScrollView?
    var refrushTime:NSDate=NSDate()
    var height:CGFloat = 80.0
    var block:RefreshBlock?
    var state:XRefreshState = .Normal
    var loaded = false
    
    let downIcon:UIImageView=UIImageView()
    let msgLabel:UILabel=UILabel()
    let activity:UIActivityIndicatorView=UIActivityIndicatorView()
    
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
            
            self.frame=CGRectMake(0, -height, newSuperview!.frame.width, height)
            
        }
        else
        {
            self.superview?.removeObserver(self, forKeyPath: "contentSize")
            self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        }
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if superview != nil && !loaded
        {
            loaded = true
            scrollView?.contentInset.top = 0.0
            
        }
        else
        {
            
        }
        
        
    }
    
    override func removeFromSuperview() {
        
        super.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor=UIColor.clearColor()
        
        if XRefreshHeaderProgressBlock != nil
        {
            return
        }
        
        if let path = NSBundle.mainBundle().pathForResource("down.png", ofType: nil)
        {
            downIcon.image=UIImage(contentsOfFile: path)
        }
        
        self.addSubview(downIcon)
        
        msgLabel.text="下拉可以刷新";
        msgLabel.textColor=UIColor(red: 51.0/255.0, green: 71.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        msgLabel.textAlignment=NSTextAlignment.Center;
        msgLabel.font=UIFont.boldSystemFontOfSize(15)
        self.addSubview(msgLabel)
        
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray;
        activity.hidden = true
        
        self.addSubview(activity)
        
        
        msgLabel.translatesAutoresizingMaskIntoConstraints=false
        activity.translatesAutoresizingMaskIntoConstraints=false
        downIcon.translatesAutoresizingMaskIntoConstraints=false
        
        let cx = NSLayoutConstraint(item: msgLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        let cy = NSLayoutConstraint(item: msgLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        self.addConstraints([cx,cy])
        
        
        let cy1 = NSLayoutConstraint(item: activity, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        let tr = NSLayoutConstraint(item: activity, attribute: .Trailing, relatedBy: .Equal, toItem: msgLabel, attribute: .Leading, multiplier: 1.0, constant: -20.0)
        
        self.addConstraints([cy1,tr])
        
        
        let cy2 = NSLayoutConstraint(item: downIcon, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        let tr1 = NSLayoutConstraint(item: downIcon, attribute: .Trailing, relatedBy: .Equal, toItem: msgLabel, attribute: .Leading, multiplier: 1.0, constant: -20.0)
        
        let w = NSLayoutConstraint(item: downIcon, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40.0)
        
        let h = NSLayoutConstraint(item: downIcon, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40.0)
        
        self.addConstraints([cy2,tr1,w,h])
        
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if(self.scrollView == nil)
        {
            return
        }
        
        if(keyPath == "contentSize")
        {
            self.frame.size.width = self.scrollView!.frame.size.width
        }
        
        if(keyPath == "contentOffset")
        {
            if(self.state == .WillRefreshing || !scrollView!.refreshEnable || self.hidden)
            {
                return
            }
            
            let y:CGFloat = scrollView!.contentOffset.y
            
            // 如果是向上滚动到看不见头部控件，直接返回
            if (y >= 0){return}
            
            XRefreshHeaderProgressBlock?(self,Double(-y/height))
            
            if (scrollView!.dragging)
            {
                if (self.state == .Normal && y <= -height)
                {
                    self.setState(.Pulling)
                }
                else if (self.state == .Pulling && y > -height)
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
        XRefreshHeaderProgressBlock?(self,1.0)
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
    
    func setState(state:XRefreshState)
    {
        if self.state ==  state
        {
            return
        }
        
        let oldState = self.state
        
        switch state
        {
        case .Normal:
            
            if(oldState == .Refreshing)
            {
                // 保存刷新时间
                self.refrushTime = NSDate()
                self.downIcon.transform = CGAffineTransformIdentity;
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    
                    self.activity.alpha=0.0
                    self.scrollView?.contentInset.top = 0
                    
                    }, completion: { (finish) -> Void in
                        
                        self.activity.hidden = true
                        self.activity.alpha=1.0
                        self.activity.stopAnimating()
                        self.state = state
                        
                        let delayInSeconds:Double=0.25
                        let popTime:dispatch_time_t=dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                        
                        dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                            XRefreshHeaderEndBlock?(self)
                            self.state = .Pulling
                            self.setState(.Normal)
                            
                            if(self.scrollView?.footRefresh?.end != true)
                            {
                                self.scrollView?.footRefresh?.reSet()
                            }
                            
                            self.scrollView!.refreshEnable = true
                            
                        })
                })
                
            }
            else
            {
                self.state = state
                self.downIcon.hidden = false
                self.activity.stopAnimating()
                self.activity.hidden = true
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.downIcon.transform=CGAffineTransformMakeRotation(CGFloat(M_PI)*CGFloat(2.0))
                    
                    }, completion: { (finish) -> Void in
                        
                })
            }
            
            
        case .Pulling:
            self.state = state
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.downIcon.transform=CGAffineTransformMakeRotation(CGFloat(M_PI)*CGFloat(1.0))
                
                }, completion: { (finish) -> Void in
                    
            })
            
        case .Refreshing:
            scrollView!.refreshEnable = false
            self.state = .Refreshing
            self.state = state
            
            self.downIcon.hidden = true
            self.activity.hidden = false
            self.activity.startAnimating()
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.scrollView!.contentInset.top=self.height
                self.scrollView!.setContentOffset(CGPointMake(0, -self.height), animated: false)
                
                }, completion: { (finish) -> Void in
                    
                    self.scrollView?.footRefresh?.end=false
                    XRefreshHeaderBeginBlock?(self)
                    self.block?()
                    
            })
            
        case .WillRefreshing:
            ""
        default:
            ""
        }
        
        
        self.setStateText()
    }
    
    func setStateText()
    {
        switch self.state
        {
        case .Normal:
            ""
            self.msgLabel.text = "下拉可以刷新"
            
        case .Pulling:
            ""
            self.msgLabel.text = "松开马上刷新"
            
        case .Refreshing:
            ""
            self.msgLabel.text = "正在玩命刷新"
            
        case .WillRefreshing:
            ""
        default:
            ""
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        if (self.state == .WillRefreshing) {
            self.setState(.Refreshing)
        }
    }
    
    
    deinit
    {
        self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        self.scrollView = nil
        self.block = nil
    }
    
    
}

