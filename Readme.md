# Kinector

Just a start at Kinect hacking..

## Notes

Progress log.

### Depth to RGB

The [libfreenect](https://github.com/OpenKinect/libfreenect) library includes a very helpful example, but I had to work extra hard to make sense of the code which translates the depth buffer value to some rgb value for display. Visualizing depth values could be done a million ways. Initially I just scaled the value to 8-bit for grayscale. But I couldn't understand the logic in [this code](https://github.com/OpenKinect/libfreenect/blob/master/examples/glview.c#L290-L340).

First off, if you initialize the depth camera like so:

```c
freenect_set_depth_mode(f_dev, freenect_find_depth_mode(FREENECT_RESOLUTION_MEDIUM, FREENECT_DEPTH_11BIT));
```

And if we use the rgb routine from the `glview.c` linked above, we get:

!http://dl.dropboxusercontent.com/u/58390955/gamma-04.jpg

_the red dot is just some opengl drawing, ignore that_

## Screenshot

![kinector screenshot](http://dl.dropbox.com/u/58390955/kinector.jpg "random screenshot")

### License

Copyright © 2013

Distributed under the Eclipse Public License either version 1.0 or (at your option) any later version.
