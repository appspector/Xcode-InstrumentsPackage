//
//  Uptime.h
//  Package
//
//  Created by Deszip on 12/06/2018.
//  Copyright © 2018 AppSpector. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Uptime : NSObject

- (NSTimeInterval)process_uptime;
- (time_t)kern_boottime;

@end

NS_ASSUME_NONNULL_END
