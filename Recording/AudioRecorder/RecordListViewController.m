
//
//  RecordListViewController.m
//  AudioRecorder
//
//  Created by 소 영섭 on 11. 8. 14..
//  Copyright 2011년 home. All rights reserved.
//

#import "RecordListViewController.h"

#define ROW_HEIGHT 65
@implementation RecordListViewController

@synthesize pAudioPlayer;

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    pDataBase = [[RecordDataBase alloc] init];
    [pListView setRowHeight:ROW_HEIGHT];    //셀의 크기 지정
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    //[pDataBase release];
    
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    if(animated == YES)    [self ReloadRecordList];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//화면의 갱신
-(void) ReloadRecordList
{
    [pDataBase getRecordList];     // 데이터베이스 조회
    [pListView reloadData];        // 테이블뷰 새로고침
    
    
}




#pragma mark 테이블 뷰 델리게이트

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [pDataBase.memoListArray count];
    
    
}

- (UIMemoListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MemoListCell";
    
    UIMemoListCell *cell = (UIMemoListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
		NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"UIMemoListCell" owner:nil options:nil];
		cell = [arr objectAtIndex:0];
	}
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSString *pSeq = [[pDataBase.memoListArray objectAtIndex:indexPath.row] objectForKey:@"SEQ"];
    int pRecodingTime = [(NSNumber *)[[pDataBase.memoListArray objectAtIndex:indexPath.row] objectForKey:@"RecordingTM"] intValue];
    
	//[[cell pCelTitle] setText:[[pDataBase.memoListArray objectAtIndex:indexPath.row] objectForKey:@"SEQ"]];
    cell.pDateLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[pSeq substringWithRange:NSMakeRange(0, 4)], 
                                     [pSeq substringWithRange:NSMakeRange(4, 2)], 
                                     [pSeq substringWithRange:NSMakeRange(6, 2)]];
    cell.pTimeLabel.text = [NSString stringWithFormat:@"%@시 %@분 %@초 녹음",[pSeq substringWithRange:NSMakeRange(8, 2)], 
                                     [pSeq substringWithRange:NSMakeRange(10, 2)], 
                                     [pSeq substringWithRange:NSMakeRange(12, 2)]];    
    
    cell.pRecodingTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(pRecodingTime / 3600), 
                                     (pRecodingTime % 3600) / 60, pRecodingTime % 60];    
  
	return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
}

// Override to support editing the list
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
    NSString *pSeq = [[pDataBase.memoListArray objectAtIndex:indexPath.row] objectForKey:@"SEQ"];
    [pDataBase deleteRecordData:pSeq];
    [pDataBase.memoListArray removeObjectAtIndex:indexPath.row];
    [pListView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	
}


#pragma mark Audio Play

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
   // [self.pAudioPlayer release];
    self.pAudioPlayer = nil;
    PlayerButton.title = @"듣기";
}





- (IBAction)AudioPlayingClick
{
    long index = [[pListView indexPathForSelectedRow] row];
    
    if(pDataBase.memoListArray.count == 0) return;
    
    NSString *pRecordFileName = [[pDataBase.memoListArray objectAtIndex:index] objectForKey:@"RecordFileNM"];
    NSLog(@"%@", pRecordFileName);

    if(self.pAudioPlayer == nil || !self.pAudioPlayer.playing)
    {
        self.pAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:pRecordFileName] error:nil];
        self.pAudioPlayer.delegate = self; 
        
        [self.pAudioPlayer prepareToPlay];
        [self.pAudioPlayer play];
        PlayerButton.title = @"멈춤"; 
        
    } else
    {
        [self.pAudioPlayer stop];
        PlayerButton.title = @"듣기"; 
     //   [self.pAudioPlayer release];
        self.pAudioPlayer = nil;
    }
    
}


#pragma mark EMail Send
- (IBAction)EMailClick
{
    if(pDataBase.memoListArray.count == 0) return;
    
 	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    long index = [[pListView indexPathForSelectedRow] row];
    NSString *pRecordFileName = [[pDataBase.memoListArray objectAtIndex:index] objectForKey:@"RecordFileNM"];
	
	NSData *data = [NSData dataWithContentsOfFile:pRecordFileName];
    //첨부파일 등록
	[picker addAttachmentData:data mimeType:@"audio/mp4" fileName:pRecordFileName];
    
	picker.mailComposeDelegate = self;
    [picker setSubject: @"음성녹음메모가 도착하였습니다"];  //메일 본문
    [self presentViewController:picker animated:YES completion:nil];
	//[self presentModalViewController:picker animated:YES];
 //	[picker release];
}




#pragma mark 메일 델리게이트
- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    UIAlertController* alert;
    UIAlertAction* defaultAction;
    
	switch (result) {
		case MFMailComposeResultCancelled:     // 메일전송 취소시
			break;
		case MFMailComposeResultSaved:         // 메일 저장시
             NSLog(@"저장");
			break;
		case MFMailComposeResultSent:          // 메일 전송 성공시
            
            alert = [UIAlertController alertControllerWithTitle:@"녹음기"
                                                      message:@"성공적으로 보냈습니다."
                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
			break;
        case MFMailComposeResultFailed:        // 메일 전송 실패시
            alert = [UIAlertController alertControllerWithTitle:@"녹음기"
                                                        message:@"전송에 실패했습니다."
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
            defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
			break;
	};
	//[controller dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:nil];
}



@end
