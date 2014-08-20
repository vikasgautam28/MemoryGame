//
//  photoCollectionCell.m
//  MemoryGame
//
//  Created by Vikas on 20/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "photoCollectionCell.h"

@implementation photoCollectionCell

@synthesize photoView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        photoView = [[UIImageView alloc] initWithFrame:frame];
        [self.layer setCornerRadius:5.f];
        self.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:photoView];
    
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
