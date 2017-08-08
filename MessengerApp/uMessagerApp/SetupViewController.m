//
//  SetupViewController.m
//  uMessageApp
//
//  Created by 소영섭 on 13. 2. 3..
//  Copyright (c) 2013년 소영섭. All rights reserved.
//

#import "MemberListViewController.h"
#import "SetupViewController.h"

#import "ViewController.h"

@implementation SetupViewController

@synthesize pUserIDField;
@synthesize pRootViewController;
@synthesize pPassField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"설정";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) LogIn
{
    [self.view resignFirstResponder];
    [self.pPassField  resignFirstResponder];
    
    [pRootViewController LogIn:pUserIDField.text PassWord:pPassField.text];

}

//status bar를안보이게합니다.
- (BOOL)prefersStatusBarHidden
{
    return YES;
    
}

@end
