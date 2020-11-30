//
//  RegisterViewController.swift
//  WiSwitch
//
//  Created by Leo Li on 2020/11/30.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if usernameField.text == "" || pwField.text == ""{
            popAlert(msg: "No username/password entered")
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(pwField.text!, forKey: usernameField.text!)
        
        let alert = UIAlertController.init(title: "Success", message: "Please login with your credentials", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func popAlert(msg:String, title: String = "Error"){
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
