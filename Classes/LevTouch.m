//  Created by David Phillip Oster on 10/03/2015.
//  Apache Version 2 License

#import "LevTouch.h"

@implementation LevTouch

+ (instancetype)levTouchWithTouch:(UITouch *)touch inView:(UIView *)view {
  LevTouch *result = [[self alloc] init];
  result.location = [touch locationInView:view];
  result.majorRadius = touch.majorRadius;
  result.previousLocation = [touch previousLocationInView:view];
  result.previousMajorRadius = touch.majorRadius;
  return result;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  LevTouch *result = [[[self class] alloc] init];
  result.location = self.location;
  result.majorRadius = self.majorRadius;
  result.previousLocation = self.previousLocation;
  result.previousMajorRadius = self.previousMajorRadius;
  return result;
}

- (BOOL)isEqual:(id)object {
  LevTouch *a = (LevTouch *)object;
  return [self class] == [a class] &&
      self.majorRadius == a.majorRadius &&
      self.previousMajorRadius == a.previousMajorRadius &&
      PointEqualToPoint(self.location, a.location) &&
      PointEqualToPoint(self.previousLocation, a.previousLocation) ;
}

- (NSUInteger)hash {
  return *(NSUInteger *)&_location;
}

@end

BOOL PointEqualToPoint(CGPoint a, CGPoint b) {
  return fabs(a.x - b.x) < 2 && fabs(a.y - b.y) < 2;
}

