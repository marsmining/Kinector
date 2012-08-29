//
//  Kinect.h
//  Kinector
//
//  Created by foo on 8/14/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Kinect : NSObject

- (void) start;

- (void) stop;

- (BOOL) isRunning;

- (uint8_t *) getDepthBuffer;

@end
