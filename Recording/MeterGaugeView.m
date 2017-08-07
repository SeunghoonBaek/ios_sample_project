//
//  MeterGaugeView.m
//  Recording
//
//  Created by baek on 2017. 8. 7..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "MeterGaugeView.h"

@implementation MeterGaugeView

@synthesize value;

#define GAUGE_WIDTH (70)
#define LINE_WIDTH (3)
#define START_ANGLE (255)
#define END_ANGLE (135)


-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    UIImage* img = [UIImage imageNamed:@"gauge.png"];
    imgGauge = CGImageRetain(img.CGImage);
    
    return self;
}

-(void) drawRect:(CGRect)rect{
    int startX = self.bounds.size.width / 2;
    int startY = self.bounds.size.height / 2 + 20;
    
    int newX, newY;
    int newStartX1, newStartX2;
    int newStartY1, newStartY2;
    int newValue, newValue1, newValue2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGaugeBitmap:context];
    if(value >= 0.5){
        newValue = END_ANGLE * 2 * (value - 0.5);
    }
    else{
        newValue = START_ANGLE + (360 - START_ANGLE) * 2 * value;
    }
    
    if(newValue - 90 >= 0){
        newValue1 = newValue - 90;
    }
    else{
        newValue1 = newValue - 90 + 360;
    }
    
    if(newValue + 90 <= 360){
        newValue2 = newValue + 90;
    }
    else{
        newValue2 = newValue + 90 - 360;
    }
    
    newX = (int)(sin(newValue * 3.14 / 180) * GAUGE_WIDTH + startX);
    newStartX1 = (int)(sin(newValue1 * 3.14 / 180) * LINE_WIDTH + startX);
    newStartX2 = (int)(sin(newValue2 * 3.14 / 180) * LINE_WIDTH + startX);
    
    newY = (int)(startY - (cos(newValue * 3.14 / 180) * GAUGE_WIDTH));
    newStartY1 = (int)(startY - (cos(newValue1 * 3.14 / 180) * LINE_WIDTH));
    newStartY2 = (int)(startY - (cos(newValue2 * 3.14 / 180) * LINE_WIDTH));
    
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextMoveToPoint(context, newStartX1, newStartY1);
    CGContextAddLineToPoint(context, newStartX2, newStartY2);
    CGContextAddLineToPoint(context, newX, newY);
    CGContextAddLineToPoint(context, newStartX1, newStartY1);
    CGContextFillPath(context);
}

-(void) drawGaugeBitmap:(CGContextRef)context{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1., -1.0);
    CGContextClipToRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(imgGauge), CGImageGetHeight(imgGauge)), imgGauge);
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
