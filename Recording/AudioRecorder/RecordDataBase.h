//
//  CardDataBase.h
//  SecretApp
//
//  Created by young soeb on 10. 12. 13..
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "sqlite3.h"


@interface RecordDataBase : NSObject

// 녹음파일 정보 검색
- (void) getRecordList;
- (void) pDataBaseConnection:(sqlite3 **)tempDataBase;        // 데이터베이스 연결

- (void) insertRecordData:(NSString *)pSEQ RecordingTM:(NSInteger)pRecordingTM  RecordFileNM:(NSString *)pRecordFileNM;
- (void) deleteRecordData:(NSString *)pSEQ;

@property (strong, nonatomic) NSMutableArray  *memoListArray;


@end
