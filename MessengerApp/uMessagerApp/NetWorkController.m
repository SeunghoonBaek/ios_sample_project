//
//  NetWorkController.m
//  uMessageApp
//
//  Created by 소영섭 on 13. 2. 12..
//  Copyright (c) 2013년 소영섭. All rights reserved.
//

#import "NetWorkController.h"
#import "MemberListDataModel.h"
#import "ChatDataModel.h"
#import "MemberListViewController.h"

#import "CharViewController.h"
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netdb.h>
#import <arpa/inet.h>


#define CLOSED       0
#define CONN         1
#define LOG          2
#define LIST         3
#define WAIT         4
#define REQV         5
#define REPL         6
#define CHAT         7
#define TEXT         8

@implementation NetWorkController

@synthesize pListView, pMemeberListdata, pChatData, pNetWorkController, pStatus, pReturnData;
@synthesize pMemberListViewController, pCharViewController, pMyUserID, pMyPassword;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pStatus = CLOSED;
 //       pDataBase = [[ChatDataBase alloc] init];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
//    [pDataBase release];
    
    [super viewDidUnload];
}


-(void) setMyUserInformation:(NSString *)strUserID PassWord:(NSString *) strPassWord
{
    pMyUserID = strUserID;
    pMyPassword = strPassWord;
    
}


-(void) getServerConnect
{
    
    CFSocketContext socketContext = {0, (__bridge void*) self, NULL, NULL, NULL};
    
    pSocket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, 0,
                             kCFSocketReadCallBack|kCFSocketDataCallBack|kCFSocketConnectCallBack|kCFSocketWriteCallBack,
                             (CFSocketCallBack)SocketCallBack, &socketContext);
    
    
    struct sockaddr_in sockAddr;
    
    sockAddr.sin_port = htons(9500);     // 9500포트 설정
    sockAddr.sin_family = AF_INET;
    sockAddr.sin_addr.s_addr =inet_addr("192.168.0.14");    // 접속할 서버 IP 설정
    
    CFDataRef addressData = CFDataCreate( NULL, (void *)&sockAddr, sizeof( struct sockaddr_in ) );
    CFSocketConnectToAddress(pSocket, addressData, 30);  // 서버에 접속 대기시간(30초 타임아웃)
    
    pRunSource = CFSocketCreateRunLoopSource(NULL, pSocket , 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), pRunSource, kCFRunLoopCommonModes);
    
    CFRelease(addressData);
    
}

