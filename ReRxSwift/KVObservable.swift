//
//  Observable.swift
//  ReRxSwift
//
//  Created by Sam Corder on 4/2/16.
//  Copyright © 2016 Synapptic Labs. All rights reserved.
//

import Foundation

protocol Observer {
    var next: String? -> Void {get set}
}

class AnonymousObserver: Observer {
    var next: String? -> Void
    init(next: String? -> Void){
        self.next = next
    }
}

@objc class KVObservable: NSObject {
    var observer: Observer?
    let observable: NSObject
    let keypath: String
    
    init(obj: NSObject, keypath: String) {
        self.observable = obj
        self.keypath = keypath
        
        super.init()
        
        obj.addObserver(self, forKeyPath: keypath, options: NSKeyValueObservingOptions([.Initial, .New]), context: nil)
        
    }
    
    func subscribe(next: String? -> Void){
        let anon = AnonymousObserver(next: next)
        anon.next(self.observable.valueForKey(keypath) as! String?)
        observer = anon
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let observer = self.observer, let theChange = change else {
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