//
//  ViewController.swift
//  ReRxSwift
//
//  Created by Sam Corder on 4/1/16.
//  Copyright © 2016 Synapptic Labs. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var fizzbuzzLabel: UILabel!

    let model = ModelObject()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.rx_text.bindTo(model.text).addDisposableTo(disposeBag)
        model.text.asObservable().subscribeNext { val in
            self.textField.text = val
        }.addDisposableTo(disposeBag)
        
        model.uppercased.bindTo(outputLabel.rx_text).addDisposableTo(disposeBag)
        model.charCount.map { val -> String in
            return String(val)
        }.bindTo(countLabel.rx_text).addDisposableTo(disposeBag)
        
        model.fizzbuzz().bindTo(fizzbuzzLabel.rx_text).addDisposableTo(disposeBag)
        
    }
    
    @IBAction func outOfBandTapped(sender: AnyObject) {
        let someStr = "Out of band tapped"
        model.text.value = someStr
    }

}

class ModelObject {
    let text = Variable<String>("")
    let charCount: Observable<Int>
    let uppercased: Observable<String>
    
    init() {
        charCount = text.asObservable().map{ val -> Int in
            return val.characters.count
        }
        uppercased = text.asObservable().map{ val -> String in
            return val.uppercaseString
        }
    }
    
    func fizzbuzz() -> Observable<String> {
        return charCount.asObservable().filter({ (val) -> Bool in
            return val % 3 == 0 || val % 5 == 0
        }).map { (count) -> String in
            if (count == 0) {
                return ""
            } else if (count % 3 == 0 && count % 5 == 0) {
                return "fizzbuzz"
            }else if (count % 3 == 0) {
                return "fizz"
            }else if (count % 5 == 0) {
                return "buzz"
            }
            return ""
        }
    }
}
