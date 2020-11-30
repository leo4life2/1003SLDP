//
//  ViewController.swift
//  WiSwitch
//
//  Created by Leo Li on 2020/10/18.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var pwField: UITextField!

    @IBOutlet weak var pulseView: UIView!
    
    var storyBoard: UIStoryboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        self.pulseView.layer.cornerRadius = self.pulseView.frame.width/2
        
        self.pulseView.layer.borderColor = UIColor.black.cgColor
        self.pulseView.layer.borderWidth = 0.1
        
        pulse()
    }
    
    func popAlert(msg:String, title: String = "Error"){
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signInAction(_ sender: Any) {
        
        if usernameField.text == "" || pwField.text == ""{
            popAlert(msg: "No username/password entered")
            return
        }

        let defaults = UserDefaults.standard
        if let pw = defaults.string(forKey: usernameField.text!) {
            if pw == pwField.text{
                // login successful
                let switchViewController = storyBoard.instantiateViewController(withIdentifier: "switchVC") as! SwitchViewController

                self.present(switchViewController, animated: true, completion: nil)
            } else {
                popAlert(msg: "Incorrect password")
                return
            }
        } else {
            popAlert(msg: "Incorrect username")
            return
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let registerVC = storyBoard.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
        
        self.present(registerVC, animated: true, completion: nil)
    }
    
    func pulse(){
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        pulseAnimation.duration = 5
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 0
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = false
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        self.pulseView.layer.add(pulseAnimation, forKey: "animateOpacity")
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 5
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 400
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        scaleAnimation.autoreverses = false
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        self.pulseView.layer.add(scaleAnimation, forKey: "animateScale")
    }
    
}

