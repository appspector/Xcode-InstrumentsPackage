//
//  ASScope.m
//  Package
//
//  Created by Deszip on 01/03/2019.
//  Copyright © 2019 AppSpector. All rights reserved.
//

#import "ASScope.h"

@interface ASScope ()

@property (strong, nonatomic) NSMutableDictionary <NSNumber *, ASSpan *> *spans;

@end

@implementation ASScope

+ (instancetype)scopeWithName:(NSString *)name scopeID:(NSString *)scopeID log:(os_log_t)log {
    return [[ASScope alloc] initWithName:name scopeID:scopeID log:log];
}

- (instancetype)initWithName:(NSString *)name scopeID:(NSString *)scopeID log:(os_log_t)log {
    if (self = [super init]) {
        _spans = [NSMutableDictionary dictionary];
        _name = name;
        _scopeID = scopeID;
        _signpostID = os_signpost_id_make_with_id(log, self);
    }
    
    return self;
}

- (void)addSpan:(ASSpan *)span {
    if (self.spans[@(span.signpostID)]) {
        return;
    }
    
    self.spans[@(span.signpostID)] = span;
}

- (void)removeSpan:(os_signpost_id_t)spanSignpostID {
    [self.spans removeObjectForKey:@(spanSignpostID)];
}

- (ASSpan *)spanWithSignpostID:(os_signpost_id_t)spanSignpostID {
    return self.spans[@(spanSignpostID)];
}

- (NSUInteger)spanCount {
    return self.spans.count;
}

@end
