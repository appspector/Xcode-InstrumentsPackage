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
    let signpostID: OSSignpostID
    
    init(name: String, ID: String) {
        self.name = name
        self.ID = ID
        self.signpostID = OSSignpostID(log: ViewController.log, object: ID as AnyObject)
    }
}

struct Span {
    let name: String
    let ID: String
    let scopeID: String
    let signpostID: OSSignpostID
    
    init(name: String, ID: String, scopeID: String) {
        self.name = name
        self.ID = ID
        self.scopeID = scopeID
        self.signpostID = OSSignpostID(log: ViewController.log, object: ID as AnyObject)
    }
}

class ViewController: UIViewController {

    static let log = OSLog(subsystem: "com.tracer", category: "Behavior")
    //static let signpostID = OSSignpostID(log: ViewController.log, object: self as AnyObject)
    
    var scopeCounter: Int = 0
    var spanCounter: Int = 0
    var currentScope: Scope?
    var currentSpans: [Span] = []
    
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
        guard let scope = currentScope else { return }
        spanCounter += 1
        let span = startSpan("Span: \(spanCounter)", inScope: scope)
        currentSpans.append(span)
    }
    
    @IBAction func stopCurrentSpan(_ sender: Any) {
        if currentSpans.count == 0 {
            return
        }
        guard let span = currentSpans.last else { return }
        stopSpan(span)
        currentSpans.removeLast()
    }
    
    @IBAction func closeCurrentScope(_ sender: Any) {
        guard let scope = currentScope else { return }
        closeScope(scope)
        currentScope = nil
    }
    
    // MARK: API
    
    func openScope(_ name: String) -> Scope {
        let scope = Scope(name: name, ID: UUID().uuidString)
        os_signpost(.begin, log: ViewController.log, name: "tracing", signpostID: scope.signpostID, "scope-open: %{public}@", scope.name)
        
        print("Scope opened")
        
        return scope
    }
    
    func closeScope(_ scope: Scope) {
        os_signpost(.end, log: ViewController.log, name: "tracing", signpostID: scope.signpostID, "scope-close: %{public}@", scope.name)
        
        print("Scope closed")
    }
    
    func startSpan(_ name: String, inScope scope: Scope) -> Span {
        let span = Span(name: name, ID: UUID().uuidString, scopeID: scope.ID)
        
        os_signpost(.begin, log: ViewController.log, name: "tracing", signpostID: span.signpostID, "span-start:%{public}@,scope-id:%{public}@,span-order:%lld", span.name, span.scopeID, currentSpans.count)
        
        return span
    }
    
    func stopSpan(_ span: Span) {
        os_signpost(.end, log: ViewController.log, name: "tracing", signpostID: span.signpostID, "span-stop:%{public}@,scope-id:%{public}@", span.name, span.scopeID)
    }

}

