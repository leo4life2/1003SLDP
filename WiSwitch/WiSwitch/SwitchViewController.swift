//
//  SwitchViewController.swift
//  WiSwitch
//
//  Created by Leo Li on 2020/11/4.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import UIKit

class SwitchViewController: UIViewController {
    var dweetKey: String!
    var switchState = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchTap(_ sender: UIButton) {
        if switchState{
            sender.setImage(UIImage(named: "off"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "on"), for: .normal)
        }
        switchState = !switchState
        
        dweetSignal(key: self.dweetKey, value: String(switchState))
    }
    
    func dweetSignal(key: String, value: String){
        
        let url = URL(string: "https://dweet.io/dweet/for/\(key)?l=\(value)")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
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
