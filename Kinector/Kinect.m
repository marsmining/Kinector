//
//  Kinect.m
//  Kinector
//
//  Created by foo on 8/14/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import "Kinect.h"
#import "timing.h"
#import <libfreenect/libfreenect.h>

// global to comp unit

volatile int die = 0;

uint16_t t_gamma[2048];

uint8_t *depth_mid;

freenect_device *f_dev;
freenect_context *f_ctx;

struct ktimeinfo *mytimerctx;

//
// c-lang functions for libfreenect callbacks
//

void logcb(freenect_context *ctx, freenect_loglevel level, const char *msg) {
    NSLog(@"Kinect - recieved msg: %s", msg);
}

void depth_cb(freenect_device *dev, void *v_depth, uint32_t timestamp) {
    NSLog(@"Kinect - depth_cb - fps: %3.1f", timtick(mytimerctx));
    
    uint16_t *depth = (uint16_t*) v_depth;    
    
    for (int i=0; i<640*480; i++) {
        int pval = t_gamma[depth[i]];
        int lb = pval & 0xff;
        
        switch (pval>>8) {
            case 0:
                depth_mid[3*i+0] = 255;
                depth_mid[3*i+1] = 255-lb;
                depth_mid[3*i+2] = 255-lb;
                break;
            case 1:
                depth_mid[3*i+0] = 255;
                depth_mid[3*i+1] = lb;
                depth_mid[3*i+2] = 0;
                break;
            case 2:
                depth_mid[3*i+0] = 255-lb;
                depth_mid[3*i+1] = 255;
                depth_mid[3*i+2] = 0;
                break;
            case 3:
                depth_mid[3*i+0] = 0;
                depth_mid[3*i+1] = 255;
                depth_mid[3*i+2] = lb;
                break;
            case 4:
                depth_mid[3*i+0] = 0;
                depth_mid[3*i+1] = 255-lb;
                depth_mid[3*i+2] = 255;
                break;
            case 5:
                depth_mid[3*i+0] = 0;
                depth_mid[3*i+1] = 0;
                depth_mid[3*i+2] = 255-lb;
                break;
            default:
                depth_mid[3*i+0] = 0;
                depth_mid[3*i+1] = 0;
                depth_mid[3*i+2] = 0;
                break;
        }
    }
}


/**
 * Interface
 */
@interface Kinect() {
    BOOL kinectContextIsOpen;
    BOOL kinectDepthIsOpen;
}

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
    NSLog(@"Kinect - getDepthBuffer");
    
    if (kinectDepthIsOpen) return depth_mid;
    
    return 0;
}

- (void) start {
    NSLog(@"Kinect - start");
    
    kinectContextIsOpen = [self openDevice];
    kinectDepthIsOpen = [self openDepth];
}

- (void) stop {
    NSLog(@"Kinect - stop");
    
    if (kinectDepthIsOpen) {
        NSLog(@"Kinect - result from closing depth is: %d", [self closeDepth]);
    }
    
    if (kinectContextIsOpen) {
        NSLog(@"Kinect - result from closing device is: %d", [self closeDevice]);
    }
}

- (void) depthLoop {
    NSLog(@"Kinect - depthLoop");
    
    while (!die) {
        int rez = freenect_process_events(f_ctx);
        if (rez < 0) break;
    }
}

- (BOOL) closeDepth {
    NSLog(@"Kinect - closeDepth");
    
    die = 1;
    free(mytimerctx);
    
    // stop depth
    freenect_stop_depth(f_dev);
    
    // free buffer
    free(depth_mid);
    
    kinectDepthIsOpen = NO;
    
    return YES;
}

- (BOOL) openDepth {
    NSLog(@"Kinect - openDepth");

    die = 0;
    mytimerctx = timinit();
    
    // init gamma array
    for (int i=0; i < 2048; i++) {
        float v = i / 2048.0;
        v = powf(v, 3) * 6;
        t_gamma[i] = v * 6 * 256;
    }

    // allocate memory (freed in close depth)
    depth_mid = (uint8_t*)malloc(640*480*3);

    freenect_set_depth_callback(f_dev, &depth_cb);
    // freenect_set_depth_mode(f_dev, freenect_find_depth_mode(FREENECT_RESOLUTION_MEDIUM, FREENECT_DEPTH_MM));
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
    NSLog(@"Kinect - closeDevice");
    
    // close device and context
    freenect_close_device(f_dev);
    freenect_shutdown(f_ctx);
    
    kinectContextIsOpen = NO;
    
    return YES;
}

- (BOOL) openDevice {
    NSLog(@"Kinect - openDevice");

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

- (id) init {
    
    self = [super init];
    
    if (self) {

        kinectContextIsOpen = NO;
        kinectDepthIsOpen = NO;
    }
    
    return self;
}

@end
