//  Created by David Phillip Oster on 10/03/2015.
//  Apache Version 2 License

#import "LevViewController.h"
#import "LevView.h"

@implementation LevViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self setTitle:NSLocalizedString(@"LevelsOfPressure", 0)];
  }
  return self;
}

- (void)loadView {
  CGRect bounds = [[UIScreen mainScreen] bounds];
  UIView *view = [[LevView alloc] initWithFrame:bounds];
  [view setBackgroundColor:[UIColor colorWithHue:0.6 saturation:0.3 brightness:0.5 alpha:1]];
  [self setView:view];
}

@end
