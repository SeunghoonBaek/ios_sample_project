//
//  MainViewController.m
//  AlarmApp
//
//  Created by baek on 2017. 3. 17..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [self onTimer];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    [clockDisplay setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:(64.0f)]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) onTimer{
    int pHour, pMinute, pSecond;
    
    NSCalendar* pCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate* date = [NSDate date];
    NSDateComponents* comps = [pCalendar components:unitFlags fromDate:date];
    pHour = (int)[comps hour];
    pMinute = (int)[comps minute];
    pSecond = (int)[comps second];
    
    clockDisplay.text = [NSString stringWithFormat:@"%02d:%02d:%02d", pHour, pMinute, pSecond];
    
    pClockView.pHour   = pHour;
    pClockView.pMinute = pMinute;
    pClockView.pSecond = pSecond;
    
    [pClockView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
