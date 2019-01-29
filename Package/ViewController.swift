//
//  ViewController.swift
//  Package
//
//  Created by Deszip on 11/06/2018.
//  Copyright © 2018 AppSpector. All rights reserved.
//

import UIKit
import os.signpost

struct Scope {
    let name: String
    let ID: String
}

struct Span {
    let name: String
    let ID: String
    let scopeID: String
}

class ViewController: UIViewController {

    static let log = OSLog(subsystem: "com.tracer", category: "Behavior")
    static let signpostID = OSSignpostID(log: ViewController.log, object: self as AnyObject)
    
    var scopeCounter: Int = 0
    var spanCounter: Int = 0
    var currentScope: Scope?
    var currentSpan: Span?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Actions
    
    @IBAction func openNewScope(_ sender: Any) {
        if currentScope == nil {
            scopeCounter += 1
            currentScope = openScope("\(scopeCounter)")
        }
    }
    
    @IBAction func startNewSpan(_ sender: Any) {
        if currentSpan == nil {
            guard let scope = currentScope else { return }
            spanCounter += 1
            currentSpan = startSpan("Span: \(spanCounter)", inScope: scope)
        }
    }
    
    @IBAction func stopCurrentSpan(_ sender: Any) {
        guard let span = currentSpan else { return }
        stopSpan(span)
        currentSpan = nil
    }
    
    @IBAction func closeCurrentScope(_ sender: Any) {
        guard let scope = currentScope else { return }
        closeScope(scope)
        currentScope = nil;
    }
    
    // MARK: API
    
    func openScope(_ name: String) -> Scope {
        let scope = Scope(name: name, ID: UUID().uuidString)
        os_signpost(.begin, log: ViewController.log, name: "tracing", signpostID: ViewController.signpostID, "scope-open: %{public}@", scope.name)
        
        print("Scope opened")
        
        return scope
    }
    
    func closeScope(_ scope: Scope) {
        os_signpost(.end, log: ViewController.log, name: "tracing", signpostID: ViewController.signpostID, "scope-close: %{public}@", scope.name)
        
        print("Scope closed")
    }
    
    func startSpan(_ name: String, inScope scope: Scope) -> Span {
        let span = Span(name: name, ID: UUID().uuidString, scopeID: scope.ID)
        let startTime = Date().timeIntervalSince1970
        os_signpost(.begin, log: ViewController.log, name: "tracing", signpostID: ViewController.signpostID, "span-start:%{public}@,scope-id:%{public}@,start-time:%lld", span.name, span.scopeID, startTime)
        
        return span
    }
    
    func stopSpan(_ span: Span) {
        let stopTime = Date().timeIntervalSince1970
        os_signpost(.end, log: ViewController.log, name: "tracing", signpostID: ViewController.signpostID, "span-stop:%{public}@,scope-id:%{public}@,stop-time:%lld", span.name, span.scopeID, stopTime)
    }

}

