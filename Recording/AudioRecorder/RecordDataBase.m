//
//  CardDataBase.m
//  SecretApp
//
//  Created by young soeb on 10. 12. 13..
//  Copyright 2010 home. All rights reserved.
//

#import "RecordDataBase.h"


@implementation RecordDataBase

@synthesize memoListArray;

#pragma mark 데이터베이스 관련 함수

- (NSMutableArray *) memoListArray
{
	
	if (memoListArray == nil) {
		memoListArray = [[NSMutableArray alloc] init];
        [self getRecordList];
	}
	return memoListArray;
	
}



- (void) deleteRecordData:(NSString *)pSEQ
{
	sqlite3_stmt *statement = nil;
	sqlite3 *pDataBase;
	
	
	[self pDataBaseConnection:&pDataBase];     // 데이터베이스 연결합니다.
	if (pDataBase == nil) {
		NSLog(@"Erro Message : '%s'", sqlite3_errmsg(pDataBase)); 
		return;
	}
	
	const char *sql = "DELETE FROM RecordTB WHERE SEQ = ?";
	
    // SQL Text를 prepared statement로 변환합니다.
	if(sqlite3_prepare_v2(pDataBase, sql, -1, &statement, NULL) != SQLITE_OK)
	{
		
		NSLog(@"Erro Message : '%s'", sqlite3_errmsg(pDataBase)); 
		sqlite3_close(pDataBase);   //데이터베이스를 닫는다
		pDataBase = nil;
		return;
		
		
	}
    // 조건을 바인딩합니다.
	sqlite3_bind_text(statement, 1, [pSEQ UTF8String], -1, SQLITE_TRANSIENT);
	
	
	//쿼리를 실행한다.
	if(sqlite3_step(statement) != SQLITE_DONE) {
		
		NSLog(@"Erro Message : '%s'", sqlite3_errmsg(pDataBase)); 
		
	}
	
	sqlite3_reset(statement);   //객체 초기화
	sqlite3_finalize(statement);  //객체를 닫는다
	sqlite3_close(pDataBase);   //데이터베이스를 닫는다
	pDataBase = nil;
	
}




- (void) insertRecordData:(NSString *)pSEQ RecordingTM:(NSInteger)pRecordingTM  RecordFileNM:(NSString *)pRecordFileNM 
{
	sqlite3_stmt *statement = nil;
	sqlite3 *pDataBase;
	
	[self pDataBaseConnection:&pDataBase];     // 데이터베이스 연결합니다.
	if (pDataBase == nil) {
		NSLog(@"Erro Message : '%s'", sqlite3_errmsg(pDataBase)); 
		return;
	}
	
	const char *sql = "INSERT INTO RecordTB(SEQ, RecordingTM, RecordFileNM) VALUES(?, ?, ?)";
	
    // SQL Text를 prepared statement로 변환합니다.
	if(sqlite3_prepare_v2(pDataBase, sql, -1, &statement, NULL) != SQLITE_OK)
	{
		
		NSLog(@"Erro Message : '%s'", sqlite3_errmsg(pDataBase)); 
		sqlite3_close(pDataBase);   //데이터베이스를 닫는다
		pDataBase = nil;
		return;
		
		
	}
	
    // 조건을 바인딩합니다.
	sqlite3_bind_text(statement, 1, [pSEQ UTF8String], -1, SQLITE_TRANSIENT);     //파일 ID
	sqlite3_bind_int(statement, 2, pRecordingTM);      // 녹음시간
	sqlite3_bind_text(statement, 3, [pRecordFileNM UTF8String], -1, SQLITE_TRANSIENT);  // 파일명
	

	//쿼리를 실행한다.
	if(sqlite3_step(statement) != SQLITE_DONE) 
		NSLog(@"Erro Message : '%s'", sqlite3_errmsg(pDataBase)); 
	
	sqlite3_reset(statement);   //객체 초기화
	sqlite3_finalize(statement);  //객체를 닫는다
	sqlite3_close(pDataBase);   //데이터베이스를 닫는다
	pDataBase = nil;
	
}



- (void) getRecordList
{
	NSString *pSEQ;      // 녹음 파일  ID
	NSNumber *pRecordingTM;     // 녹음시간
	NSString *pRecordFileNM;    // 파일명
	
	
	sqlite3_stmt *statement = nil;
	sqlite3 *pDataBase;
	
	[self pDataBaseConnection:&pDataBase];    // 데이터베이스 연결
	if (pDataBase == nil) {
		NSLog(@"Erro Message : '%s'", sqlite3_errmsg(pDataBase)); 
		return;
	}
	
    // 검색 SQL
	const char *sql = "SELECT SEQ, RecordingTM, RecordFileNM FROM RecordTB ORDER BY SEQ";
	
    // SQL Text를 prepared statement로 변환합니다.
	if(sqlite3_prepare_v2(pDataBase, sql, -1, &statement, NULL) != SQLITE_OK)
	{
		
		NSLog(@"Erro Message : '%s'", sqlite3_errmsg(pDataBase)); 
		sqlite3_close(pDataBase);   //데이터베이스를 닫는다
		pDataBase = nil;
		return;
		
	}
	

	if (memoListArray == nil)		
        memoListArray = [[NSMutableArray alloc] init];
	
    //객체에 등록
	if (memoListArray != nil)
	{
		[memoListArray removeAllObjects];
		
		//쿼리를 실행한다.
		while(sqlite3_step(statement) == SQLITE_ROW) {
			pSEQ =  [[NSString alloc] initWithString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            // 녹음시간
		    pRecordingTM   = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
            //녹음파일명
			pRecordFileNM = [[NSString alloc] initWithString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
				
			
			[memoListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:pSEQ, @"SEQ",  
									  pRecordingTM, @"RecordingTM", 
									  pRecordFileNM, @"RecordFileNM",  nil]];
            
            
            NSLog(@"%@  %d  %@", pSEQ, [pRecordingTM intValue] , pRecordFileNM);
            
		}	
	}
	
	sqlite3_reset(statement);   //객체 초기화
	sqlite3_finalize(statement);  //객체를 닫는다
	sqlite3_close(pDataBase);   //데이터베이스를 닫는다
	pDataBase = nil;
	
}



- (void)pDataBaseConnection:(sqlite3 **)tempDataBase
{
    // Document 폴더 위치를 구합니다.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
    // 데이터베이스 파일경로를 구합니다.
	NSString *myPath = [documentDirectory stringByAppendingPathComponent:@"RecordDB.sqlite"];
	
    //데이터 베이스 연결
	if (sqlite3_open([myPath UTF8String], tempDataBase) != SQLITE_OK) {
		*tempDataBase = nil;
		return;
	}
	
}



@end
