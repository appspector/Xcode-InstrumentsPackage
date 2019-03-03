//
//  ASScope.h
//  Package
//
//  Created by Deszip on 01/03/2019.
//  Copyright © 2019 AppSpector. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASSpan.h"
@import os.signpost;

NS_ASSUME_NONNULL_BEGIN

@interface ASScope : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *scopeID;
@property (assign, nonatomic, readonly) os_signpost_id_t signpostID;

+ (instancetype)scopeWithName:(NSString *)name scopeID:(NSString *)scopeID log:(os_log_t)log;

- (void)addSpan:(ASSpan *)span;
- (void)removeSpan:(os_signpost_id_t)spanSignpostID;
- (ASSpan *)spanWithSignpostID:(os_signpost_id_t)spanSignpostID;
- (NSUInteger)spanCount;

@end

NS_ASSUME_NONNULL_END
