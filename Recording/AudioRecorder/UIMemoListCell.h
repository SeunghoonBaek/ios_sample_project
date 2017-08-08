//
//  UIMemoListCell.h
//  MyPIM
//
//  Created by young soeb on 10. 2. 7..
//  Copyright 2010 home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIMemoListCell : UITableViewCell

@property (weak, nonatomic)  IBOutlet UILabel * pDateLabel;   // 녹음된 날짜
@property (weak, nonatomic)  IBOutlet UILabel * pTimeLabel;   // 녹음을 시작한 시간
@property (weak, nonatomic)  IBOutlet UILabel * pRecodingTimeLabel;   // 녹음 시간

@end
