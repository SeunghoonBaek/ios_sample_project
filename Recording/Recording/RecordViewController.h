//
//  RecordViewController.h
//  Recording
//
//  Created by baek on 2017. 8. 3..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

#import "MeterGaugeView.h"
#import "RecordDataBase.h"

@interface RecordViewController : UIViewController<AVAudioRecorderDelegate>
{
    IBOutlet UIButton* pRecordButton;
    IBOutlet UILabel* recordTimeDisplay;
    IBOutlet MeterGaugeView* pGaugeView;
    IBOutlet UIBarButtonItem* listView;
    NSTimer* timer;
    double plowPassResults;
    RecordDataBase* pDataBase;
    
    NSString* pRecordSeq;
    NSString* pRecordFileName;
    int pRecordingTime;
}

-(IBAction)AudioRecordingClick;
-(NSString *)getFileName;
-(BOOL) SetAudioSession;
-(BOOL) AudioRecordingStart;
-(void) ToolbarRecordButtonToogle:(int)index;
-(void) timerFired;

@property (strong, nonatomic) AVAudioRecorder* pAudioRecorder;
@property (strong, nonatomic) AVAudioSession* pAudioSession;

@end