void SocketCallBack (CFSocketRef s, CFSocketCallBackType callbackType,  CFDataRef address,  const void *data, void *info )
{
    
    NetWorkController *pNetWorkController = (__bridge NetWorkController *) info;
    
    // 데이터 수신시
    if(callbackType == kCFSocketDataCallBack) {
        if (pNetWorkController.pReturnData == nil ) {
            pNetWorkController.pReturnData = [[NSMutableData alloc] init];
        }
        
        // 수신된 데이터를 가져옵니다.
        const UInt8 * buf = CFDataGetBytePtr((CFDataRef)data);
        long len = CFDataGetLength((CFDataRef) data);
        
        if(len) [pNetWorkController.pReturnData appendBytes:(const void *)buf length:len];
        // NSStrng 객체로 변환
        NSString *receveStr = [[NSString alloc] initWithData:pNetWorkController.pReturnData encoding:NSUTF8StringEncoding];
        
    //    NSLog(@"%s",receveStr);
        if([receveStr rangeOfString:@"\r\n"].location != NSNotFound)
        {
            
            switch(pNetWorkController.pStatus)
            {
                case CLOSED:
                    
                    break;
                case CONN:       // 로그인 요청시 호출
                {
                    pNetWorkController.pStatus = LOG;
                    [pNetWorkController SendLoginCommand];
                    break;
                }
                case LOG:        // 로그인 요청 후 결과 처리
                {
                    int returnCode =  [[receveStr substringWithRange:NSMakeRange(0,3)] intValue];
                    
                    if(returnCode == 200){        // 로그인 성공
                        pNetWorkController.pStatus = LIST;
                        [pNetWorkController SendListCommand];     // 회원정보 리스트 요청
                    }else pNetWorkController.pStatus = CONN;

                    
                    break;
                }
                    
                case LIST:      // 리스트 요청 후 결과 처리
                {
                    [pNetWorkController setMemberList:receveStr];
                    [pNetWorkController.pMemberListViewController.pListView reloadData];
                    
                    pNetWorkController.pStatus = WAIT;
                    break;
                }
                    
                case REQV:      //  채팅 요청후 결과 처리
                {
                    int returnCode =  [[receveStr substringWithRange:NSMakeRange(0,3)] intValue];
                    if(returnCode == 400)
                         [pNetWorkController startChart];     // 대화 요청승인시 대화화면으로 전환
                    else  pNetWorkController.pStatus = WAIT;
                    
                    break;
                }
                case WAIT:     // 로그인 후 대기상태
                {
                    // 댜화 요청을 받았을 경우 승인 및 대화화면으로 전환
                    [pNetWorkController ReceiveReqvCommand:receveStr];
                    break;
                }
                    
                case CHAT:     // 채팅중 메시지가 수신될 경우
                {
                    [pNetWorkController ReceiveChatText:receveStr];
                    break;
                }
                case TEXT:    // 서버로 부터 메시지를 받을 준비가 되었음을 수신
                {
                    
                    [pNetWorkController SendChatText];   // 메시지 전송
                    break;
                    
                }
                    
                default:
                    
                    break;
                    
                    
            }
        //    [pNetWorkController.pReturnData release];
            pNetWorkController.pReturnData = nil;
       //     [receveStr release];
            
        }
        
    }
    
    if(callbackType == kCFSocketConnectCallBack) {
        NSLog(@"connected");
        pNetWorkController.pStatus = CONN;
        
    }
    
}


// CONN 명령어 호출(로그인 요청)
-(void)SendLoginCommand
{
    NSString *pstr = [NSString stringWithFormat:@"CONN %@ %@\r\n", pMyUserID, pMyPassword];
   [self SendDataString:pstr];
}

//  List 명령어 호출(회원정보 리스트 요청)
-(void)SendListCommand
{

    [self SendDataString:@"LIST\r\n"];

}


// TEXT 명령어 호출(대화 메시지 송신 가능 여부 확인)
-(void)SendChatTextCommand
{
 
    
    pStatus = TEXT;
    [self SendDataString:@"TEXT\r\n"];    
}



// TEXT 명령어 호출(프로젝트 파일에만 추가된 기능 )
-(void)SendCloseChatTextCommand
{
    
    pStatus = CONN;
    [self SendDataString:@"/CHAT\r\n"];
}



// 메시지 전송
-(void)SendChatText
{
    
    pStatus = CHAT;
    NSString *pstr = [NSString stringWithFormat:@"%@\r\n", pCharViewController.pTextView.text];
    [self SendDataString:pstr];
    // 송신한 대화내용 화면 갱신 및 저장
    [self addChatMessage:pstr DisTime:[self getTime] forDirection:true ReLoadData:true ];

}

// 메시지 수신
-(void)ReceiveChatText:(NSString *) strMessage
{
    // 수신한 내용 화면 갱신 및 저장
    [self addChatMessage:strMessage DisTime:[self getTime] forDirection:false ReLoadData:true ];

}

// REQV 명령어 호출(일대일 대화요청)
-(void)SendReqvCommand:(long)index
{
    MemberLisDataModel *rowData =[pMemeberListdata objectAtIndex:index];
   
    pStatus = REQV;
    NSString *pstr = [NSString stringWithFormat:@"REQV %@\r\n",  rowData.pUserID];
    
    
    pChatTargetIndex = index;
    [self SendDataString:pstr];
    
}

