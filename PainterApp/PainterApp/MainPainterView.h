//
//  MainPainterView.h
//  PainterApp
//
//  Created by baek on 2017. 6. 7..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointData.h"

@interface MainPainterView : UIView
{
    NSMutableArray* pPointArray;
    
    UIColor* pCurColor;
    float pCurWidth;
    TYPES pCurType;
}

@property (nonatomic, retain) PointData* curPointData;

-(void) drawScreen:(PointData *)pData inContext:(CGContextRef)context;
-(void) drawPen:(PointData *)pData inContext:(CGContextRef)context;
-(void) drawLine:(PointData *)pData inContext:(CGContextRef)context;
-(void) drawCircle:(PointData *)pData inContext:(CGContextRef)context;
-(void) drawErase:(PointData *)pData inContext:(CGContextRef)context;
-(void) drawFillRect:(PointData *)pData inContext:(CGContextRef)context;
-(void) initCurPointData;
-(void) setCurType:(TYPES)type;
-(void) setCurColor:(UIColor *)color;
-(void) setCurWidth:(float)width;
@end
