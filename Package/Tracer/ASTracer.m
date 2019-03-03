//
//  ASTracer.m
//  Package
//
//  Created by Deszip on 01/03/2019.
//  Copyright © 2019 AppSpector. All rights reserved.
//

#import "ASTracer.h"

#import "ASScope.h"
#import "ASSpan.h"

static const char *subsystem = "com.tracer";
static const char *category = "Behavior";
static os_log_t tarcer_log;

static ASTracer *sharedTracer;

@interface ASTracer ()

@property (strong, nonatomic) NSMutableDictionary <NSString *, NSNumber *> *scopes;
    
@end

@implementation ASTracer

+ (instancetype)tracer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTracer = [ASTracer new];
        sharedTracer.scopes = [@{} mutableCopy];
        
        if (@available(iOS 12.0, *)) {
            tracer_log = os_log_create(subsystem, category);
        }
    });
    return sharedTracer;
}

- (ASScope *)addScope:(NSString *)scopeName {
    if (self.scopes[scopeName]) {
        return self.scopes[scopeName];
    }
    
    ASScope *scope = [ASScope scopeWithName:scopeName scopeID:[[NSUUID UUID] UUIDString] log:tracer_log];
    self.scopes[scopeName] = scope;
    
    return scope;
}

- (void)removeScope:(NSString *)scopeName {
    [self.scopes removeObjectForKey:scopeName];
}

- (os_signpost_id_t)startSpan:(NSString *)spanName inScope:(NSString *)scopeName {
    if (@available(iOS 12.0, *)) {
        ASScope *scope = self.scopes[scopeName];
        if (!scope) {
            return;
        }
        
        ASSpan *span = [ASSpan spanWithName:spanName spanID:[[NSUUID UUID] UUIDString] log:tracer_log];
        [scope addSpan:span];
        
        os_signpost_interval_begin(tracer_log, span.signpostID, "tracing", "span-start:%{public}@,scope-id:%{public}@,span-order:%lld", spanName, scope.scopeID, [scope spanCount]);
        
        return span.signpostID;
    }
    
    return 0;
}
    
- (void)stopSpan:(os_signpost_id_t)spanSignpostID inScope:(NSString *)scopeName {
    if (@available(iOS 12.0, *)) {
        ASScope *scope = self.scopes[scopeName];
        if (!scope) {
            return;
        }
        
        ASSpan *span = [scope spanWithSignpostID:spanSignpostID];
        if (span) {
            os_signpost_interval_end(tracer_log, spanID, "tracing", "span-stop:%{public}@,scope-id:%{public}@", span.name, scope.scopeID);
            [scope removeSpan:spanSignpostID];
        }
    }
}
    
@end
