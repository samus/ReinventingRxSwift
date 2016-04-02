//
//  Filter.swift
//  ReRxSwift
//
//  Created by Sam Corder on 4/2/16.
//  Copyright © 2016 Synapptic Labs. All rights reserved.
//

import Foundation

class Filter<T>: Observable<T> {
    private let source: Observable<T>
    private let test: (value: T?) -> Bool
    
    init(source: Observable<T>, test: (value: T?) -> Bool) {
        self.source = source
        self.test = test
    }

    override func subscribe(next: T? -> Void) {
        source.subscribe { val in
            if (self.test(value: val)) {
                next(val)
            }
            
        }
    }
}

extension Observable {
    func filter(test: (value: T?) -> Bool ) -> Observable<T> {
        return Filter(source: self, test: test)
    }
}
