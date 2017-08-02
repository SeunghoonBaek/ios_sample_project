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

@end
