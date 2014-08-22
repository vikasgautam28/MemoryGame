//
//  GameStartView.m
//  MemoryGame
//
//  Created by Vikas on 22/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "GameStartView.h"

@implementation GameStartView

@synthesize gameNameLabel;
@synthesize gameIconView;
@synthesize playButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        gameNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,70, 320, 50)];
        [gameNameLabel setFont:[UIFont fontWithName:@"helvetica" size:45]];
        [gameNameLabel setText:@"Memory Game"];
        [gameNameLabel setTextColor:THEME_COLOR];
        [gameNameLabel sizeToFit];
        
        gameIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Game_icon.png"]];
        gameIconView.frame = CGRectMake(80, 150, 150, 150);
        
        playButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 350, 150, 70)];
        [playButton setBackgroundColor:THEME_COLOR];
        playButton.titleLabel.font = [UIFont fontWithName:@"helvetica-bold" size:30];
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
        [playButton.layer setCornerRadius:5.f];
        
        [self addSubview:gameNameLabel];
        [self addSubview:gameIconView];
        [self addSubview:playButton];
        
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
