//  Created by David Phillip Oster on 10/04/2015.
//  Apache Version 2 License

#import "LevGraphView.h"

#import "LevTouch.h"

enum {
  kFontSize = 11,
  kWidth = 55,
};

@interface LevGraphView()
@property(nonatomic) UIFont *font;
@property(nonatomic) NSDictionary *fontDict;
@end

@implementation LevGraphView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.font = [UIFont systemFontOfSize:kFontSize];
    self.fontDict = @{NSFontAttributeName : self.font,
                      NSForegroundColorAttributeName : [UIColor whiteColor]};
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  [[UIColor whiteColor] set];
  CGRect bounds = self.bounds;
  CGRect topline = CGRectMake(0, kFontSize+1, bounds.size.width, 1.0/[[UIScreen mainScreen] scale]);
  UIRectFill(topline);
  if (self.maxRadius) {
    NSString *s = [NSString stringWithFormat:@"max: %4.1f", _maxRadius];
    CGSize labelMaxSize = [s sizeWithAttributes:self.fontDict];
    CGPoint p = CGPointMake((bounds.size.width - labelMaxSize.width)/2, 0);
    [s drawAtPoint:p withAttributes:self.fontDict];
    NSUInteger count = [_touches count];
    for (NSUInteger i = 0; i < count; ++i) {
      [self drawTouchRadiusAtIndex:i];
    }
  }
}

- (void)drawTouchRadiusAtIndex:(NSUInteger)index {
  CGFloat totalHeight = self.bounds.size.height - 2*kFontSize;
  CGRect bounds = CGRectMake(index*kWidth, 2*kFontSize, kWidth, totalHeight);
  LevTouch *touch = self.touches[index];
  NSString *s = [NSString stringWithFormat:@"– %4.1f –", touch.majorRadius];
  CGSize labelSize = [s sizeWithAttributes:self.fontDict];
  CGFloat dy =  totalHeight*(1 - (touch.majorRadius / self.maxRadius));
  CGPoint p = CGPointMake(bounds.origin.x + (bounds.size.width - labelSize.width)/2, bounds.origin.y + dy);
  [s drawAtPoint:p withAttributes:self.fontDict];
}

- (void)setTouches:(NSArray *)touches {
  _touches = touches;
  [self setNeedsDisplay];
}

- (void)setMaxRadius:(CGFloat) maxRadius {
  if (_maxRadius != maxRadius) {
    _maxRadius = maxRadius;
    [self setNeedsDisplay];
  }
}
@end
