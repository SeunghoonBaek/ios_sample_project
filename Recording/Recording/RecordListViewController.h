//
//  RecordListViewController.h
//  Recording
//
//  Created by baek on 2017. 8. 9..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "RecordDataBase.h"
#import "UIMemoListCell.h"

@interface RecordListViewController :
    UIViewController<AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate>{
    
    RecordDataBase* pDataBase;
    IBOutlet UITableView* pListView;
    IBOutlet UIBarButtonItem* playerButton;
        
    AVAudioPlayer* pAudioPlayer;
}

-(void) ReloadRecordList;
@property (strong, nonatomic) AVAudioPlayer* pAudioPlayer;

@end
