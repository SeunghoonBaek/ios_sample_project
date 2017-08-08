//
//  NetWorkController.h
//  uMessageApp
//
//  Created by 소영섭 on 13. 2. 12..
//  Copyright (c) 2013년 소영섭. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "CharDataBase.h"


@class MemberListViewController;
@class CharViewController;

@interface NetWorkController : UIViewController
{
    
    NSString *pMyUserID;
    NSString *pMyPassword;
    
    NSMutableArray *pMemeberListdata;     // 전체 회원정보 리스트
    NSMutableArray *pChatData;            // 송수신된 메시지 정보
  //  ChatDataBase *pDataBase;            // 데이터베이스 제어 클래스
    NetWorkController *pNetWorkController;
    MemberListViewController *pMemberListViewController;
    CharViewController  *pCharViewController;
    
    CFSocketRef pSocket;
    CFRunLoopSourceRef pRunSource;
    
    NSMutableData *pReturnData;     // 수신된 데이터
    int pStatus;      // 현재 상태변수
    long pChatTargetIndex;
}

@property(nonatomic, strong) UITableView *pListView;

@property(nonatomic, retain) NSMutableArray * pMemeberListdata;
@property(nonatomic, retain) NSMutableArray * pChatData;
@property(nonatomic, retain) NetWorkController * pNetWorkController;
@property(nonatomic, retain)  NSMutableData *pReturnData;
@property(nonatomic, retain)  MemberListViewController *pMemberListViewController;
@property(nonatomic, retain)  CharViewController  *pCharViewController;
@property(nonatomic, retain)  NSString *pMyUserID;
@property(nonatomic, retain)  NSString *pMyPassword;


@property(nonatomic, assign) int pStatus;


-(void)setMyUserInformation:(NSString *)strUserID PassWord:(NSString *) strPassWord;
-(void)getServerConnect;
-(void)SendChatTextCommand;
-(void)SendCloseChatTextCommand;    // 프로젝트 파일에만 추가된 기능
-(void)SendReqvCommand:(long)index;

@end
