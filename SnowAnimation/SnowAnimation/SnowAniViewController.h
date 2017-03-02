//
//  SnowAniViewController.h
//  SnowAnimation
//
//  Created by baek on 2017. 3. 3..
//  Copyright © 2017년 baek-pc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnowAniViewController : UIViewController
{
    UIImageView* snowImageView;
    UIImage* snowImage;
}

-(void) StartBackgroundAnimation:(float) Duration; // Start the animation of movement background
-(void) StartSnowAnimation:(float) Duration; // Start snow animation
-(void) animationTimerHandler:(NSTimer*) theTimer; // Timer event handler
@end
