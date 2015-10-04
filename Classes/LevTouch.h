//  Created by David Phillip Oster on 10/03/2015.
//  Apache Version 2 License

#import <UIKit/UIKit.h>

// A simple copyable object containing the essence of a UITouch.
// The model of this app is an NSSet of them.
@interface LevTouch : NSObject<NSCopying>
@property(nonatomic) CGPoint location;
@property(nonatomic) CGPoint previousLocation;
@property(nonatomic) CGFloat majorRadius;
@property(nonatomic) CGFloat previousMajorRadius;
@property(nonatomic) int index; // An arbitrary nteger used by the owner. isEqual: ignores it.

+ (instancetype)levTouchWithTouch:(UITouch *)touch inView:(UIView *)view;

@end

// Close enough equality for our purposes.
BOOL PointEqualToPoint(CGPoint a, CGPoint b);
