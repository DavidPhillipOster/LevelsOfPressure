## Levels of Pressure

10/03/2015 - Demonstrates that Pre-6s hardware can detect the difference
between a light touch and a heavy one. iOS 8 and up.

Yes, it's really the major radius of the contact area of the touch, but close enough for you to
play around with it.

In Xcode, change the Project's Target's general settings, 'bundle id to yours, set up your team, and compile and run it on your device.

Try touching lightly. Try touching hard. You can touch with multiple fingers at once.

Sample screen shot, landscape mode. Multiple fingers on the device:

![sample](https://github.com/DavidPhillipOster/LevelsOfPressure/blob/master/Art/Sample.png "Sample screen shot.")

Not all of your friends have Force Touch capable hardware. In debug builds of your app, you can use the majorRadius of the touch as a substitute for the force level, since human fingers make a larger contact with the glass as you press harder.

LevelsOfPressure is a demo app, where you can see what that's like on your own devices. For a light touch, it draws a circle around your fingertip. As you press harder, it draws more concentric circles, the number is proportional to how hard you press.

The mapping between majorRadius and the number of circles is pretty arbitrary. You might want to experiment with that.

The numeric values, in the order the fingers touch the display, are graphed at the bottom.

majorRadius was introduced in iOS 8.

by David Phillip Oster

Apache Version 2 License
