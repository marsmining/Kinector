//
//  timing.c
//  Kinector
//
//  Created by foo on 8/26/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#include "timing.h"
#include <stdlib.h>

#define MAXSAMPLES 100

// timing stuff

struct ktimeinfo {
    int tickindex;
    uint64_t ticksum;
    uint64_t ticklist[MAXSAMPLES];
    uint64_t lastclock;
};

mach_timebase_info_data_t info;

double calcAverageTick(uint64_t newtick, struct ktimeinfo *ctx) {
    
    ctx->ticksum -= ctx->ticklist[ctx->tickindex];
    ctx->ticksum += newtick;
    ctx->ticklist[ctx->tickindex] = newtick;
    
    if(++ctx->tickindex == MAXSAMPLES)
        ctx->tickindex = 0;
    
    return ((double) ctx->ticksum / MAXSAMPLES);
}

double timtick(struct ktimeinfo *ctx) {
    uint64_t curr = mach_absolute_time();
    uint64_t diff = curr - ctx->lastclock;
    ctx->lastclock = curr;
    double avg = calcAverageTick(diff, ctx);
    const double elapsed = avg * (double)info.numer / (double)info.denom;
    return 1.0f / (elapsed / 1000000000);
}

struct ktimeinfo* timinit() {
    
    struct ktimeinfo *ctx = malloc(sizeof(struct ktimeinfo));
    
    ctx->tickindex = 0;
    ctx->ticksum = 0;
    ctx->lastclock = 0;
    
    // init tick list
    for (int i=0; i < MAXSAMPLES; i++) ctx->ticklist[i] = 0;
    
    // get time info
    mach_timebase_info(&info);
    
    return ctx;
}