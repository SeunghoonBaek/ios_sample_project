//
//  MemberListViewController.h
//  uMessageApp
//
//  Created by 소영섭 on 13. 2. 3..
//  Copyright (c) 2013년 소영섭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CharViewController;
@class NetWorkController;
@interface MemberListViewController : UIViewController
{
//    IBOutlet UITableView *pListView;
    CharViewController *pCharViewController;
    NetWorkController  *pNetWorkController;
    
}


- (void)ChatViewShow;
- (void)ServerConnect:(NSString *)pUserID  PassWord:(NSString *)pPass;

@property(weak, nonatomic) IBOutlet UITableView *pListView;
@property(strong, nonatomic) NetWorkController * pNetWorkController;
@property(strong, nonatomic) CharViewController * pCharViewController;

@end
