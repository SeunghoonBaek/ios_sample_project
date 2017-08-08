//
//  ViewController.m
//  Recording
//
//  Created by baek on 2017. 8. 3..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "ViewController.h"

#import "RecordViewController.h"
#import "AudioRecorderInfo.h"
#import "RecordListViewController.h"

@implementation ViewController

@synthesize pRecordViewController;
@synthesize pAudioRecorderInfo;
@synthesize pRecordListViewController;

- (void)viewDidLoad {
    
    RecordViewController* viewController = [[RecordViewController alloc] initWithNibName:@"RecordViewController" bundle:nil];
    
    [self.view insertSubview:viewController.view belowSubview:infoButton];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction) RecordInfoClick{
    if(pAudioRecorderInfo == nil){
        AudioRecorderInfo* viewController = [[AudioRecorderInfo alloc] initWithNibName:@"AudioRecorderInfo" bundle:nil];
        
        self.pAudioRecorderInfo = viewController;
    }
    
    UIView* recordView = pRecordViewController.view;
    UIView* AudioRecorderInfoView = pAudioRecorderInfo.view;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:([recordView superview] ? UIViewAnimationTransitionFlipFromRight :
                                    UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
    
    if([recordView superview] != nil){
        [recordView removeFromSuperview];
        [self.view addSubview:AudioRecorderInfoView];
    }
    
    else{
        [AudioRecorderInfoView removeFromSuperview];
        [self.view insertSubview:recordView belowSubview:infoButton];
    }
    
    [UIView commitAnimations];
}

-(IBAction) AudioListClick{
    if(pRecordListViewController == nil){
        RecordListViewController* viewController = [[RecordListViewController alloc] initWithNibName:@"RecordListViewController" bundle:nil];
        
        self.pRecordListViewController = viewController;
    }
    
    UIView* recordView = pRecordViewController.view;
    UIView* recordListView = pRecordListViewController.view;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:([recordView superview] ? UIViewAnimationTransitionCurlUp :
                                    UIViewAnimationTransitionCurlDown) forView:self.view cache:YES];
    
    if([recordView superview] != nil){
        [recordView removeFromSuperview];
        [self.view addSubview:pAudioRecorderInfo];
        [self.pRecordListViewController viewDidAppear:YES];
        [self.pRecordViewController viewDidAppear:NO];
    }
    
    else{
        [recordListView removeFromSuperview];
        [self.view insertSubview:recordView belowSubview:infoButton];
        [self.pRecordListViewController viewDidAppear:NO];
        [self.pRecordViewController viewDidAppear:YES];
    }
    
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) prefersStatusBarHidden{
    return YES;
}

@end
