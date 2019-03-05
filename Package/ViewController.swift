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
    let signpostID: OSSignpostID
    
    init(name: String) {
        self.name = name
        self.signpostID = OSSignpostID(log: ViewController.log, object: name as AnyObject)
    }
}

struct Span {
    let name: String
    let signpostID: OSSignpostID
    
    init(name: String) {
        self.name = name
        self.signpostID = OSSignpostID(log: ViewController.log, object: name as AnyObject)
    }
}

class ViewController: UIViewController {

    static let log = OSLog(subsystem: "com.tracer", category: "Behavior")
    
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
            currentScope = Scope(name: "Scope \(scopeCounter)")
            scopeCounter += 1
        }
    }
    
    @IBAction func startNewSpan(_ sender: Any) {
        guard let scope = currentScope else { return }
        spanCounter += 1
        let span = startSpan("Span: \(spanCounter)", inScope: scope)
        currentSpans.append(span)
    }
    
    @IBAction func stopCurrentSpanWithSuccess(_ sender: Any) {
        if currentSpans.count == 0 {
            return
        }
        guard let span = currentSpans.last else { return }
        stopSpan(span, success: 1)
        currentSpans.removeLast()
    }
    
    @IBAction func stopCurrentSpanWithFailure(_ sender: Any) {
        if currentSpans.count == 0 {
            return
        }
        guard let span = currentSpans.last else { return }
        stopSpan(span, success: 0)
        currentSpans.removeLast()
    }
    
    @IBAction func closeCurrentScope(_ sender: Any) {
        guard let _ = currentScope else { return }
        currentScope = nil
    }
    
    // MARK: API
    
    func startSpan(_ name: String, inScope scope: Scope) -> Span {
        let span = Span(name: name)
        
        os_signpost(.begin, log: ViewController.log, name: "tracing", signpostID: span.signpostID, "span-start:%{public}@,scope-name:%{public}@,span-order:%lld", span.name, scope.name, currentSpans.count)
        
        return span
    }
    
    func stopSpan(_ span: Span, success: Int) {
        os_signpost(.end, log: ViewController.log, name: "tracing", signpostID: span.signpostID, "span-stop:%{public}@,span-success:%lld", span.name, success)
    }

}

