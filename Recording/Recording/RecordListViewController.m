//
//  RecordListViewController.m
//  Recording
//
//  Created by baek on 2017. 8. 9..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "RecordListViewController.h"
#define ROW_HEIGHT (65)

@implementation RecordListViewController
@synthesize pAudioPlayer;

- (void)viewDidLoad {
    pDataBase = [[RecordDataBase alloc] init];
    [pListView setRowHeight:ROW_HEIGHT];
    [super viewDidLoad];
}

-(void) ReloadRecordList{
    [pDataBase getRecordList];
    [pListView reloadData];
}

-(void) viewDidAppear:(BOOL)animated{
    if(animated == YES){
        [self ReloadRecordList];
    }
}

#pragma mark TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [pDataBase.memoListArray count];
}

-(UIMemoListCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"MemoListCell";
    
    UIMemoListCell* cell = (UIMemoListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"UIMemoListCell" owner:nil options:nil];
        cell = [arr objectAtIndex:0];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSString* pSeq = [[pDataBase.memoListArray objectAtIndex:indexPath.row] objectForKey:@"SEQ"];
    
    int pRecordingTime = [(NSNumber *)[[pDataBase.memoListArray objectAtIndex:indexPath.row] objectForKey:@"RecordingTM"] intValue];
    
    cell.pDateLabel.text = [NSString stringWithFormat:@"%@-%@-%@",
                            [pSeq substringWithRange:NSMakeRange(0, 4)],
                            [pSeq substringWithRange:NSMakeRange(4, 2)],
                            [pSeq substringWithRange:NSMakeRange(6, 2)]
                            ];
    
    cell.pTimeLabel.text = [NSString stringWithFormat:@"%시 %@분 %@초 녹음",
                            [pSeq substringWithRange:NSMakeRange(8, 2)],
                            [pSeq substringWithRange:NSMakeRange(10, 2)],
                            [pSeq substringWithRange:NSMakeRange(12, 2)]
                            ];
    
    cell.pRecordingTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                                    (pRecordingTime / 3600),
                                     pRecordingTime % 60
                                    ];
    
    return cell;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSString* pSeq = [[pDataBase.memoListArray objectAtIndex:indexPath.row] objectForKey:@"SEQ"];
    [pDataBase deleteRecordData:pSeq];
    [pDataBase.memoListArray removeObjectAtIndex:indexPath.row];
    [pListView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark Audio Play
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    self.pAudioPlayer = nil;
    playerButton.title = @"듣기";
}

-(IBAction) audioPlayingClick{
    long index = [[pListView indexPathForSelectedRow] row];
    if(pDataBase.memoListArray.count == 0) {
        return;
    }
    
    NSString* pRecordFileName = [[pDataBase.memoListArray objectAtIndex:index] objectForKey:@"RecordFileNM"];
    if(self.pAudioPlayer == nil || !self.pAudioPlayer.playing){
        self.pAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:pRecordFileName] error:nil];
        
        self.pAudioPlayer.delegate = self;
        [self.pAudioPlayer prepareToPlay];
        [self.pAudioPlayer play];
        playerButton.title = @"멈춤";
        
    }
    else{
        [self.pAudioPlayer stop];
        playerButton.title = @"듣기";
        
        self.pAudioPlayer = nil;
    }
}

#pragma mark EmailSend
-(IBAction)EmailClick{
    if(pDataBase.memoListArray.count == 0){
        return;
    }
    
    MFMailComposeViewController* picker = [[MFMailComposeViewController alloc] init];
    
    long index = [[pListView indexPathForSelectedRow] row];
    NSString* pRecordFileName = [[pDataBase.memoListArray objectAtIndex:index] objectForKey:@"RecordFileNM"];
    
    NSData* data = [NSData dataWithContentsOfFile:pRecordFileName];
    [picker addAttachmentData:data mimeType:@"audio/mp4" fileName:pRecordFileName];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"음성녹음 메모가 도착하였습니다"];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark MailDelegate
-(void)mailComposeController:(MFMailComposeViewController* )controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    UIAlertController* alert;
    UIAlertAction* defaultAction;
    
    switch(result){
        case MFMailComposeResultCancelled :
            break;
            
        case MFMailComposeResultSaved :
            NSLog(@"Saved");
            break;
            
        case MFMailComposeResultSent :
            alert = [UIAlertController alertControllerWithTitle:@"녹음기" message:@"Successful sending mail" preferredStyle:UIAlertControllerStyleAlert];
            defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){}];
            [alert addAction:defaultAction];
            break;
            
        case MFMailComposeResultFailed :
            alert = [UIAlertController alertControllerWithTitle:@"녹음기" message:@"전송에 실패하였습니다." preferredStyle:UIAlertControllerStyleAlert];
            defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){}];
            [alert addAction:defaultAction];
            break;
    };
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
