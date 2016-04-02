//
//  ViewController.swift
//  ReRxSwift
//
//  Created by Sam Corder on 4/1/16.
//  Copyright © 2016 Synapptic Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var fizzbuzzLabel: UILabel!
    
    let model = ModelObject()
    var observables = [ObservableType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.addTarget(self, action: #selector(textFieldChanged), forControlEvents: UIControlEvents.EditingChanged)
        
        let ucaseObservable = KVObservable<String>(obj: model, keypath: "uppercased").printer()
        ucaseObservable.subscribe({ value in
            self.outputLabel.text = value
        })
        observables.append(ucaseObservable)
        
        let changedObservable = KVObservable<String>(obj: textField, keypath: "text")
        changedObservable.subscribe { value in
            self.model.text = value
        }
        observables.append(changedObservable)
        
        let countObservable = KVObservable<Int>(obj: model, keypath: "charCount").map { (value) -> String in
            return String(value)
        }
        countObservable.subscribe { value in
            self.countLabel.text = value
        }
        observables.append(countObservable)
        
        let fbObservable = KVObservable<Int>(obj: model, keypath: "charCount").filter { (value) -> Bool in
            guard let num = value else {
                return false
            }
            switch num {
            case _ where num <= 0:
                return false
            default:
                return true
            }
        }.map { (value) -> String in
            switch value {
            case _ where value % 3 == 0 && value % 5 == 0:
                return "fizz buzz"
            case _ where value % 3 == 0:
                return "fizz"
            case _ where value % 5 == 0:
                return "buzz"
            default:
                return ""
            }
        }
        
        fbObservable.subscribe { (fb) in
            self.fizzbuzzLabel.text = fb
        }
        
        observables.append(fbObservable)

    }
    
    func textFieldChanged(sender: AnyObject) {
        model.text = textField.text
    }
    
    @IBAction func outOfBandTapped(sender: AnyObject) {
        let someStr = "Out of band tapped"
        textField.text = someStr
    }

}

@objc class ModelObject: NSObject {
    var text: String? {
        didSet {
            if let text = text {
                uppercased = text.uppercaseString
                charCount = text.characters.count
            } else {
                uppercased = nil
            }
        }
    }
    dynamic private (set) var charCount = 0
    dynamic private (set) var uppercased: String?
    
}
