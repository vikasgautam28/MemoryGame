//
//  GameOverView.m
//  MemoryGame
//
//  Created by Vikas on 22/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "GameOverView.h"

@implementation GameOverView

@synthesize gameOverLabel;
@synthesize replayButton;
@synthesize scoreLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor whiteColor]];
        gameOverLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,70, 320, 50)];
        [gameOverLabel setFont:[UIFont fontWithName:@"helvetica" size:40]];
        [gameOverLabel setText:@"Game Over"];
        [gameOverLabel setTextColor:[UIColor redColor]];
        [gameOverLabel sizeToFit];
        
        
        scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,150, 250, 50)];
        [scoreLabel setFont:[UIFont fontWithName:@"helvetica" size:40]];
        [scoreLabel setText:@"Value"];
        [scoreLabel setTextColor:THEME_COLOR];
        
        
        replayButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 200, 70)];
        [replayButton setBackgroundColor:THEME_COLOR];
        replayButton.titleLabel.font = [UIFont fontWithName:@"helvetica-bold" size:30];
        [replayButton setTitle:@"Play Again" forState:UIControlStateNormal];
        [replayButton.layer setCornerRadius:5.f];
        
        [self addSubview:gameOverLabel];
        [self addSubview:scoreLabel];
        [self addSubview:replayButton];
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
