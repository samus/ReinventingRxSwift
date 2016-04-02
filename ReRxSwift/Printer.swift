//
//  Printer.swift
//  ReRxSwift
//
//  Created by Sam Corder on 4/2/16.
//  Copyright © 2016 Synapptic Labs. All rights reserved.
//

import Foundation

class Printer<T>: Observable<T> {
    private let source: Observable<T>
    
    init(source: Observable<T>) {
        self.source = source
    }
    
    override func subscribe(next: T? -> Void) {
        source.subscribe { val in
            print(val)
            next(val)
        }
    }
}

extension Observable {
    func printer() -> Observable<T> {
        return Printer(source: self)
    }
}