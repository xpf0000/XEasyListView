//
//  Reflect.swift
//  Reflect
//
//  Created by 冯成林 on 15/8/19.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation

class Reflect: NSObject, NSCoding{
    
    lazy var mirror: Mirror = {Mirror(reflecting: self)}()
    
    required override init(){}
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
        
        let ignorePropertiesForCoding = self.excludedKey()
        
        self.properties { (name, type, value) -> Void in
            assert(type.check(), "[Charlin Feng]: Property '\(name)' type can not be a '\(type.realType.rawValue)' Type,Please use 'NSNumber' instead!")
            
            if(name.rangeOfString(".storage") != nil)
            {
                return
            }
            
            let hasValue = ignorePropertiesForCoding != nil
            
            if hasValue {
                
                let ignore = (ignorePropertiesForCoding!).contains(name)
                
                if !ignore {
                    
                    self.setValue(aDecoder.decodeObjectForKey(name), forKeyPath: name)
                }
            }else{
                
                if let saveValue = aDecoder.decodeObjectForKey(name)
                {
                    switch type.realType
                    {
                    case .String:
                        ""
                        if let v = saveValue as? String
                        {
                            self.setValue(v, forKeyPath: name)
                        }
                        
                    case .Int:
                        ""
                        if let v = saveValue as? Int
                        {
                            self.setValue(v, forKeyPath: name)
                        }
                        
                    case .Float:
                        ""
                        if let v = saveValue as? Float
                        {
                            self.setValue(v, forKeyPath: name)
                        }
                        
                    case .Double:
                        ""
                        if let v = saveValue as? Double
                        {
                            self.setValue(v, forKeyPath: name)
                        }
                        
                    case .Bool:
                        ""
                        if let v = saveValue as? Bool
                        {
                            self.setValue(v, forKeyPath: name)
                        }
                        
                    default:
                        ""
                       self.setValue(saveValue, forKeyPath: name)
                    }
                    
                    
                }
                
                
                
            }
        }
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        let ignorePropertiesForCoding = self.excludedKey()
        
        self.properties { (name, type, value) -> Void in
            
            if(name.rangeOfString(".storage") != nil)
            {
                return
            }
            
            let hasValue = ignorePropertiesForCoding != nil
            
            if hasValue {
                
                let ignore = (ignorePropertiesForCoding!).contains(name)
                
                if !ignore {
                    
                    let o = value as? AnyObject
                    
                    if(o != nil)
                    {
                        aCoder.encodeObject(o!, forKey: name)
                    }
                    else
                    {
                        if(self.valueForKeyPath(name) is NSCoding)
                        {
                            aCoder.encodeObject(self.valueForKeyPath(name), forKey: name)
                        }
                        
                    }
                    
                }
            }else{
                
                let o = value as? AnyObject
                
                if(o != nil)
                {
                    aCoder.encodeObject(o!, forKey: name)
                }
                else
                {
                    if(self.valueForKeyPath(name) is NSCoding)
                    {
                        aCoder.encodeObject(self.valueForKeyPath(name), forKey: name)
                    }
                }
                
            }
            
        }
        
    }
    
    
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}



