//
//  AppDelegate.swift
//  Package
//
//  Created by Deszip on 11/06/2018.
//  Copyright © 2018 AppSpector. All rights reserved.
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
        
        timer = Timer(timeInterval: 1.0, repeats: true, block: { timer in
            self.triggerEvent()
        })
        RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
        
        return true
    }

    func triggerEvent() {
        print("Triggered event")
        
        os_signpost(type: .begin,
                    log: AppDelegate.log,
                    name: "Event started",
                    signpostID: AppDelegate.signpostID,
                    "size:%llu", 42)
        
        os_signpost(type: .end,
                    log: AppDelegate.log,
                    name: "Event ended",
                    signpostID: AppDelegate.signpostID,
                    "size:%llu", 314)
    }

}