//REQV 요청에 대한 응답 처리
-(void)ReceiveReqvCommand:(NSString *)strMessage
{
    
    NSArray *messageArr = [strMessage componentsSeparatedByString:@" "];
    NSString *tId = [[messageArr objectAtIndex:1] substringToIndex:[[messageArr objectAtIndex:1] rangeOfString:@"\r\n"].location];
  
    
    pChatTargetIndex = [self searchUserID:tId];  //화원검색
    
    if(pChatTargetIndex == -1)
    {
        NSString *pstr = [NSString stringWithFormat:@"REPL %@ N\r\n", tId];
        [self SendDataString:pstr];

    }
    else{    // 요청자가 회원일 경우 자동으로 채팅화면으로 전환
        
        NSString *pstr = [NSString stringWithFormat:@"REPL %@ Y\r\n", tId];
        [self SendDataString:pstr];
        
        [self startChart];
    }
    
}


// 일대일 채팅화면으로 전환
-(void)startChart
{
    pStatus = CHAT;
//    [pDataBase getRecordList:pMyUserID];
    [self.pMemberListViewController ChatViewShow];

}



// 문자열 전송
-(void) SendDataString:(NSString *)strMessage
{
    if ( self.pStatus == CLOSED ) {
        return;
    }
    

    // Send Data
    NSString *msg = [NSString stringWithFormat:@"%@", strMessage];
    
    NSData *msg_data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    CFSocketSendData(pSocket, NULL, ( CFDataRef) msg_data, 30); //strlen(msg_data));
    
}



-(void) setMemberList:(NSString *)strMessage
{
    
    NSArray *memberArr = [strMessage componentsSeparatedByString:@"#"];
    
    
    for(int i =0; i < [memberArr count]; i++)
    {
        NSString *memberInfo = [memberArr objectAtIndex:i];
        
        [self setMemberInfomation:[memberInfo componentsSeparatedByString:@"$"]];
        
        
    }

}


-(void) setMemberInfomation:(NSArray *)memberInfo
{
    
    if (pMemeberListdata == nil)
        pMemeberListdata = [[NSMutableArray alloc] init];
    
    MemberLisDataModel *chatData = [[MemberLisDataModel alloc]init];
    
    chatData.pUserID = [memberInfo objectAtIndex:0];      // 회원 아이디
    chatData.pUserName = [memberInfo objectAtIndex:1];    // 회원 이름
    
    chatData.pContext = @"안녕하세요";
    
    [pMemeberListdata addObject:chatData];
    
}


// 회원을 검색합니다.
- (int)searchUserID:(NSString *) str
{
    
    for(int i=0; i < [pMemeberListdata count]; i++)
    {

        MemberLisDataModel *chatData = [pMemeberListdata objectAtIndex:i];
        
        if([chatData.pUserID isEqualToString:str]) return i;
        
    }
    return -1;
}


// 송수신된 대화내용을 추가합니다.
-(void)addChatMessage:(NSString *)strMessage DisTime:(NSString *) time forDirection:(bool)derection ReLoadData:(bool)forRefresh
{
    if(pChatData== nil)
        pChatData = [[NSMutableArray alloc] init];
    
    
    ChatDataModel *chatData = [[ChatDataModel alloc]init];
    
    chatData.pTime = time;
    chatData.pContext = strMessage;
    
    chatData.LeftYN = derection;
    

   // [pDataBase insertRecordData:pMyUserID];
    
    [pChatData addObject:chatData];
    
    if(forRefresh == true) [pCharViewController.pChatListView reloadData];
}


-(NSString *)getTime
{
    
    NSCalendar *pCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour| NSCalendarUnitMinute |NSCalendarUnitSecond;
    
    NSDate *date = [NSDate date];
	NSDateComponents *comps = [pCalendar components:unitFlags fromDate:date];
    int pyear = (int)[comps year];
    int pmonth = (int)[comps month];
    int pday = (int)[comps day];
    
    
	int phour = (int)[comps hour];
	int pminute = (int)[comps minute];
	int psecond = (int)[comps second];
	return[NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",pyear, pmonth, pday, phour, pminute, psecond];
    
    
}



@end
