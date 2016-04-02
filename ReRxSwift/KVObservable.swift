//
//  Observable.swift
//  ReRxSwift
//
//  Created by Sam Corder on 4/2/16.
//  Copyright © 2016 Synapptic Labs. All rights reserved.
//

import Foundation

protocol Observer {
    func next(val: String?)
}

@objc class KVObservable: NSObject {
    let observer: Observer
    let observable: NSObject
    let keypath: String
    
    init(obj: NSObject, keypath: String, observer: Observer) {
        self.observer = observer
        self.observable = obj
        self.keypath = keypath
        
        super.init()
        obj.addObserver(self, forKeyPath: keypath, options: NSKeyValueObservingOptions([.Initial, .New]), context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let theChange = change else {
            return
        }
        if let value = theChange[NSKeyValueChangeNewKey] as? String {
            observer.next(value)
        } else if let _ = theChange[NSKeyValueChangeNewKey] as? NSNull {
            observer.next(nil)
        }
    }
    
    deinit {
        observable.removeObserver(self, forKeyPath: keypath)
    }
}