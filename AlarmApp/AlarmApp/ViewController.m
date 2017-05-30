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
@synthesize setupViewController;

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

-(IBAction) setupClick
{
    if(setupViewController == nil)
    {
        setupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SetupViewController"];
    }
    
    [self presentViewController:setupViewController animated:YES completion:nil];
}

-(IBAction) closeClick
{
    [self AlarmSetting];
    [setupViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) AlarmSetting
{
    mainViewController.pAlarmOnOff = setupViewController.switchControl.on;
    
    if(mainViewController.pAlarmOnOff == YES)
    {
        NSCalendar* pCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        
        NSDate* date = [setupViewController.pDatePicker date];
        
        NSDateComponents* comps = [pCalendar components:unitFlags fromDate:date];
        
        mainViewController.pAlarmHour = (int) [comps hour];
        mainViewController.pAlarmMinute = (int) [comps minute];
    }
}


@end
