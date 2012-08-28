//
//  Kinect.h
//  Kinector
//
//  Created by foo on 8/14/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Kinect : NSObject

- (BOOL) openDevice;

- (BOOL) closeDevice;

- (BOOL) openDepth;

- (BOOL) closeDepth;

- (void) stop;

@end
