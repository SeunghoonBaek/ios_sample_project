//
//  ChatDataModel.h
//  uMessageApp
//
//  Created by 소영섭 on 13. 2. 3..
//  Copyright (c) 2013년 소영섭. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChatDataModel : NSObject
{
    NSString *pTime;
    NSString *pContext;
    UIImage *pUserImage;
    BOOL     LeftYN;

    
}
@property(nonatomic, copy) NSString *pTime;
@property(nonatomic, copy) NSString *pContext;
@property(nonatomic, retain) UIImage *pUserImage;
@property(nonatomic, assign) BOOL LeftYN;

@end
