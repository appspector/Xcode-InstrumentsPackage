//
//  Uptime.m
//  Package
//
//  Created by Deszip on 12/06/2018.
//  Copyright © 2018 AppSpector. All rights reserved.
//

#import "Uptime.h"
#import <sys/sysctl.h>

@implementation Uptime

- (NSTimeInterval)process_uptime {
    return [[NSProcessInfo processInfo] systemUptime];
}

- (time_t)kern_boottime {
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;
    
    (void)time(&now);
    
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        uptime = now - boottime.tv_sec;
    }
    
    return uptime;
}

@end
