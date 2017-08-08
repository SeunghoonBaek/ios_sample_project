//
//  MemberViewCell.h
//  uMessageApp
//
//  Created by 소영섭 on 13. 2. 3..
//  Copyright (c) 2013년 소영섭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIImageView *pImageView;
@property(weak,nonatomic) IBOutlet UILabel *pNameView;
@property(weak,nonatomic) IBOutlet UILabel *pContextView;
@property(weak,nonatomic) IBOutlet UIImageView *pBackImageView;


@end
