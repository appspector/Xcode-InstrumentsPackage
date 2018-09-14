//
//  AppDelegate.swift
//  Package
//
//  Created by Deszip on 11/06/2018.
//  Copyright © 2018 Package. All rights reserved.
//

import UIKit
import os.signpost

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let log = OSLog(subsystem: "com.package", category: "Behavior")
    static let signpostID = OSSignpostID(log: AppDelegate.log, object: self as AnyObject)
    
    var window: UIWindow?
    var timer: Timer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        checkDebugTime()
        
        timer = Timer(timeInterval: 0.01, repeats: true, block: { timer in
            self.triggerEvent()
        })
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
        
        return true
    }

    func triggerEvent() {
        print("Triggered event")
        
        let before = Int.random(in: 100..<1000)
        let after = Int.random(in: 99..<before)
        
        os_signpost(.begin, log: AppDelegate.log, name: "event-tracking", signpostID: AppDelegate.signpostID, "size: %llu", before)
        os_signpost(.end, log: AppDelegate.log, name: "event-tracking", signpostID: AppDelegate.signpostID, "size: %llu", after)
    }
    
    /*
     Kacper Harasim - @KacperHarasim: Was it recently rebooted phone? (Within ~10 hours)? If so — should start working after around a day. There is a release note for that.
     */
    func checkDebugTime() {
        let kern_uptime = Uptime().kern_boottime() / 60;
        print("Uptime: \(kern_uptime) min")
    }

}

