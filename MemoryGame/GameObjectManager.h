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

-(void) didLoadObjectsForClass:(Class) klass fromURLPath:(NSString*) URLPath fetchedResponseObject:(id) responseObject;

@end

@interface GameObjectManager : NSObject {
    
    id delegate;
}

+ (GameObjectManager*) getManager;

- (void) setDelegate:(id)newDelegate;

-(void) getObjectForClass:(Class) Klass fromURLPath:(NSString *) URLPath withParams:(NSDictionary*) params;



@end

