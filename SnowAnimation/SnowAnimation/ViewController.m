//
//  ViewController.m
//  SnowAnimation
//
//  Created by baek-pc on 2017. 2. 28..
//  Copyright © 2017년 baek-pc. All rights reserved.
//

#import "ViewController.h"
#import "SnowAniViewController.h"

@implementation ViewController

@synthesize infoButton;

- (void)viewDidLoad {
    // [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SnowAniViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SnowAniViewController"];
    
    // Insert Snow View behind info button
    [self.view insertSubview:viewController.view belowSubview:infoButton];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden{
    return YES;
}

@end
