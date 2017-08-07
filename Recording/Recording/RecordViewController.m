//
//  RecordViewController.m
//  Recording
//
//  Created by baek on 2017. 8. 3..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "RecordViewController.h"

@implementation RecordViewController

@synthesize pAudioSession;
@synthesize pAudioRecorder;

- (void)viewDidLoad {
    [self SetAudioSession];
    
    [recordTimeDisplay setFont:[UIFont fontWithName:@"BDLCDTempBlack" size:48.0]];
    pDataBase = [RecordDataBase alloc] init];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL) SetAudioSession{
    self.pAudioSession = [AVAudioSession sharedInstance];

    
    if( ![self.pAudioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil]){
        return NO;
    }
    
    if(![self.pAudioSession setActive:YES error:nil]){
        return NO;
    }
    
    return self.pAudioSession.inputAvailable;
}

-(IBAction)AudioRecordingClick{
    if(self.pAudioRecorder != nil){
        
        if(self.pAudioRecorder.recording){
            [self.pAudioRecorder stop];
            pGaugeView.value = 0;
            [pGauageView setNeedsDisplay];
            return;
        }
        [[NSFileManager defaultManager] removeItemAtPath:[self.pAudioRecorder.url path] error:nil];
    }
    
    if([self AudioRecordingStart]){
        [self ToolbarRecordButtonToogle:1];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
}

-(BOOL)AudioRecordingStart{
    NSMutableDictionary* audioSetting = [NSMutableDictionary dictionary];
    [audioSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [audioSetting setValue:[NSNumber numberWithFloat:11025.0f] forKey:AVSampleRateKey];
    [audioSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [audioSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [audioSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [audioSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    NSURL* url = [self getAudioFilePath];
    
    self.pAudioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:audioSetting error:nil];
    
    if(!self.pAudioRecorder){
        return NO;
    }
    
    self.pAudioRecorder.meteringEnabled = YES;
    self.pAudioRecorder.delegate = self;
    
    if(![self.pAudioRecorder prepareToRecord]){
        return NO;
    }
    if(![self.pAudioRecorder record]){
        return NO;
    }
    
    return YES;
}

-(NSURL *) getAudioFilePath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    
    NSURL* audioURL = [NSURL fileURLWithPath:[documentDirectory stringByAppendingPathComponent:[self getFileName]]];
    
    return audioURL;
}

-(NSString *) getFileName{
    NSDateFormatter* fileNameFormat = [[NSDateFormatter alloc] init];
    [fileNameFormat setDateFormat:@"yyyyMMHHmmss"];
    
    NSString* fileNameStr = [[fileNameFormat stringFromDate:[NSDate date]] stringByAppendingString:@".aif"];
    
    return fileNameStr;
}

-(void) timerFired{
    [self.pAudioRecorder updateMeters];
    double peak = pow(10, (0.05 * [self.pAudioRecorder peakPowerForChannel:0]));
    plowPassResults = 0.05 * peak + (1.0 - 0.05) * plowPassResults;
    
    recordTimeDisplay.text = [NSString stringWithFormat:@"%@", [self recordTime:self.pAudioRecorder.currentTime]];
    
    pRecordingTime = self.pAudioRecorder.currentTime;
    pGaugeView.value = plowPassResults;
    [pGagueView setNeedsDisplay];
}

-(NSString *) recordTime:(int) num{
    int secs = num % 60;
    int min = (num % 3600) / 60;
    int hour = (num / 3600);
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, secs];
}

-(void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    pRecordSeq = [[recorder.url.path substringFromIndex:[recorder.url.path length] - 18] substringToIndex:14];

    pRecordFileName = recorder.url.path;
    [pDataBase insertRecordData:pRecordSeq RecordingTM:pRecordingTime RecordFileNM:pRecordFileName];
    
    [self ToolbarRecordButtonToogle:0];
    timer = nil;
}

-(void) ToolbarRecordButtonToogle:(int) index{
    if(index == 0){
        [pRecordButton setImage:[UIImage imageNamed:@"record_on.png"] forState:UIControlStateNormal];
    }
    else{
        [pRecordButton setImage:[UIImage imageNamed:@"record_off.png"] forState:UIControlStateNormal];
    }
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
