//
//  MainViewController.h
//  AlarmApp
//
//  Created by baek on 2017. 3. 17..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainClockView.h"

@interface MainViewController : UIViewController
{
    NSTimer* timer;
    IBOutlet UILabel* clockDisplay;
    
    IBOutlet MainClockView* pClockView;
}

-(void) onTimer;

@property Boolean pAlarmOnOff;
@property int pAlarmHour;
@property int pAlarmMinute;
@end
