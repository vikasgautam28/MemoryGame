//
//  PhotoData.m
//  MemoryGame
//
//  Created by Vikas on 20/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "PhotoData.h"

@implementation PhotoData

@synthesize title;
@synthesize photoURL;

-(id) initWithJSON:(NSDictionary *)jsonObject {
    
    self = [super init];
    
    if(self) {
        
        title = [jsonObject valueForKey:@"title"];
        photoURL = [jsonObject valueForKeyPath:@"media.m"];
    }
    
    return self;
}

@end
