//
//  UIMemoListCell.m
//  MyPIM
//
//  Created by young soeb on 10. 2. 7..
//  Copyright 2010 home. All rights reserved.
//

#import "UIMemoListCell.h"


@implementation UIMemoListCell

@synthesize pDateLabel;
@synthesize pTimeLabel;
@synthesize pRecodingTimeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
