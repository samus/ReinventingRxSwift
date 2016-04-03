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
}
