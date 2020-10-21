//
//  ViewController.swift
//  WiSwitch
//
//  Created by Leo Li on 2020/10/18.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lightSwitch: UISwitch!
    @IBOutlet weak var keyText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        dweetSignal(key: keyText.text!, value: String(sender.isOn))
    }
    
    func dweetSignal(key: String, value: String){
        
        let url = URL(string: "https://dweet.io/dweet/for/\(key)?l=\(value)")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }
    
    
}

