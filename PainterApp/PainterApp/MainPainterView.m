//
//  MainPainterView.m
//  PainterApp
//
//  Created by baek on 2017. 6. 7..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "MainPainterView.h"

@implementation MainPainterView

@synthesize curPointData;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self == [super initWithCoder:aDecoder])
    {
        pPointArray = [[NSMutableArray alloc] init];
        pCurColor = [UIColor blackColor];
        pCurWidth = 2.0f;
        pCurType = PEN;
        [self initCurPointData];
    }
    
    return self;
}

-(void) initCurPointData
{
    curPointData = [[PointData alloc] init];
    [curPointData setPColor:pCurColor];
    [curPointData setPWidth:pCurWidth];
    [curPointData setPType:pCurType];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
