//  Created by David Phillip Oster on 10/03/2015.
//  Apache Version 2 License

#import <UIKit/UIKit.h>

@interface LevGraphView : UIView

@property(nonatomic) NSArray *touches;  // input: sorted array of LevTouch

@property(nonatomic) CGFloat maxRadius; // input: the max we've seen so far.

@end
