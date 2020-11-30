//
//  SwitchViewController.swift
//  WiSwitch
//
//  Created by Leo Li on 2020/11/4.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import UIKit
import PubNub

class SwitchViewController: UIViewController, PNEventsListener {
    var switchState = false
    
    var client: PubNub!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize and configure PubNub client instance
        let configuration = PNConfiguration(publishKey: "pub-c-7c6e3833-ad7f-455b-bf96-cd4ed9b98bcd", subscribeKey: "sub-c-aabca7ee-3300-11eb-9d95-7ab25c099cb1")
        
        self.client = PubNub.clientWithConfiguration(configuration)
        self.client.addListener(self)

        // Subscribe to demo channel with presence observation
        self.client.subscribeToChannels(["channel1"], withPresence: true)
        
    }
    
    @IBAction func switchTap(_ sender: UIButton) {
        if switchState{
            sender.setImage(UIImage(named: "off"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "on"), for: .normal)
        }
        switchState = !switchState
        
        sendSignal(value: String(switchState))
    }
    
    func sendSignal(value: String){
        
        self.client.publish(value, toChannel: "channel1", withCompletion: nil)
        
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
