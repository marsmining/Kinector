//
//  timing.c
//  Kinector
//
//  Created by foo on 8/26/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#include "timing.h"

// timing stuff
#define MAXSAMPLES 100
int tickindex=0;
uint64_t ticksum=0;
uint64_t ticklist[MAXSAMPLES];
uint64_t lastclock=0;
mach_timebase_info_data_t info;

// average fps calc
double calcAverageTick(uint64_t newtick)
{
    ticksum-=ticklist[tickindex];  /* subtract value falling off */
    ticksum+=newtick;              /* add new value */
    ticklist[tickindex]=newtick;   /* save new value so it can be subtracted later */
    if(++tickindex==MAXSAMPLES)    /* inc buffer index */
        tickindex=0;
    
    /* return average */
    return((double)ticksum/MAXSAMPLES);
}

double timtick() {
    uint64_t curr = mach_absolute_time();
    uint64_t diff = curr - lastclock;
    lastclock = curr;
    double avg = calcAverageTick(diff);
    const double elapsed = avg * (double)info.numer / (double)info.denom;
    return 1.0f / (elapsed / 1000000000);
}

void timinit() {
    
    // init tick list
    for (int i=0; i < MAXSAMPLES; i++) ticklist[i] = 0;
    
    // get time info
    mach_timebase_info(&info);
    
}