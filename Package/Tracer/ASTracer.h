//
//  ASTracer.h
//  Package
//
//  Created by Deszip on 01/03/2019.
//  Copyright © 2019 AppSpector. All rights reserved.
//

#import <Foundation/Foundation.h>
@import os.signpost;

NS_ASSUME_NONNULL_BEGIN

@interface ASTracer : NSObject

+ (instancetype)tracer;
    
- (os_signpost_id_t)startSpan:(NSString *)spanName inScope:(NSString *)scopeName;
- (void)stopSpan:(os_signpost_id_t)spanID inScope:(NSString *)scopeName;
    
@end

NS_ASSUME_NONNULL_END
