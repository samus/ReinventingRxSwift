//
//  Map.swift
//  ReRxSwift
//
//  Created by Sam Corder on 4/2/16.
//  Copyright © 2016 Synapptic Labs. All rights reserved.
//

import Foundation

class Map<R,T>: Observable<R> {
    private let source: Observable<T>
    private let map: (value: T) -> R
    
    init(source: Observable<T>, map: (value: T) -> R) {
        self.source = source
        self.map = map
    }
    
    override func subscribe(next: R? -> Void) {
        source.subscribe { val in
            next(self.map(value: val!))
        }
    }
}

extension Observable {
    func map<R>(map: (value: T) -> R ) -> Observable<R> {
        return Map<R, T>(source:self, map:map)
    }
}