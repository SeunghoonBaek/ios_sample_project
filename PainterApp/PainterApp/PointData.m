//
//  PointData.m
//  PainterApp
//
//  Created by baek on 2017. 6. 7..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "PointData.h"

@implementation PointData
@synthesize points;

-(id) init
{
    if(self == [super init])
    {
        points = [[NSMutableArray alloc] init ];
    }
    
    return self;
}

-(void) addPoint:(CGPoint)point
{
    [points addObject:[NSValue valueWithCGPoint:point]];
}
@end
