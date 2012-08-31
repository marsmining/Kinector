//
//  timing.h
//  Kinector
//
//  Created by foo on 8/26/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import <mach/mach_time.h>

struct ktimeinfo* timinit();

double timtick(struct ktimeinfo *ctx);