//
//  PainterSetupViewController.h
//  PainterApp
//
//  Created by baek on 2017. 6. 14..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PainterSetupViewDelegate;

@interface PainterSetupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView* colorPreview;
@property (weak, nonatomic) IBOutlet UISlider* redBar;
@property (weak, nonatomic) IBOutlet UISlider* greenBar;
@property (weak, nonatomic) IBOutlet UISlider* blueBar;
@property (weak, nonatomic) IBOutlet UISlider* widthBar;
@property (unsafe_unretained) id <PainterSetupViewDelegate> delegate;

-(IBAction)PushBackClick;
-(IBAction)ValueChange:(id)sender;

@end

@protocol PainterSetupViewDelegate<NSObject>
-(void) painterSetupViewController:(PainterSetupViewController *)controller setColor:(UIColor *)color;
-(void) painterSetupViewController:(PainterSetupViewController *)controller setWidth:(float) width;
@end
