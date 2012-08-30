//
//  Kinect.h
//  Kinector
//
//  Created by foo on 8/14/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timer.h"

@interface Kinect : NSObject {
    Timer *timer;
}

- (void) start;

- (void) stop;

- (BOOL) isRunning;

- (uint8_t *) getDepthBuffer;

@end
