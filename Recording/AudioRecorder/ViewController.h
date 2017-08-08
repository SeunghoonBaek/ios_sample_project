//
//  ViewController.h
//  AudioRecorder
//
//  Created by 소영섭 on 2015. 11. 22..
//  Copyright © 2015년 소영섭. All rights reserved.
//


#import <UIKit/UIKit.h>

@class RecordViewController;
@class AudioRecorderInfo;
@class RecordListViewController;

@interface ViewController : UIViewController
{
    IBOutlet UIButton *infoButton;
}

//어플리케이션 정보 button 클릭시 호출되는 이벤트 함수
-(IBAction)RecordInfoClick;
//List 버튼클륵시 호출되는 이벤트 함수
-(IBAction)AudioListClick;


@property (strong, nonatomic) RecordViewController *pRecordViewController;
@property (strong, nonatomic) AudioRecorderInfo    *pAudioRecorderInfo;
@property (strong, nonatomic) RecordListViewController   *pRecordListViewController;

@end
