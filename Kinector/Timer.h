//
//  Timer.h
//  Kinector
//
//  Created by foo on 8/30/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mach/mach_time.h>

#define MAXSAMPLES 100

@interface Timer : NSObject {
    
    int tickindex;
    uint64_t ticksum;
    uint64_t ticklist[MAXSAMPLES];
    uint64_t lastclock;
    mach_timebase_info_data_t info;
    
}

- (double) timtick;

@end
