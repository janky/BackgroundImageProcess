//
//  BulkOperation.h
//  PerfectStore
//
//  Created by Gianluca Pisati on 18/11/13.
//  Copyright (c) 2013 Vidiemme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

#import "Document.h"

@interface BulkDownloadOperation : NSOperation{
    int _kind;
    BOOL _isExecuting;
    BOOL _bulkDownloadOperations;
    BOOL _isFinished;
}

-(id)initWithDocument:(Document*)d;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) CDVPlugin *webview;
@property (nonatomic) int current;
@property (nonatomic) int total;

@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;
@property (readonly) BOOL bulkDownloadOperations;

@property (strong, nonatomic) Document * document;

@end
