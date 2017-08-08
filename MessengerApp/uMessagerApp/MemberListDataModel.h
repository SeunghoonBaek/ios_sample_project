//
//  MemberLisDataModel.h
//  uMessageApp
//
//  Created by 소영섭 on 13. 2. 3..
//  Copyright (c) 2013년 소영섭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberLisDataModel : NSObject
{
    NSString *pUserName;
    NSString *pContext;
    NSString *pUserID;
    UIImage *pUserImage;
    
}
@property(nonatomic, copy) NSString *pUserName;
@property(nonatomic, copy) NSString *pContext;
@property(nonatomic, retain) NSString *pUserID;
@property(nonatomic, retain) UIImage *pUserImage;

@end
