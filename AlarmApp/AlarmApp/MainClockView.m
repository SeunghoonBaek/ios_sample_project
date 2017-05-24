//
//  MainClockView.m
//  AlarmApp
//
//  Created by baek on 2017. 5. 25..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "MainClockView.h"

#define SECOND_WIDTH (100)
#define MINUTE_WIDTH (75)
#define HOUR_WIDTH (50)

@implementation MainClockView

@synthesize pHour;
@synthesize pMinute;
@synthesize pSecond;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    UIImage* img = [UIImage imageNamed:@"clock.png"];
    imgClock = CGImageRetain(img.CGImage);
    
    return self;
}

-(void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawClockBitmap:context];
    [self drawLine:context];
}

-(void) drawLine:(CGContextRef) context
{
    int centerX = self.bounds.size.width / 2;
    int centerY = self.bounds.size.height / 2;
    
    [self DrawSecond:context CenterX:centerX CenterY:centerY];
    [self DrawMinute:context CenterX:centerX CenterY:centerY];
    [self DrawHour:context CenterX:centerX CenterY:centerY];
}

-(void) DrawSecond:(CGContextRef)context CenterX:(int)pCenterX CenterY:(int)CenterY
{
    int newX, newY;
    
    newX = (int)(sin(pSecond * 6 * 3.14 / 180) * SECOND_WIDTH + pCenterX);
    newY = (int)(CenterY - (cos(pSecond * 6 * 3.14 / 180) * SECOND_WIDTH));
    
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, pCenterX, CenterY); // Starting point of line
    CGContextAddLineToPoint(context, newX, newY); // Endding point of line
    
    CGContextStrokePath(context); // Drawing line
}

-(void) DrawMinute:(CGContextRef)context CenterX:(int)pCenterX CenterY:(int)CenterY
{
    int newX, newY;
    
    newX = (int)(sin(pMinute * 6 * 3.14 / 180) * MINUTE_WIDTH + pCenterX);
    newY = (int)(CenterY - (cos(pMinute * 6 * 3.14 / 180) * MINUTE_WIDTH));
    
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
    
    CGContextSetLineWidth(context, 3.0);
    CGContextMoveToPoint(context, pCenterX, CenterY);
    CGContextAddLineToPoint(context, newX, newY);
    
    CGContextStrokePath(context);
}

-(void) DrawHour:(CGContextRef)context CenterX:(int)pCenterX CenterY:(int)CenterY
{
    int newX, newY;
    
    newX = (int)(sin(pHour * 30 * 3.14 / 180) * HOUR_WIDTH + pCenterX);
    newY = (int)(CenterY - (cos(pHour * 30 * 3.14 / 180) * HOUR_WIDTH));
    
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
    
    CGContextSetLineWidth(context, 4.0);
    CGContextMoveToPoint(context, pCenterX, CenterY);
    CGContextAddLineToPoint(context, newX, newY);
    
    CGContextStrokePath(context);
}

-(void) drawClockBitmap:(CGContextRef)context
{
    CGContextSaveGState(context); // save previous CTM status.
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height); // Move center point
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextClipToRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(imgClock), CGImageGetHeight(imgClock)), imgClock); // show clock image
    
    CGContextRestoreGState(context);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
