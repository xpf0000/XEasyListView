//
//  XTableView.swift
//  lejia
//
//  Created by X on 15/10/17.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
import Foundation


class XTableView: UITableView ,UITableViewDataSource,UITableViewDelegate{

    var CellIdentifier:String = ""
    var cellHeight:CGFloat = 0.0
    var cellHDict:[NSIndexPath:CGFloat] = [:]
    var postDict:Dictionary<String,AnyObject>=[:]
    
    var delegates:[UITableViewDelegate] = []
    
    var publicCell:UITableViewCell?
    
    func Delegate(d:UITableViewDelegate)
    {
        delegates.append(d)
    }
    
    func DataSource(d:UITableViewDataSource)
    {
        dataSources.append(d)
    }
    
    var dataSources:[UITableViewDataSource] = []
    
    
    let httpHandle:XHttpHandle=XHttpHandle()
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.initTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initTable()
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if(newSuperview == nil)
        {
            //self.block = nil
            //self.editBlock = nil
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if(self.superview == nil)
        {
            //self.block = nil
            //self.editBlock = nil
        }
    }
    
    func initTable()
    {
        delegate = self
        dataSource = self
        
        dataSources.removeAll(keepCapacity: false)
        delegates.removeAll(keepCapacity: false)
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        tableFooterView=view1
        tableHeaderView=view1
        
        httpHandle.scrollView = self

    }
    
    
    func refresh()
    {
        self.beginHeaderRefresh()
    }
    
    
    func setHandle(url:String,pageStr:String,keys:[String],model:AnyClass,CellIdentifier:String)
    {
        
        httpHandle.setHandle(self,url:url, pageStr: pageStr, keys: keys, model: model)
        
        self.CellIdentifier = CellIdentifier

    }
    
    func show()
    {

        httpHandle.ResetBlock { [weak self](o) in
            
            self?.cellHDict.removeAll(keepCapacity: false)
        }
        
        self.setHeaderRefresh { [weak self] () -> Void in
            
            self?.httpHandle.reSet()
            
            self?.httpHandle.handle()
        }

        self.setFooterRefresh {[weak self] () -> Void in
            
            self?.httpHandle.handle()
        }
        
        self.httpHandle.handle()
        
    }

        
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        delegates.last?.tableView?(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.httpHandle.listArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if publicCell == nil
        {
            publicCell = dequeueReusableCellWithIdentifier(CellIdentifier)
        }
        
        if let h = cellHDict[indexPath]
        {
            return h
        }
        else
        {
            if cellHeight == 0.0
            {
                let model = httpHandle.listArr[indexPath.row]
                publicCell?.setValue(model, forKey: "model")
                
                let size = publicCell?.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                
                if let h = size?.height
                {
                    cellHDict[indexPath] = h
                    
                    return h
                }
            }
        }
        
        return cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        let model = self.httpHandle.listArr[indexPath.row]
        
        cell.setValue(model, forKey: "model")
    
        for (key,val) in self.postDict
        {
            cell.setValue(val, forKey: key)
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        
        if let b = dataSources.last?.tableView?(tableView, canEditRowAtIndexPath: indexPath)
        {
            return b
        }
        
        return false
      
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        dataSources.last?.tableView?(tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: indexPath)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        delegates.last?.tableView?(tableView, didSelectRowAtIndexPath: indexPath)
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return delegates.last?.tableView?(tableView, viewForFooterInSection: section)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return delegates.last?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return dataSources.last?.tableView?(tableView, titleForFooterInSection: section)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return dataSources.last?.tableView?(tableView, titleForHeaderInSection: section)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        delegates.last?.tableView?(tableView, didDeselectRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if let h = delegates.last?.tableView?(tableView, heightForFooterInSection: section)
        {
            return h
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
 
        if let h = delegates.last?.tableView?(tableView, heightForHeaderInSection: section)
        {
            return h
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        delegates.last?.tableView?(tableView, didHighlightRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        
        delegates.last?.tableView?(tableView, didEndEditingRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        delegates.last?.tableView?(tableView, didUnhighlightRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if let h = dataSources.last?.tableView?(tableView, canMoveRowAtIndexPath: indexPath)
        {
            return h
        }
        
        return false
    }
    
    func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if #available(iOS 9.0, *) {
            if let h = delegates.last?.tableView?(tableView, canFocusRowAtIndexPath: indexPath)
            {
                return h
            }
        } else {
            // Fallback on earlier versions
        }
        
        return false
    }
    
    func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        
        delegates.last?.tableView?(tableView, willBeginEditingRowAtIndexPath: indexPath)
    }
    
    
    deinit
    {
        self.delegate = nil
        self.dataSource = nil
        cellHDict.removeAll(keepCapacity: false)
        postDict.removeAll(keepCapacity: false)
        delegates.removeAll(keepCapacity: false)
        dataSources.removeAll(keepCapacity: false)
    
    }
    
}
