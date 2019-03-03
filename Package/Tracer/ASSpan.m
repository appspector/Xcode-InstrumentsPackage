//
//  ASSpan.m
//  Package
//
//  Created by Deszip on 01/03/2019.
//  Copyright © 2019 AppSpector. All rights reserved.
//

#import "ASSpan.h"

@implementation ASSpan

+ (instancetype)spanWithName:(NSString *)name spanID:(NSString *)spanID log:(os_log_t)log {
    return [[ASSpan alloc] initWithName:name spanID:scopeID log:log];
}

- (instancetype)initWithName:(NSString *)name spanID:(NSString *)spanID log:(os_log_t)log {
    if (self = [super init]) {
        _name = name;
        _spanID = spanID;
        _signpostID = os_signpost_id_make_with_id(log, self);
    }
    
    return self;
}

@end
