//
//  CharViewController.h
//  uMessageApp
//
//  Created by 소영섭 on 13. 2. 3..
//  Copyright (c) 2013년 소영섭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetWorkController;
@interface CharViewController : UIViewController <UITextViewDelegate>

// 대화내용을 보여주는 테이블의 참조 객체
@property(weak, nonatomic) IBOutlet UITableView *pChatListView;
// 대화 내용 입력 참조 객체
@property(weak, nonatomic) IBOutlet UITextView *pTextView;
// 도움말 참조 객체
@property(weak, nonatomic) IBOutlet UIView     *pBackView;
@property(strong, nonatomic) UIButton   *pButton;
@property(strong, nonatomic) NetWorkController * pNetWorkController;

-(IBAction)sendText;
-(IBAction)CloseClick;

@end
