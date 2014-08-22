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
@synthesize loader;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        loader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(35,40, 10, 10)];
        loader.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        [loader startAnimating];
        photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [photoView.layer setCornerRadius:5.f];
        [self.layer setCornerRadius:5.f];
        self.backgroundColor=THEME_COLOR;
        [self addSubview:photoView];
        [self addSubview:loader];
    
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
