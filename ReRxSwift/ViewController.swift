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

    let model = ModelObject()
    var observables = [Observable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.addTarget(self, action: #selector(textFieldChanged), forControlEvents: UIControlEvents.EditingChanged)
        
        let ucaseObservable = KVObservable<String>(obj: model, keypath: "uppercased")
        ucaseObservable.subscribe({ value in
            self.outputLabel.text = value
        })
        observables.append(ucaseObservable)
        
        let changedObservable = KVObservable<String>(obj: textField, keypath: "text")
        changedObservable.subscribe { value in
            self.model.text = value
        }
        observables.append(changedObservable)
        
        let countObservable = KVObservable<Int>(obj: model, keypath: "charCount")
        countObservable.subscribe { value in
            if let val = value {
                self.countLabel.text = String(val)
            }else {
                self.countLabel.text = "0"
            }
        }
        observables.append(countObservable)
        
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
