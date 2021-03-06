# Kinector

Work in progress. Mac app which uses Kinect.

## Notes

### Depth to RGB

The [libfreenect](https://github.com/OpenKinect/libfreenect) library
includes a very helpful example, but I had to work extra hard to make
sense of the code which translates the depth buffer value to some rgb
value for display. Visualizing depth values could be done a million
ways. Initially, I just scaled the value to 8-bit for grayscale. But I
was intrigued by the logic in
[this example code](https://github.com/OpenKinect/libfreenect/blob/4d2fede2202c48469aa2300234906d171b7dd7d0/examples/glview.c#L358-L398).

First off, if you initialize the depth camera like so:

```c
freenect_set_depth_mode(f_dev, freenect_find_depth_mode(
    FREENECT_RESOLUTION_MEDIUM, FREENECT_DEPTH_11BIT));
```

And if we use the routine from the `glview.c` linked above, we get an
image with a color range like this:

![](http://clubctrl.com/gamma-04.jpg)

_the red dot is just some opengl drawing, ignore that_

Ok so, in this mode, the depth camera is giving us 11-bit (2048)
values. The first step done for each sample, is a lookup in
the `t_gamma` array, of length 2048. The array is initialized like so:

```c
// init gamma array
for (int i=0; i < 2048; i++) {
    float v = i / 2048.0;
    
    v = powf(v, 3) * 6;
    t_gamma[i] = v * 6 * 256;
}
```

If we plot the array, to visualize like a function, we get:

![](http://clubctrl.com/gamma-01.jpg)

Math is not my strong suit, but I interpret this as normalizing the
range 0 to 2047 to 0 to 1. Then scaling with an exponent of 3 and a
constant `6 * 6 * 256`. So why choose these values?

Next, the value looked up in the gamma array, is bitwise and'd
(masked) with `0xff`, which means we're sort of chopping off the
significant bits beyond 8. If we were to plot it, we get:

![](http://clubctrl.com/gamma-00.jpg)

### License

Copyright © 2013

Distributed under the Eclipse Public License either version 1.0 or (at
your option) any later version.

