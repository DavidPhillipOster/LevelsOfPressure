#import "Lev+UIColor.h"

static CGFloat sAlpha = (CGFloat) 0.7;

@implementation UIColor (Lev)
+ (UIColor *)lev_low {
  static UIColor *result = nil;
  if (nil == result) {
    result = [UIColor colorWithRed:(CGFloat)(0x32 / 255.)
                             green:(CGFloat)(0xA0 / 255.) blue:(CGFloat)(0xBC / 255.) alpha:sAlpha];
  }
  return result;
}

+ (UIColor *)lev_middle{
  static UIColor *result = nil;
  if (nil == result) {
    result = [UIColor colorWithRed:(CGFloat)(0x32 / 255.)
                             green:(CGFloat)(0xBC / 255.) blue:(CGFloat)(0x32 / 255.) alpha:sAlpha];
  }
  return result;
}

+ (UIColor *)lev_warning{
  static UIColor *result = nil;
  if (nil == result) {
    result = [UIColor colorWithRed:(CGFloat)(0xBC / 255.)
                             green:(CGFloat)(0xAA / 255.) blue:(CGFloat)(0x32 / 255.) alpha:sAlpha];
  }
  return result;
}

+ (UIColor *)lev_danger{
  static UIColor *result = nil;
  if (nil == result) {
    result = [UIColor colorWithRed:(CGFloat)(0xBC / 255.)
                             green:(CGFloat)(0x32 / 255.) blue:(CGFloat)(0x32 / 255.) alpha:sAlpha];
  }
  return result;
}

@end
