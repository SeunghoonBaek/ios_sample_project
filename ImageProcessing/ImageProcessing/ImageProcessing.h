//
//  ImageProcessing.h
//  ImageProcessing
//
//  Created by baek on 2017. 7. 28..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageProcessing : NSObject {
    unsigned char* rawImage;
    int imageWidth;
    int imageHeight;
}

-(void) AllocMemoryImage:(int)width Height:(int)height;
-(id) setImage:(UIImage *)image;
-(UIImage *) getImage;
-(UIImage *) BitmapToUIImage;
-(UIImage *) BitmapToUIImage:(unsigned char *)bitmap BitmapSize:(CGSize)size;
-(void) DataInit;
-(id) getGrayImage;
-(id) getInverseImage;
-(id) getTrackingImage;
@end
