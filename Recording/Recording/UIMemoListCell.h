//
//  UIMemoListCellTableViewCell.h
//  Recording
//
//  Created by baek on 2017. 8. 9..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIMemoListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* pDateLabel;
@property (strong, nonatomic) IBOutlet UILabel* pTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel* pRecordingTimeLabel;
@end
