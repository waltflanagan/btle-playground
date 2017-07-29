//
//  AppDelegate.swift
//  btle
//
//  Created by Michael Simons on 5/27/17.
//  Copyright © 2017 FermentedCode, LLC. All rights reserved.
//

import UIKit
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let manager = CBCentralManager()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        manager.delegate = self


        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    var peripheral: CBPeripheral?


}


extension AppDelegate: CBCentralManagerDelegate {
    
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        NSLog("\(central)")
        
        //        manager.scanForPeripherals(withServices: [CBUUID(string:"6E400001-B5A3-F393-E0A9-E50E24DCCA9E")], options: nil)
        manager.scanForPeripherals(withServices: nil, options: nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

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
