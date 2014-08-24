//
//  GameObjectManager.m
//  MemoryGame
//
//  Created by Vikas on 20/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "GameObjectManager.h"
#import <AFNetworking/AFHTTPClient.h>
#import <AFHTTPRequestOperation.h>

#define BASEURL @"https://api.flickr.com"
@implementation GameObjectManager

static GameObjectManager * objectManager=nil; //


+(GameObjectManager*) getManager {
    
    if(objectManager==nil)
    {
        
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            objectManager = [[GameObjectManager alloc] init];
        });
    }
    
    return objectManager;
}


- (void) setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

-(void) getObjectsFromURLPath:(NSString *)URLPath withParams:(NSDictionary*) params {
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    
    NSString * url = [BASEURL stringByAppendingString:URLPath];
    
    NSLog(@"URL : %@",url);
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:url
                                                      parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([delegate respondsToSelector:@selector(didLoadObjectsfromURLPath:fetchedResponseObject:)]) {
            
            [delegate didLoadObjectsfromURLPath:URLPath fetchedResponseObject:responseObject];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if([delegate respondsToSelector:@selector(didFailToLoadObjectsfromURLPath:fetchedResponseObject:)]) {
            
            [delegate didFailToLoadObjectsfromURLPath:URLPath fetchedResponseObject:error];
        }
        
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
    
    
}


@end
