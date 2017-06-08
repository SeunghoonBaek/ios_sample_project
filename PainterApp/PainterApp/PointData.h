//
//  PointData.h
//  PainterApp
//
//  Created by baek on 2017. 6. 7..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    PEN = 0,
    LINE,
    CIRCLE,
    RECT,
    ERASE
} TYPES;

@interface PointData : NSObject

@property(readonly, nonatomic)  NSMutableArray* points;
@property(strong, nonatomic)    UIColor*        pColor;
@property                       float           pWidth;
@property                       TYPES           pType;

-(void) addPoint:(CGPoint) point;

@end
