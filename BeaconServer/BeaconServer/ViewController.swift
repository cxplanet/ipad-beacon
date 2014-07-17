//
//  ViewController.swift
//  BeaconServer
//
//  Created by James Lorenzo on 7/16/14.
//  Copyright (c) 2014 James Lorenzo. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {
    
    let proximityGuid: NSUUID = NSUUID(UUIDString: "8966095F-D9B7-48B0-93C1-807669D04821")
    var beaconMgr: CBPeripheralManager!
    @IBOutlet var beaconSwitch: UISwitch
    @IBOutlet var beaconUUID: UILabel
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconMgr = CBPeripheralManager(delegate: self, queue:nil)
        let isAdvertising = beaconMgr.isAdvertising;
        self.beaconSwitch.on = isAdvertising;
        self.beaconUUID.text = proximityGuid.description
        self.beaconUUID.enabled = isAdvertising;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleEnable(AnyObject) {
        // is bluetooth enabled?
        if (beaconMgr.state == .PoweredOn)
        {
            if (beaconSwitch.on)
            {
                let region = CLBeaconRegion(proximityUUID: proximityGuid, identifier: "com.vicarial.testbeacon")
                beaconMgr.startAdvertising(nil)
            }
            else
            {
                beaconMgr.stopAdvertising()
            }
        }
        else // show an alert - this is a bit overkill, as the user is warned by iOS in viewWillAppear
        {
            showAlert("Bluetooth not enabled", message: "Please enable bluetooth in Settings to turn on the beacon")
        }
    }
    
    func showAlert(title: String, message: String)
    {
        // create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        // specify a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in
            NSLog("User selected cancel.")
            self.beaconSwitch.setOn(false, animated: true)
        }
        alertController.addAction(cancelAction)
        // show the alert
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        NSLog("Peripheral manager did update state")
    }


}

