//  Created by David Phillip Oster on 10/03/2015.
//  Apache Version 2 License

#import "LevViewController.h"
#import "LevTouchView.h"

@implementation LevViewController

- (void)loadView {
  [self setTitle:NSLocalizedString(@"LevelsOfPressure", 0)];
  CGRect bounds = [[UIScreen mainScreen] bounds];
  UIView *view = [[LevTouchView alloc] initWithFrame:bounds];
  [view setBackgroundColor:[UIColor colorWithHue:0.6 saturation:0.3 brightness:0.5 alpha:1]];
  [self setView:view];
}

@end
