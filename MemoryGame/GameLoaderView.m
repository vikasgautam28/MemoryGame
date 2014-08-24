//
//  LoadingView.m
//  MemoryGame
//
//  Created by Vikas on 21/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "GameLoaderView.h"

@implementation GameLoaderView

@synthesize reloadButton;
@synthesize activityIndicator;
@synthesize ErrorLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        CGRect itemFrame = CGRectMake(0, 0, 150, 70);
        CGPoint center = CGPointMake((SCREEN_WIDTH/2), (SCREEN_HEIGHT/2));
        reloadButton = [[UIButton alloc] initWithFrame:itemFrame];
        [reloadButton setBackgroundColor:THEME_COLOR];
        reloadButton.titleLabel.font = [UIFont fontWithName:@"helvetica-bold" size:20];
        [reloadButton setCenter:center ];
        [reloadButton setTitle:@"Reload" forState:UIControlStateNormal];
        [reloadButton.layer setCornerRadius:5.f];
        
        
        
        activityIndicator  = [[UIActivityIndicatorView alloc] initWithFrame:itemFrame];
        [activityIndicator setCenter:CGPointMake(center.x, center.y-100)];
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [activityIndicator setColor:[UIColor grayColor]];
        //[activityIndicator startAnimating];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //[self.layer setOpacity:0.5f];
        
        
        
        
        ErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(center.x-80, center.y-70, 200, 50)];
        [ErrorLabel setFont:[UIFont fontWithName:@"helvetica" size:25]];
        [ErrorLabel setText:@"Error Occurred!"];
        [ErrorLabel sizeToFit];
        
        [self addSubview:ErrorLabel];
        ErrorLabel.alpha = 0;
        [self addSubview:reloadButton];
        reloadButton.alpha = 0;
        [self addSubview:activityIndicator];
        
        // Initialization code
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
