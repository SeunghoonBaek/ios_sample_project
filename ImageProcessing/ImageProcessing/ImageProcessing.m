//
//  ImageProcessing.m
//  ImageProcessing
//
//  Created by baek on 2017. 7. 28..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "ImageProcessing.h"

typedef enum{
    ALPHA = 0,
    BLUE,
    GREEN,
    RED
}PIXELS;

@implementation ImageProcessing

-(void) AllocMemoryImage:(int)width Height:(int)height{
    imageWidth = width;
    imageHeight = height;
    
    int size = imageWidth * imageHeight * 4 * sizeof(char *);
    rawImage = (uint8_t *) malloc(size);
    memset(rawImage, 0, size);
}

-(id) setImage:(UIImage *)image{
    [self DataInit];
    
    if(image == nil){
        return nil;
    }
    
    CGSize size = image.size;
    [self AllocMemoryImage:size.width Height:size.height];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rawImage, imageWidth, imageHeight, 8, imageWidth * imageHeight * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return self;
}

-(UIImage *) getImage{
    return [self BitmapToUIImage];
}

-(UIImage *) BitmapToUIImage:(unsigned char *)bitmap BitmapSize:(CGSize)size{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(bitmap, size.width, size.height, 8, size.width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    
    CGImageRef ref = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    UIImage* img = [UIImage imageWithCGImage:ref];
    CFRelease(ref);
    return img;
}



@end
