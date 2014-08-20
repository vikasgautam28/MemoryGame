//
//  DraggableImageView.m
//  MemoryGame
//
//  Created by Vikas Gautam on 21/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "DraggableImageView.h"

@implementation DraggableImageView

@synthesize imageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self.layer setCornerRadius:5.f];
        [self setBackgroundColor:[UIColor grayColor]];
//        imageView = [[UIImageView alloc] initWithFrame:frame];
//        [imageView.layer setCornerRadius:5.f];
        
        [self setImage:[UIImage imageNamed:@"download.jpeg"] forState:UIControlStateNormal];
        
        //[self addSubview:imageView];

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
