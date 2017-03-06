//
//  SnowAniViewController.m
//  SnowAnimation
//
//  Created by baek on 2017. 3. 3..
//  Copyright © 2017년 baek-pc. All rights reserved.
//

#import "SnowAniViewController.h"

@interface SnowAniViewController ()

@end

@implementation SnowAniViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self StartBackgroundAnimation:5];
    [self StartSnowAnimation:0.25];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) StartBackgroundAnimation:(float)Duration
{
    if(snowImageView == nil){
        snowImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        NSMutableArray* imageArray = [NSMutableArray array];
        
        for(int i = 1 ; i <= 46 ; i++){
            NSString* name = [NSString stringWithFormat:@"snow-%d.tiff", i];
            [imageArray addObject:[UIImage imageNamed:name]];
        }
        
        snowImageView.animationImages = imageArray;
    }
    
    else{
        [snowImageView removeFromSuperview];
    }
    
    snowImageView.animationDuration = Duration;
    snowImageView.animationRepeatCount = 0;
    [snowImageView startAnimating];
    [self.view addSubview:snowImageView];
}

-(void) animationTimerHandler:(NSTimer *)theTimer{
    UIImageView* snowView = [[UIImageView alloc] initWithImage:snowImage];
    
    int startX = round(random() % 375);
    int endX = round(random() % 375);
    
    double snowSpeed = 10 + (random() % 10) / 10.0;
    
    snowView.alpha = 0.9;
    snowView.frame = CGRectMake(startX, -20, 20, 20); // Starting point
    
    [UIView beginAnimations:nil context:(__bridge void *)(snowView)]; // Set animation block
    [UIView setAnimationDuration:snowSpeed]; // Speed of animation
    
    snowView.frame = CGRectMake(endX, 667.0, 20, 20); // destiation point
    [UIView setAnimationDidStopSelector:@selector (animationDidStop:finished:context:)];
    
    [UIView setAnimationDelegate:self];
    [snowImageView addSubview:snowView];
    
    [UIView commitAnimations];
}

-(void) StartSnowAnimation:(float)Duration{
    snowImage = [UIImage imageNamed:@"snow.png"];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(animationTimerHandler:) userInfo:nil repeats:YES];
    
}

-(void) animationDidStop:(NSString *)animationID finished:(NSNumber *) finished context:(void*) context{
    [(__bridge UIImageView*) context removeFromSuperview]; // remove image view
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
