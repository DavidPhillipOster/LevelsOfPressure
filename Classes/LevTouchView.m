//  Created by David Phillip Oster on 10/03/2015.
//  Apache Version 2 License

#import "LevTouchView.h"

#import "Lev+UIColor.h"
#import "LevGraphView.h"
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

static void DrawPie(CGContextRef c, CGPoint p, CGFloat value, CGFloat normalValue) {
  value = MAX((CGFloat) 0, MIN((CGFloat) 1, value));
  CGFloat radius = 70;
  CGContextBeginPath(c);
  CGContextMoveToPoint(c, p.x, p.y);
  CGContextAddArc(c, p.x, p.y, radius, -90 * M_PI/180, -90 * M_PI/180 + (value * 2*M_PI), 0);
  CGContextClosePath(c);
  UIColor *color;
  if (value < (CGFloat) normalValue) {
    color = [UIColor lev_low];
  } else if (value < (CGFloat) 7/8.) {
    color = [UIColor lev_middle];
  } else if (value < (CGFloat) 15/16.) {
    color = [UIColor lev_warning];
  } else {
    color = [UIColor lev_danger];
  }
  [color set];
  CGContextFillPath(c);
}

@interface LevTouchView()
// The model of this app is this NSSet of LevTouch.
@property(nonatomic) LevGraphView *graphView;
@property(nonatomic) NSMutableSet *myTouches;
@property(nonatomic) int lastIndex;
@end

@implementation LevTouchView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.multipleTouchEnabled = YES;
    self.myTouches = [NSMutableSet set];
    self.graphView = [[LevGraphView alloc] initWithFrame:CGRectZero];
    [self.graphView setUserInteractionEnabled:NO];
    [self.graphView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.graphView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  enum {
    kGraphHeight = 120
  };
  CGRect graphFrame = self.bounds;
  graphFrame.origin.y += graphFrame.size.height - kGraphHeight;
  graphFrame.size.height = kGraphHeight;
  [self.graphView setFrame:graphFrame];
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}


- (void)drawRect:(CGRect)rect {
  CGContextRef c = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(c, 1);
  for (LevTouch *touch in self.myTouches) {
    if (0.0 != touch.maxForce) {
      //  Apple documents that '1' is a normal toucb. Let's take anything less than 0.8 as light.
      DrawPie(c, touch.location, touch.force/touch.maxForce, 0.8/touch.maxForce);
    }
    [[UIColor whiteColor] set];
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
      if (touch.majorRadius != newTouch.majorRadius) {
        [self.graphView setNeedsDisplay];
      }
      touch.majorRadius = newTouch.majorRadius;
      touch.previousLocation = newTouch.previousLocation;
      touch.previousMajorRadius = newTouch.previousMajorRadius;
      touch.force = newTouch.force;
      touch.maxForce = newTouch.maxForce;
      break;
    }
  }
}

// Other parts of this object call this when the state changes.
// It updates the statistics and arranges for redrawing.
- (void)updateDisplay {
  for (LevTouch *levTouch in self.myTouches) {
    if (_graphView.maxRadius < levTouch.majorRadius) {
      _graphView.maxRadius = levTouch.majorRadius;
    }
  }
  [self setNeedsDisplay];
}

- (void)rebuildTouchArray {
  NSMutableArray *touches = [[self.myTouches allObjects] mutableCopy];
  [touches sortUsingComparator:^(id obj1, id obj2) {
    LevTouch *a = (LevTouch *)obj1;
    LevTouch *b = (LevTouch *)obj2;
    if (a.location.x < b.location.x) {
      return NSOrderedAscending;
    } else if (b.location.x < a.location.x) {
      return NSOrderedDescending;
    } else if (a.index < b.index) {
      return NSOrderedAscending;
    } else if (b.index < a.index) {
      return NSOrderedDescending;
    } else {
      return NSOrderedSame;
    }
  }];
  if (![touches isEqual:self.graphView.touches]) {
    self.graphView.touches = touches;
  }
}

- (void)updateSet:(NSSet *)set {
  for (LevTouch *newTouch in set) {
    [self updateTouch:newTouch];
  }
  [self updateDisplay];
}

- (void)minusSet:(NSSet *)set {
  NSMutableSet *newSet = [NSMutableSet set];
  for (LevTouch *touch in self.myTouches) {
    if (![set containsTouch:touch]) {
      [newSet addObject:touch];
    }
  }
  self.myTouches = newSet;
  if (0 == [self.myTouches count]) {
    self.lastIndex = 0;
  }
  [self rebuildTouchArray];
  [self updateDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
  NSSet *levTouchSet = [touches asSetOfLevTouchesInView:self];
  for (LevTouch *levTouch in levTouchSet) {
    levTouch.index = self.lastIndex++;
  }
  [self.myTouches unionSet:levTouchSet];
  [self rebuildTouchArray];
  [self updateDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
  [self updateSet:[touches asSetOfLevTouchesInView:self]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
  [self minusSet:[touches asSetOfLevTouchesInView:self]];
}

- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
  [self.myTouches removeAllObjects];
  self.lastIndex = 0;
  [self updateDisplay];
}


@end
