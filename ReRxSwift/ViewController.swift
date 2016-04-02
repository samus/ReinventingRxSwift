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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.addTarget(self, action: #selector(textFieldChanged), forControlEvents: UIControlEvents.EditingChanged)
        textField.addTarget(self, action: #selector(textFieldChanged), forControlEvents: UIControlEvents.ValueChanged)
        countLabel.text = "0"
        
        model.addObserver(self, forKeyPath: "uppercased", options: NSKeyValueObservingOptions([.Initial, .New]), context: nil)
    }
    
    func textFieldChanged(sender: AnyObject) {
        model.text = textField.text
        countLabel.text = String(model.charCount)
    }
    
    @IBAction func outOfBandTapped(sender: AnyObject) {
        let someStr = "Out of band tapped"
        textField.text = someStr
        model.text = someStr
        countLabel.text = String(model.charCount)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let theChange = change else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        if (keyPath == "uppercased") {
            if let value = theChange[NSKeyValueChangeNewKey] as? String {
                outputLabel.text = value
            } else {
                outputLabel.text = ""
            }
        }else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    deinit {
        model.removeObserver(self, forKeyPath: "uppercased")
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
