//
//  ViewController.m
//  AlarmApp
//
//  Created by baek on 2017. 3. 7..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize infoButton;
@synthesize mainViewController;

- (void)viewDidLoad {
    MainViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController = viewController;
    
    // Put MainViewController behind infoButton.
    [self.view insertSubview:viewController.view belowSubview:infoButton];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
