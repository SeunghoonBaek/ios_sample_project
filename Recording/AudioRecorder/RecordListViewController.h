//
//  RecordListViewController.h
//  AudioRecorder
//
//  Created by 소 영섭 on 11. 8. 14..
//  Copyright 2011년 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "RecordDataBase.h"
#import "UIMemoListCell.h"

@interface RecordListViewController : UIViewController <AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate>
{
    RecordDataBase *pDataBase;
    IBOutlet UITableView *pListView;
    IBOutlet UIBarButtonItem *PlayerButton;    
    
    AVAudioPlayer   *pAudioPlayer;    
}

-(void) ReloadRecordList;


@property (strong, nonatomic) AVAudioPlayer  *pAudioPlayer;

@end
