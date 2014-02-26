//
//  DatabaseManager.m
//  PerfectStore
//
//  Created by matteo petrioli on 19/02/13.
//  Copyright (c) 2013 Vidiemme. All rights reserved.
//

#import "DatabaseManager.h"

static DatabaseManager * _databaseManager;
static sqlite3 * _database;
static NSString * _databasePath;

@implementation DatabaseManager

+ (DatabaseManager *)sharedDatabase
{
    if (_databaseManager == nil) {
        _databaseManager = [[DatabaseManager alloc] init];
    }
    return _databaseManager;
}

- (id)init
{
    if ((self = [super init])) {
        
        BOOL success;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"sw/wsw_db.db"];
        success = [fileManager fileExistsAtPath:writableDBPath];
        
        _databasePath = [[NSString alloc] initWithString:writableDBPath];
        
    }
    return self;
}

+ (NSString *)stringFromStatement:(sqlite3_stmt *)statement columnIndex:(int)columnIndex
{
    char * string = (char*)sqlite3_column_text(statement, columnIndex);
    if (string) {
        NSString * nsstring = [[NSString alloc] initWithUTF8String:string];
        return nsstring;
    }
    else{
        return @"";
    }
}

+(NSArray*)getPhotosForBulkUpload{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM photo_to_send"];
    sqlite3_stmt *statement;
    NSMutableArray *photos = [NSMutableArray array];
    
    if (sqlite3_open([_databasePath UTF8String], &_database) == SQLITE_OK){
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString * id_photo = [self stringFromStatement:statement columnIndex:0];
                NSString * uri      = [self stringFromStatement:statement columnIndex:1];
                Photo *currentPhoto = [[Photo alloc] initWithIdPhoto:id_photo andUri:uri];
                
                [photos addObject:currentPhoto];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(_database);
    }
    else {
        NSLog(@"Error prepare = %s", sqlite3_errmsg(_database));
    }
    
    return photos;
}

+(NSArray*)getPhotosForBulkDownload{
    NSString *query = [NSString stringWithFormat:@"SELECT question_path FROM qualitative_survey_questions UNION SELECT guid FROM pos_logo"];
    sqlite3_stmt *statement;
    NSMutableArray *photos = [NSMutableArray array];
    
    if (sqlite3_open([_databasePath UTF8String], &_database) == SQLITE_OK){
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString * id_photo = [self stringFromStatement:statement columnIndex:0];
                NSString * uri      = @"";
                Photo *currentPhoto = [[Photo alloc] initWithIdPhoto:id_photo andUri:uri];
                
                [photos addObject:currentPhoto];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(_database);
    }
    else {
        NSLog(@"Error prepare = %s", sqlite3_errmsg(_database));
    }
    
    return photos;
}


+(void)deletePhotoWithId:(NSString*)id_photo{
    NSString *query = [NSString stringWithFormat:@"DELETE FROM photo_to_send WHERE id_photo = '%@'",id_photo];
    sqlite3_stmt *statement;
    
    if (sqlite3_open([_databasePath UTF8String], &_database) == SQLITE_OK){
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        else {
            NSLog(@"Error prepare delete photo_to_send Table= %s", sqlite3_errmsg(_database));
        }
        
        sqlite3_close(_database);
    }
}



@end
