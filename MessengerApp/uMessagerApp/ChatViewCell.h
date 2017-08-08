//
//  ChatViewCell.h
//  uMessageApp
//
//  Created by 소영섭 on 13. 2. 3..
//  Copyright (c) 2013년 소영섭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UILabel *pTimeView;            // 대화 시간
@property(nonatomic, retain) IBOutlet UITextView *pContextView;      // 대화 내용
@property(nonatomic, retain) IBOutlet UIImageView *pBackImageView;

@end
