//
//  RecordViewController.h
//  AudioRecorder
//
//  Created by 소  소영섭 on 11. 8. 5..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>


#import "MeterGaugeView.h"
#import "RecordDataBase.h"

@interface RecordViewController : UIViewController<AVAudioRecorderDelegate>
{
 //   AVAudioRecorder *pAudioRecorder;      //AVAudioRecorder 객체 변수
 //	AVAudioSession  *pAudioSession;       //AVAudioSession 객체 변수
 
    IBOutlet UIButton *pRecordButton;
    IBOutlet UILabel *recordTimeDisplay; 

    IBOutlet MeterGaugeView *pGaugeView;       // 계기판 뷰에 대한 참조변수
    IBOutlet UIBarButtonItem *ListButton;
    
    
    NSTimer *timer;
    double plowPassResults;    // 녹음 레벨
    RecordDataBase *pDataBase; // 데이터베이스 제어 클래스 변수
    
    //데이터 베이스에 저장하기 위한 정보
    NSString *pRecordSeq;
    NSString *pRecordFileName;
    int       pRecordingTime;
}

- (IBAction)AudioRecordingClick;     // 녹음시작/멈춤 버튼 클릭시 호출되는 이벤트 함수

- (NSString *) getFileName;

- (BOOL)SetAudioSession;      // 오디오 세션 설정함수
- (BOOL)AudioRecordingStart;    // 녹음시작
- (void)ToolbarRecordButtonToogle:(int)index;
- (void)timerFired;


@property (strong, nonatomic) AVAudioRecorder *pAudioRecorder;
@property (strong, nonatomic) AVAudioSession  *pAudioSession;


@end
