//
//  ViewController.swift
//  WiSwitch
//
//  Created by Leo Li on 2020/10/18.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var keyText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func signInAction(_ sender: Any) {
        
        if keyText.text == ""{
            let alert = UIAlertController.init(title: "Error", message: "No code entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let switchViewController = storyBoard.instantiateViewController(withIdentifier: "switchVC") as! SwitchViewController
        
        switchViewController.dweetKey = self.keyText.text
        
        self.present(switchViewController, animated: true, completion: nil)
    }
    
}

