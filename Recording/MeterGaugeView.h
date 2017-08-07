//
//  MeterGaugeView.h
//  Recording
//
//  Created by baek on 2017. 8. 7..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeterGaugeView : UIView {
    CGImageRef imgGauge;
    double value;
}

-(void) drawGaugeBitmap:(CGContextRef) context;
@property double value;
@end
