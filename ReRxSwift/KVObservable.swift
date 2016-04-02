//
//  Observable.swift
//  ReRxSwift
//
//  Created by Sam Corder on 4/2/16.
//  Copyright © 2016 Synapptic Labs. All rights reserved.
//

import Foundation

protocol Observable {
    
}

protocol Observer {
    associatedtype Element
    var next: Element -> Void {get set}
}

class AnonymousObserver<T>: Observer {
    typealias Element = T
    var next: Element -> Void
    init(next: Element -> Void){
        self.next = next
    }
}

class KVObservable<T>: Observable {
    let observable: NSObject
    let keypath: String
    
    var observer: Any?
    private var kvObserver: KVObserver?
    
    init(obj: NSObject, keypath: String) {
        self.observable = obj
        self.keypath = keypath
    }
    
    func subscribe(next: T? -> Void){
        let anon = AnonymousObserver<T?>(next: next)
        let kv = KVObserver(obj: observable, keypath: keypath) { val in
            if val as? NSNull != nil {
                anon.next(nil)
            }else {
                anon.next(val as? T)
            }
        }
        kvObserver = kv
        observer = anon
    }
}

@objc private class KVObserver: NSObject {
    let observable: NSObject
    let keypath: String
    let callback: Any -> Void
    
    init(obj: NSObject, keypath: String, callback: (Any -> Void)) {
        observable = obj
        self.keypath = keypath
        self.callback = callback
        super.init()
        
         obj.addObserver(self, forKeyPath: keypath, options: NSKeyValueObservingOptions([.Initial, .New]), context: nil)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let change = change else {
            return
        }
        callback(change[NSKeyValueChangeNewKey])
    }
    
    deinit {
        observable.removeObserver(self, forKeyPath: keypath)
    }
}