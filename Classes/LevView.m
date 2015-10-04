//  Created by David Phillip Oster on 10/03/2015.
//  Apache Version 2 License

#import "LevView.h"
#import "LevTouch.h"


@interface NSSet(LevView)

- (instancetype)asSetOfLevTouchesInView:(UIView *)view;

- (BOOL)containsTouch:(LevTouch *)touch;

@end

@implementation NSSet(LevView)

- (instancetype)asSetOfLevTouchesInView:(UIView *)view {
  NSMutableSet *result = [NSMutableSet set];
  for (UITouch *touch in self) {
    [result addObject:[LevTouch levTouchWithTouch:touch inView:view]];
  }
  return result;
}

- (BOOL)containsTouch:(LevTouch *)aTouch {
  for (LevTouch *touch in self) {
    if ((PointEqualToPoint(touch.location, aTouch.location)  ||
        PointEqualToPoint(touch.previousLocation, aTouch.location))) {
      return YES;
    }
  }
  return NO;
}

@end

@interface LevView()
// The model of this app is this NSSet of LevTouch.
@property(nonatomic) NSMutableSet *myTouches;
@end

@implementation LevView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.multipleTouchEnabled = YES;
    self.myTouches = [NSMutableSet set];
  }
  return self;
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef c = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(c, 1);
  [[UIColor whiteColor] set];
  for (LevTouch *touch in self.myTouches) {
    CGFloat radius = 35;
    CGFloat maxRadius = 10;
    do {
      CGRect r = CGRectMake(touch.location.x - radius, touch.location.y - radius, 2*radius, 2*radius);
      CGContextStrokeEllipseInRect(c, r);
      radius += 10;
      maxRadius += 10;
    } while (maxRadius < touch.majorRadius);
  }
}

- (void)updateTouch:(LevTouch *)newTouch {
  for (LevTouch *touch in self.myTouches) {
    if (PointEqualToPoint(touch.location, newTouch.previousLocation)) {
      touch.location = newTouch.location;
      touch.majorRadius = newTouch.majorRadius;
      touch.previousLocation = newTouch.previousLocation;
      touch.previousMajorRadius = newTouch.previousMajorRadius;
      break;
    }
  }
}

- (void)updateSet:(NSSet *)set {
  for (LevTouch *newTouch in set) {
    [self updateTouch:newTouch];
  }
  [self setNeedsDisplay];
}

- (void)minusSet:(NSSet *)set {
  NSMutableSet *newSet = [NSMutableSet set];
  for (LevTouch *touch in self.myTouches) {
    if (![set containsTouch:touch]) {
      [newSet addObject:touch];
    }
  }
  self.myTouches = newSet;
  [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
  [self.myTouches unionSet:[touches asSetOfLevTouchesInView:self]];
  [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
  [self updateSet:[touches asSetOfLevTouchesInView:self]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
  [self minusSet:[touches asSetOfLevTouchesInView:self]];
}

- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
  [self.myTouches removeAllObjects];
  [self setNeedsDisplay];
}


@end
