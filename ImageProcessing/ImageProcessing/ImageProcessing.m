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
    
    CGContextRef context = CGBitmapContextCreate(
                                                 rawImage,
                                                 imageWidth,
                                                 imageHeight,
                                                 8,
                                                 imageWidth * sizeof(uint32_t),
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast)
    ;
    
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

-(UIImage *) BitmapToUIImage{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(
                                                 rawImage,
                                                 imageWidth,
                                                 imageHeight,
                                                 8,
                                                 imageWidth * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRef ref = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    UIImage* img = [UIImage imageWithCGImage:ref];
    CFRelease(ref);
    return img;
}

#pragma mark -
#pragma mark ImageProcessing
-(id)getGrayImage{
    for(int y = 0 ; y < imageHeight ; y++){
        for(int x = 0 ; x < imageWidth ; x++){
            uint8_t* pRawImage = (uint8_t *) &rawImage[(y * imageWidth + x) * 4];
            uint32_t gray = 0.299 * pRawImage[RED] + 0.587 * pRawImage[GREEN] + 0.114 * pRawImage[BLUE];
            
            pRawImage[RED] = (unsigned char) gray;
            pRawImage[GREEN] = (unsigned char) gray;
            pRawImage[BLUE] = (unsigned char) gray;
        }
    }
    
    return self;
}

-(id) getInverseImage{
    for(int y = 0 ; y < imageHeight ; y++){
        for(int x = 0 ; x < imageWidth ; x++){
            uint8_t* pRawImage = (uint8_t *) &rawImage[(y * imageWidth + x) * 4];
            
            pRawImage[RED] = 255 - pRawImage[RED];
            pRawImage[GREEN] = 255 - pRawImage[GREEN];
            pRawImage[BLUE] = 255 - pRawImage[BLUE];
        }
    }
    
    return self;
}

int getOffset(int x, int y, int width, int index){
    return y * width * 4 + x * 4 + index;
}

-(id) getTrackingImage{
    [self getGrayImage];
    
    // Sobal mask X, y
    int matrixX[9] = {
        -1, 0, 1,
        -2, 0, 2,
        -1, 0, 1
    };
    
    int matrixY[9] = {
        -1, -2, -1,
        0, 0, 0,
        1, 2, 1
    };
    
    for(int y = 0 ; y < imageHeight ; y++){
        for(int x  = 0 ; x < imageWidth ; x++){
            int sumr1 = 0;
            int sumr2 = 0;
            int sumg1 = 0;
            int sumg2 = 0;
            int sumb1 = 0;
            int sumb2 = 0;
            
            int offset = 0;
            for( int j = 0; j <= 2 ; j++){
                for( int i = 0 ; i <= 2 ; i++){
                    sumr1 += *(rawImage + getOffset(x+i, y+j, imageWidth, RED)) * matrixX[offset];
                    sumr2 += *(rawImage + getOffset(x+i, y+j, imageWidth, RED)) * matrixY[offset];
                    sumg1 += *(rawImage + getOffset(x+i, y+j, imageWidth, GREEN)) * matrixX[offset];
                    sumg2 += *(rawImage + getOffset(x+i, y+j, imageWidth, GREEN)) * matrixY[offset];
                    sumb1 += *(rawImage + getOffset(x+i, y+j, imageWidth, BLUE)) * matrixX[offset];
                    sumb2 += *(rawImage + getOffset(x+i, y+j, imageWidth, BLUE)) * matrixY[offset];
                }
                
                offset++;
            }
            
            int sumR = MIN(((ABS(sumr1) + ABS(sumr2)) / 2), 255);
            int sumG = MIN(((ABS(sumg1) + ABS(sumg2)) / 2), 255);
            int sumB = MIN(((ABS(sumb1) + ABS(sumb2)) / 2), 255);
            
            uint8_t* pRawImage = (uint8_t *) &rawImage[(y * imageWidth + x) * 4];
            pRawImage[RED] = (unsigned char) sumR;
            pRawImage[GREEN] = (unsigned char) sumG;
            pRawImage[BLUE] = (unsigned char) sumB;
        }
    }
    
    return self;
}

-(void) DataInit{
    if(rawImage){
        free(rawImage);
        rawImage = nil;
    }
}

@end
