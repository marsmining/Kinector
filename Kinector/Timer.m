//
//  Timer.m
//  Kinector
//
//  Created by foo on 8/30/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import "Timer.h"

@interface Timer() {
    @private
    
    int tickindex;
    uint64_t ticksum;
    uint64_t ticklist[MAXSAMPLES];
    uint64_t lastclock;
    mach_timebase_info_data_t info;
}

@end

@implementation Timer

/**
 * Perform the average calculation and array management.
 */
- (double) calcAverageTick:(uint64_t) newtick {
    
    ticksum-=ticklist[tickindex];  /* subtract value falling off */
    ticksum+=newtick;              /* add new value */
    ticklist[tickindex]=newtick;   /* save new value so it can be subtracted later */
    if(++tickindex==MAXSAMPLES)    /* inc buffer index */
        tickindex=0;
    
    /* return average */
    return((double)ticksum/MAXSAMPLES);
}

/**
 * Register tick and return current rolling average.
 */
- (double) timtick {
    uint64_t curr = mach_absolute_time();
    uint64_t diff = curr - lastclock;
    lastclock = curr;
    
    double avg = [self calcAverageTick:diff];
    const double elapsed = avg * (double)info.numer / (double)info.denom;
    return 1.0f / (elapsed / 1000000000);
}

/**
 * Initialize.
 */
- (id) init {
    
    self = [super init];
    
    // init instance vars
    tickindex=0;
    ticksum=0;
    lastclock=0;
    
    // init tick list
    for (int i=0; i < MAXSAMPLES; i++) ticklist[i] = 0;
    
    // get time info
    mach_timebase_info(&info);
    
    return self;
}

@end
