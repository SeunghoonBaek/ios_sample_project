//
//  RecordViewController.m
//  AudioRecorder
//
//  Created by 소  소영섭 on 11. 8. 5..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "RecordViewController.h"


//#define XMAX	30.0f

@implementation RecordViewController

@synthesize pAudioRecorder;
@synthesize pAudioSession;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self SetAudioSession];    // 오디오 동작 설정
    [recordTimeDisplay setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:48.0]];  // 폰트설정
    pDataBase = [[RecordDataBase alloc] init];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    //[pDataBase release];
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



//Audio Session 설정
- (BOOL) SetAudioSession
{
    
	self.pAudioSession = [AVAudioSession sharedInstance];
	
    //오디오 카테고리를 설정합니다.
	if (![self.pAudioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil])
		return NO;
	
	if (![self.pAudioSession setActive:YES error:nil])  // 오디오 세션이 활성화 됩니다.
		return NO;
	
	return self.pAudioSession.inputAvailable;
}


//레코딩을 시작한다.
- (IBAction)AudioRecordingClick
{
    if (self.pAudioRecorder != nil)
    {
        if(self.pAudioRecorder.recording) {     // 녹음중일 경우
            [self.pAudioRecorder stop];         // 녹음을 중지합니다.
            pGaugeView.value = 0;
            //오디오 레벨을 표시하는 계기판을 다시 그립니다.
            [pGaugeView setNeedsDisplay]; 
            return;
            
        }
        [[NSFileManager defaultManager] removeItemAtPath:[self.pAudioRecorder.url path] error:nil];
      //  [self.pAudioRecorder release];
    }
    if([self AudioRecordingStart])     // 녹음을 시작합니다.
    {
        [self ToolbarRecordButtonToogle:1];
        // 타이머를 설정합니다.
        timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(timerFired) userInfo:nil repeats:YES]; 
    }
}



//Audio Recording을 시작한다.
- (BOOL)AudioRecordingStart
{
    
    
	NSMutableDictionary *AudioSettting = [NSMutableDictionary dictionary];
	[AudioSettting setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[AudioSettting setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
	[AudioSettting setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey]; // mono
	[AudioSettting setValue: [NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];
	[AudioSettting setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[AudioSettting setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];

    // 녹음된 오디오가 저장된 파일의 URL
 	NSURL *url = [self getAudioFilePath];
	
	// AVAudioRecorder 객체 생성
	self.pAudioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:AudioSettting error:nil];
	if (!self.pAudioRecorder) return NO;

	self.pAudioRecorder.meteringEnabled = YES;  // 모니터링 여부를 설정합니다.
	self.pAudioRecorder.delegate = self;

	
	if (![self.pAudioRecorder prepareToRecord])      // 녹음 준비 여부 확인
        return NO;
	
	if (![self.pAudioRecorder record])    // 녹음시작
		return NO;
	
	return YES;
}

- (NSURL *)getAudioFilePath
{
    //Documents 디렉토리 경로의 위치를 구합니다.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
    
    // 파일명을 구하고 파일 경로를 합친 후 NSURL 객체로 변환합니다.
	NSURL *AudioUrl = [NSURL fileURLWithPath:[documentDirectory stringByAppendingPathComponent:[self getFileName]]];
    
    return AudioUrl;            
    
}


- (NSString *) getFileName
{
	NSDateFormatter *FileNameFormat = [[NSDateFormatter alloc] init];
	[FileNameFormat setDateFormat:@"yyyyMMddHHmmss"];
    
    //파일명을 구합니다.
	NSString *FileNameStr =  [[FileNameFormat stringFromDate:[NSDate date]] stringByAppendingString:@".aif"];
    
  //  [FileNameFormat release];
    
    
    NSLog(@"%@", FileNameStr);
    return FileNameStr;
}



- (void) timerFired
{
	// 현재 측정레벨을 재성정합니다.
	[self.pAudioRecorder updateMeters];
    
    double peak = pow(10, (0.05 * [self.pAudioRecorder peakPowerForChannel:0]));
    plowPassResults = 0.05 * peak + (1.0 - 0.05) * plowPassResults;
    
	// 녹음된 시간을 화면에 갱신합니다.
	recordTimeDisplay.text = [NSString stringWithFormat:@"%@", [self RecordTime:self.pAudioRecorder.currentTime]];
    pRecordingTime = self.pAudioRecorder.currentTime;
    
    pGaugeView.value = plowPassResults;
    [pGaugeView setNeedsDisplay];   // 겨기판을 갱신합니다.
}


//녹음된 시/분/초를 구합니다.
- (NSString *) RecordTime: (int) num
{
	int secs = num % 60;   // 녹음시간 : 초
	int min = (num % 3600) / 60;   // 녹음시간 : 분
    int hour =(num / 3600);        //녹음시간 : 시
    
	return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, secs];
}



- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    
    //데이터베이스에 저장
    pRecordSeq = [[recorder.url.path substringFromIndex:[recorder.url.path length] - 18] substringToIndex:14];
    pRecordFileName = recorder.url.path;
    [pDataBase insertRecordData:pRecordSeq RecordingTM:pRecordingTime RecordFileNM:pRecordFileName];
    
    
    [self ToolbarRecordButtonToogle:0]; 
    [timer invalidate];
    timer = nil;
}



//녹음/몸춤 버튼 이미지 토클 처리
- (void) ToolbarRecordButtonToogle:(int)index
{
	if(index == 0)
		[pRecordButton setImage:[UIImage imageNamed:@"record_on.png"] forState:UIControlStateNormal];
	else
		[pRecordButton setImage:[UIImage imageNamed:@"record_off.png"] forState:UIControlStateNormal];
	
}


@end
