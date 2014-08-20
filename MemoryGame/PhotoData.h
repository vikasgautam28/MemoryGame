//
//  PhotoData.h
//  MemoryGame
//
//  Created by Vikas on 20/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *photoURL;

-(id) initWithJSON:(NSDictionary *) jsonObject;

@end
