//
//  RecordDataBase.m
//  Recording
//
//  Created by baek on 2017. 8. 8..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "RecordDataBase.h"

@implementation RecordDataBase
@synthesize memoListArray;
-(void) DataBaseConnection:(sqlite3 **)tempDataBase{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* myPaths = [documentDirectory stringByAppendingPathComponent:@"RecordDB.sqlite"];
    
    if(sqlite3_open([myPaths UTF8String], tempDataBase) != SQLITE_OK){
        *tempDataBase = nil;
        return;
    }
}

-(void) getRecordList{
    NSString* pSEQ;
    NSNumber* pRecordingTM;
    NSString* pRecordFileNM;
    sqlite3* pDataBase;
    sqlite3_stmt* statement = nil;
    
    [self DataBaseConnection:&pDataBase];
    if(pDataBase == nil){
        NSLog(@"Error Message : '%s'", sqlite3_errmsg(pDataBase));
        return;
    }
    
    const char* sql = "SELECT SEQ, RecordingTM, RecordFileNM FROM RecordTB ORDER BY SEQ";
    
    if(sqlite3_prepare_v2(pDataBase, sql, -1, &statement, NULL) != SQLITE_OK){
        NSLog(@"Error Message : '%s'", sqlite3_errmsg(pDataBase));
        sqlite3_close(pDataBase);
        pDataBase = nil;
        return;
    }
    
    if(memoListArray == nil){
        memoListArray = [[NSMutableArray alloc] init];
    }
    
    if(memoListArray != nil){
        [memoListArray removeAllObjects];
        
        while(sqlite3_step(statement) == SQLITE_ROW){
            pSEQ = [[NSString alloc] initWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)]];
            
            pRecordingTM = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
            
            pRecordFileNM = [[NSString alloc] initWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)]];
            
            [memoListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:pSEQ, @"SEQ", pRecordingTM, @"RecordingTM", pRecordFileNM, @"RecordFileNM", nil]];
        }
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(pDataBase);
    
    pDataBase = nil;
}

-(void) insertRecordData:(NSString *)pSEQ RecordingTM:(NSInteger)pRecordingTM RecordFileNM:(NSString *) pRecordFileNM{

    sqlite3_stmt* statement = nil;
    sqlite3* pDataBase;
    [self DataBaseConnection:&pDataBase];
    
    if(pDataBase == nil){
        NSLog(@"Error Message : '%s'", sqlite3_errmsg(pDataBase));
        return;
    }
    
    const char* sql = "INSERT INTO RecordTB(SEQ, RecordingTM, RecordFileNM) VALUES(?,?,?)";
    
    if(sqlite3_prepare_v2(pDataBase, sql, -1, &statement, NULL) != SQLITE_OK){
        NSLog(@"Error Message : '%s'", sqlite3_errmsg(pDataBase));
        sqlite3_close(pDataBase);
        pDataBase = nil;
        return;
    }
    
    sqlite3_bind_text(statement, 1, [pSEQ UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 2, (int)pRecordingTM);
    sqlite3_bind_text(statement, 3, [pRecordFileNM UTF8String], -1, SQLITE_TRANSIENT);
    
    if(sqlite3_step(statement) != SQLITE_DONE){
        NSLog(@"Error Message : '%s'", sqlite3_errmsg(pDataBase));
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(pDataBase);
    
    pDataBase = nil;
}

-(void) deleteRecordData:(NSString *)pSEQ{
    sqlite3_stmt* statement = nil;
    sqlite3* pDataBase;
    [self DataBaseConnection:&pDataBase];
    
    if(pDataBase == nil){
        NSLog(@"Error Message : '%s'", sqlite3_errmsg(pDataBase));
        return;
    }
    
    const char* sql = "DELETE FROM RecordTV WHERE SEQ=?";
    if(sqlite3_prepare_v2(pDataBase, sql, -1, &statement, NULL) != SQLITE_OK){
        NSLog(@"Error Message : '%s'", sqlite3_errmsg(pDataBase));
        sqlite3_close(pDataBase);
        pDataBase = nil;
        return;
    }
    
    sqlite3_bind_text(statement, 1, [pSEQ UTF8String], -1, SQLITE_TRANSIENT);
    
    if(sqlite3_step(statement) != SQLITE_DONE){
        NSLog(@"Error Message : '%s'", sqlite3_errmsg(pDataBase));
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(pDataBase);
    
    pDataBase = nil;
}

-(NSMutableArray *) memoListArray{
    if(memoListArray == nil){
        memoListArray = [[NSMutableArray alloc] init];
        [self getRecordList];
    }
    
    return memoListArray;
}

@end
