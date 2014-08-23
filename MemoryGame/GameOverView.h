//
//  GameOverView.h
//  MemoryGame
//
//  Created by Vikas on 22/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameOverView : UIView

@property (nonatomic, strong) UILabel *gameOverLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIButton *replayButton;

@property (nonatomic, strong) UILabel *highScoreLabel;


@end
