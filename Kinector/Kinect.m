//
//  Kinect.m
//  Kinector
//
//  Created by foo on 8/14/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import "Kinect.h"
#import <libfreenect/libfreenect.h>

// global to comp unit

volatile int die = 0;

uint8_t *depth_mid;

freenect_context *f_ctx;
freenect_device *f_dev;

int depthCallbacks = 0;

//
// c-lang functions for libfreenect callbacks
//

void logcb(freenect_context *ctx, freenect_loglevel level, const char *msg) {
    NSLog(@"recieved msg: %s", msg);
}

void depth_cb(freenect_device *dev, void *v_depth, uint32_t timestamp) {
    NSLog(@"depth callback..");

    int i;
    
    uint16_t *depth = (uint16_t*) v_depth;
    
    for (i=0; i<640*480; i++) {
        
        // clamp 11-bit depth value to 0-255
        int dc = (int) (depth[i] / 2048.0 * 255.0);
        
        depth_mid[3*i+0] = dc;
        depth_mid[3*i+1] = dc;
        depth_mid[3*i+2] = dc;
    }
}

BOOL kinectContextIsOpen = NO;
BOOL kinectDepthIsOpen = NO;

/**
 * Interface
 */
@interface Kinect()

- (BOOL) openDevice;

- (BOOL) closeDevice;

- (BOOL) openDepth;

- (BOOL) closeDepth;

@end

/**
 * Implementation
 */
@implementation Kinect

- (BOOL) isRunning {
    return kinectDepthIsOpen || kinectContextIsOpen;
}

/**
 * Get pointer to depth buffer.
 */
- (uint8_t *) getDepthBuffer {
    NSLog(@"Kinect - unlockDepthBuffer");
    
    return depth_mid;
}

- (void) start {
    NSLog(@"Kinect - start");
    
    kinectContextIsOpen = [self openDevice];
    kinectDepthIsOpen = [self openDepth];
}

- (void) stop {
    NSLog(@"Kinect - stop");

    die = 1;
    
    if (kinectDepthIsOpen) {
        NSLog(@"result from closing depth is: %d", [self closeDepth]);
    }
    
    if (kinectContextIsOpen) {
        NSLog(@"result from closing device is: %d", [self closeDevice]);
    }
}

- (void) depthLoop {
    NSLog(@"depthLoop");
    
    while (!die) {
        int rez = freenect_process_events(f_ctx);
        NSLog(@"result of p/e: %d", rez);
        if (rez < 0) break;
    }
}

- (BOOL) closeDepth {
    NSLog(@"closeDepth");
    
    // stop depth
    freenect_stop_depth(f_dev);
    
    // free buffer
    free(depth_mid);
    
    kinectDepthIsOpen = NO;
    
    return YES;
}

- (BOOL) openDepth {
    NSLog(@"openDepth");
    
    // allocate memory (freed in close depth)
    depth_mid = (uint8_t*)malloc(640*480*3);

    freenect_set_depth_callback(f_dev, &depth_cb);
    freenect_set_depth_mode(f_dev, freenect_find_depth_mode(FREENECT_RESOLUTION_MEDIUM, FREENECT_DEPTH_11BIT));

    freenect_start_depth(f_dev);
    
    // start reading run loop thread
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(depthLoop)
                                                   object:nil];
    [myThread start];  // actually create the thread
    
    return YES;
}

- (BOOL) closeDevice {
    NSLog(@"closeDevice");
    
    // close device and context
    freenect_close_device(f_dev);
    freenect_shutdown(f_ctx);
    
    kinectContextIsOpen = NO;
    
    return YES;
}

- (BOOL) openDevice {
    NSLog(@"openDevice");

    if (freenect_init(&f_ctx, NULL) < 0) {
        NSLog(@"freenect_init() failed");
        return NO;
    }
    
    freenect_set_log_level(f_ctx, FREENECT_LOG_SPEW);
    
    freenect_set_log_callback(f_ctx, &logcb);
    
    freenect_select_subdevices(f_ctx, FREENECT_DEVICE_CAMERA);
    
    int nr_devices = freenect_num_devices(f_ctx);
    NSLog(@"Number of devices found: %d", nr_devices);

    if (nr_devices < 1) {
        freenect_shutdown(f_ctx);
        return NO;
    }
    
    int sub_devices = freenect_supported_subdevices();
    NSLog(@"subdevice int: %i", sub_devices);
    if ((sub_devices & FREENECT_DEVICE_MOTOR) == 0) NSLog(@"no motor");
    if ((sub_devices & FREENECT_DEVICE_CAMERA) == 0) NSLog(@"no camera");
    if ((sub_devices & FREENECT_DEVICE_AUDIO) == 0) NSLog(@"no audio");
    if ((sub_devices & 0x05) == 0) NSLog(@"no fake");
    
    if (freenect_open_device(f_ctx, &f_dev, 0) < 0) {
        NSLog(@"Could not open device");
        freenect_shutdown(f_ctx);
        return NO;
    }
    
    return YES;
}

@end
