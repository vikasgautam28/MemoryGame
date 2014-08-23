//
//  GameObjectManager.h
//  MemoryGame
//
//  Created by Vikas on 20/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameObjectDelegate

@required

-(void) didLoadObjectsfromURLPath:(NSString*) URLPath fetchedResponseObject:(id) responseObject;

-(void) didFailToLoadObjectsfromURLPath:(NSString*)URLPath fetchedResponseObject:(id)error;

@end

@interface GameObjectManager : NSObject {
    
    id delegate;
}

+ (GameObjectManager*) getManager;

- (void) setDelegate:(id)newDelegate;

-(void) getObjectsFromURLPath:(NSString *)URLPath withParams:(NSDictionary*) params;



@end

