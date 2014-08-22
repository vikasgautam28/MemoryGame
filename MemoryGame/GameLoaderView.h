//
//  LoadingView.h
//  MemoryGame
//
//  Created by Vikas on 21/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameLoaderView : UIView


@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *ErrorLabel;


@end
