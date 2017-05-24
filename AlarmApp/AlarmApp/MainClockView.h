//
//  MainClockView.h
//  AlarmApp
//
//  Created by baek on 2017. 5. 25..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainClockView : UIView
{
    CGImageRef imgClock; // image of clock
    int pHour;
    int pMinute;
    int pSecond;
}

-(void) drawLine : (CGContextRef) context; // Draw line on screen
-(void) drawClockBitmap : (CGContextRef) context; // draw clock image on screen
-(void) DrawSecond:(CGContextRef)context CenterX:(int)pCenterX CenterY:(int)CenterY; // Draw second unit
-(void) DrawMinute:(CGContextRef)context CenterX:(int)pCenterX CenterY:(int)CenterY; // Draw Minute unit
-(void) DrawHour:(CGContextRef)context CenterX:(int)pCenterX CenterY:(int)CenterY; // Draw hour unit

@property int pHour;
@property int pMinute;
@property int pSecond;

@end
