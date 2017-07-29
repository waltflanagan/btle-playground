//
//  AppDelegate.swift
//  btle-mac
//
//  Created by Michael Simons on 7/29/17.
//  Copyright © 2017 FermentedCode, LLC. All rights reserved.
//

import Cocoa
import CoreBluetooth

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    let manager = CBCentralManager()
    
    var peripheral: CBPeripheral?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        manager.delegate = self
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

extension AppDelegate: CBCentralManagerDelegate {
    
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        NSLog("\(central)")
        
        //        manager.scanForPeripherals(withServices: [CBUUID(string:"6E400001-B5A3-F393-E0A9-E50E24DCCA9E")], options: nil)
        manager.scanForPeripherals(withServices: nil, options: nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        NSLog("\(peripheral)")

        if peripheral.identifier == UUID(uuidString: "4047D1C1-D7BB-4DB0-8134-7CEE7B57A7E6") {
            self.peripheral = peripheral
            NSLog("\(peripheral)");
            central.connect(peripheral, options: nil)
            peripheral.delegate = self
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        NSLog("\(peripheral)");
        
        peripheral.discoverServices(nil)
        
        
    }
    
}

extension AppDelegate: CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        NSLog("\(peripheral.services!.first!)")
        
        guard let service = peripheral.services?.first else {return}
        
        peripheral.discoverCharacteristics(nil, for: service)
        
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        NSLog("\(service)")
        for characteristic in service.characteristics! {
            
            NSLog("\(characteristic.value) - \(characteristic.properties)")
        }
    }
}

