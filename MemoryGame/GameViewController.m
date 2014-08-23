//
//  ViewController.m
//  MemoryGame
//
//  Created by Vikas on 20/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "GameViewController.h"
#import "photoCollectionCell.h"
#import "GameObjectManager.h"
#import "PhotoData.h"
#import "GameLoaderView.h"
#import "GameStartView.h"
#import "GameOverView.h"
#import <POP.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AudioToolbox/AudioToolbox.h>
@interface GameViewController () {
    
    int seconds;
    int imagesToBePlaced;
    int randomNum;
    int score;
    //CGRect randomImageActualframe;
    
}

@property (nonatomic, strong) GameOverView *gameOverView;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) GameObjectManager *objectManager;
@property (nonatomic, strong) UICollectionView *photoGrid;
@property (nonatomic, strong) UIImageView *randomImage;
@property (nonatomic, strong) NSMutableArray *imagesDisplayed;
@property (nonatomic, strong) GameLoaderView *loaderView;
@property (nonatomic, strong) GameStartView *startView;


@end

@implementation GameViewController

@synthesize startView;
@synthesize loaderView;
@synthesize imagesDisplayed;
@synthesize randomImage;
@synthesize timerLabel;
@synthesize timer;
@synthesize photosArray;
@synthesize photoGrid;
@synthesize objectManager;
@synthesize scoreLabel;
@synthesize gameOverView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    objectManager = [GameObjectManager getManager];
    [self setInitialParams];
    [objectManager setDelegate:self];
    
    [self setUpStartView];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}


-(void) setUpStartView {
    startView = [[GameStartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:startView];
    startView.playButton.tag=1;
    [startView.playButton addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventTouchUpInside];
}


-(void) setUpLoaderView {
    
    loaderView  = [[GameLoaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:loaderView];
    [loaderView.reloadButton addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) setInitialParams {
    
    score = 0;
    seconds = 15;
    imagesToBePlaced = 9;
    photosArray = [[NSMutableArray alloc] init];
    imagesDisplayed = [[NSMutableArray alloc] init];
    
    for(int i=0;i<9;i++) {
        [imagesDisplayed addObject:[NSNumber numberWithInt:0]];
    }
    
    [photoGrid reloadData];
    [scoreLabel removeFromSuperview];
    [randomImage removeFromSuperview];
    scoreLabel=nil;
    randomImage=nil;
    
}

-(void) addTimerLabel {
    
    timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 25, 200, 50)];
    
    [timerLabel setFont:[UIFont fontWithName:@"helvetica" size:40]];
    timerLabel.text = [NSString stringWithFormat:@"00:%i", seconds];
    timerLabel.textColor = THEME_COLOR;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(subtractTime)
                                           userInfo:nil
                                            repeats:YES];
    [self.view addSubview:timerLabel];
    
    
}

- (void)subtractTime {
    
    seconds--;
    
    if(seconds<10) {
        
        timerLabel.text = [NSString stringWithFormat:@"00:0%i",seconds];
    }
    else {
        
        timerLabel.text = [NSString stringWithFormat:@"00:%i",seconds];
    }
    
    if (seconds == 0) {
        
        [self addImageView];
        [timerLabel removeFromSuperview];
        [self addScoreLabel];
        [self invertImages];
        [timer invalidate];
        
        [self SelectRandomImage];
    }
}

-(void) addScoreLabel {
    
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 250, 50)];
    
    [scoreLabel setFont:[UIFont fontWithName:@"helvetica" size:40]];
    scoreLabel.text = [NSString stringWithFormat:@"Score : %i", score];
    scoreLabel.textColor = THEME_COLOR;
    
    [self.view addSubview:scoreLabel];
    
}

-(void) SelectRandomImage {
    
    if(imagesToBePlaced!=0)
    {
        randomNum = arc4random() %9;
        imagesToBePlaced--;
        
        while([[imagesDisplayed objectAtIndex:randomNum] intValue]==1) {
            randomNum = arc4random() %9;
        }
        
        
        
        [randomImage sd_setImageWithURL:[NSURL URLWithString:[(PhotoData*)[photosArray objectAtIndex:randomNum]photoURL]]
                       placeholderImage:nil
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
                                  
                              }];
        
        
        
    }
    else {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        if([prefs objectForKey:HIGH_SCORE]==nil) {
        
            [prefs setObject:[NSString stringWithFormat:@"%i", score] forKey:HIGH_SCORE];
            [prefs synchronize];
        }
        else {
            
            int highScore = [[prefs objectForKey:HIGH_SCORE] intValue];
            
            if(highScore<score) {
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", score] forKey:HIGH_SCORE];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        
        
        gameOverView = [[GameOverView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        gameOverView.replayButton.tag = 2;
        [gameOverView.replayButton addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *scoreText = scoreLabel.text;
        
        gameOverView.scoreLabel.text=scoreText;
        [gameOverView.scoreLabel sizeToFit];
        [self.view addSubview:gameOverView];
        
        
    }
    
}


-(void) invertImages {
    
    NSArray *visibleCellIndexPaths = [photoGrid indexPathsForVisibleItems];
    
    for(NSIndexPath * indexPath in visibleCellIndexPaths)
    {
        id cell =[photoGrid cellForItemAtIndexPath:indexPath];
        ((photoCollectionCell*)cell).photoView.image = [UIImage imageNamed:@"placeholder.jpg"];
    }
}



-(void) addCollectionView {
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    photoGrid = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 70, 320, 400) collectionViewLayout:layout];
    [self.view addSubview:photoGrid];
    photoGrid.backgroundColor=[UIColor whiteColor];
    photoGrid.delegate = self;
    photoGrid.dataSource = self;
    [photoGrid registerClass:[photoCollectionCell class] forCellWithReuseIdentifier:@"photoCell"];
    
}

-(void) addImageView {
    
    randomImage  = [[UIImageView alloc] initWithFrame:CGRectMake(100, 420, 120, 120)];
    //randomImage.image= [UIImage imageNamed:@"download.jpeg"];
    [self.view addSubview:randomImage];
    
    
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    long index = indexPath.section*3+indexPath.row;
    
    if(randomImage!=nil) {
        if(index == randomNum)
        {
            
            score+=100;
            
            scoreLabel.text=[NSString stringWithFormat:@"Score : %i",score];
            
            id cell =[photoGrid cellForItemAtIndexPath:indexPath];
            
            
            [((photoCollectionCell*)cell).photoView sd_setImageWithURL:[NSURL URLWithString:[(PhotoData*)[photosArray objectAtIndex:index] photoURL]]
                                                      placeholderImage:nil
                                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
                                                                 
                                                             }];
            
            
            [imagesDisplayed setObject:[NSNumber numberWithInt:1] atIndexedSubscript:index];
            [self SelectRandomImage];
            
            
        } else {
            
            score-=50;
            
            scoreLabel.text=[NSString stringWithFormat:@"Score : %i",score];
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self shakeImage];
        }
    }
}

#pragma mark- CollectionViewDataSource methods

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 3;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    photoCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    long arrayIndex = indexPath.section*3+indexPath.row;
    
    if(photosArray!=nil && [photosArray count]>0) {
        
        
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[(PhotoData*)[photosArray objectAtIndex:arrayIndex] photoURL]]
                          placeholderImage:nil
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
                                     
                                     [cell.loader stopAnimating];
                                     
                                     if(arrayIndex == [photosArray count]-1)
                                     {
                                         [self addTimerLabel];
                                     }
                                     
                                 }];
        
        
    }
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize retval = CGSizeMake(75,75);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 5, 10, 5);
}



-(void) loadData:(id) sender {
    
    NSInteger buttonTag = ((UIButton*)sender).tag;
    
    if(buttonTag==1) {
        
        [self setUpLoaderView];
        CGAffineTransform translate= CGAffineTransformMakeTranslation(startView.frame.origin.x, 480.0f + (startView.frame.size.height/2));
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             startView.transform = translate;
                             startView.alpha =0;
                         }
                         completion:^(BOOL finished) {
                             [startView removeFromSuperview];
                             
                             
                         }];
        
        [loaderView.activityIndicator startAnimating];
    }
    
    else if (buttonTag==2)
    {
        [self setUpLoaderView];
        [photoGrid removeFromSuperview];
        CGAffineTransform translate= CGAffineTransformMakeTranslation(gameOverView.frame.origin.x, 480.0f + (gameOverView.frame.size.height/2));
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             gameOverView.transform = translate;
                             //gameOverView.alpha =0;
                         }
                         completion:^(BOOL finished) {
                             [gameOverView removeFromSuperview];
                             [self setInitialParams];
                             
                         }];
        
        [loaderView.activityIndicator startAnimating];
        
    }
    else {
        
        loaderView.ErrorLabel.alpha = 0;
        [loaderView.activityIndicator startAnimating];
    }
    
    NSString *urlPath = @"/services/feeds/photos_public.gne";
    NSDictionary *queryParams = @{@"format" : @"json",
                                  @"lang": @"en-us",
                                  @"nojsoncallback":@"1"};
    //@"api_key":@"5475b6fd9172724f2dc72e76d7484369"};
    
    
    [objectManager getObjectsFromURLPath:urlPath withParams:queryParams];
    
    
}

-(void) didLoadObjectsfromURLPath:(NSString*) URLPath fetchedResponseObject:(id) responseObject;
{
    photosArray = [[NSMutableArray alloc] init];
    NSString *jsonString = [NSString stringWithUTF8String:[responseObject bytes]];
    NSLog(@"%@",jsonString);
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"]; //Cleaning the received json, a bug in the API which replaces ' by \' .
    
    NSData* bytes = [jsonString dataUsingEncoding:NSUTF16StringEncoding];
    NSError *jsonParsingError = nil;
    NSDictionary * jsonDataObject = [NSJSONSerialization JSONObjectWithData:bytes options:NSJSONReadingAllowFragments error:&jsonParsingError];
    
    
    if(jsonParsingError==nil) {
        
        CGAffineTransform translate= CGAffineTransformMakeTranslation(loaderView.frame.origin.x, 480.0f + (loaderView.frame.size.height/2));
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             loaderView.transform = translate;
                         }
                         completion:^(BOOL finished) {
                             [loaderView removeFromSuperview];
                             [self addCollectionView];
                             
                         }];
        
        NSLog(@"%@",jsonParsingError);
        NSArray *photosJsonArray = [jsonDataObject valueForKeyPath:@"items"];
        int i=0;
        
        for(NSDictionary * photoJSON in photosJsonArray) //Get 9 photos from the received json dictionary
        {
            
            
            if(i<9) {
                
                PhotoData * photobj = [[PhotoData alloc] initWithJSON:photoJSON];
                
                [photosArray addObject:photobj];
                
                i++;
            }
            else {
                
                break;
            }
            
        }
        
        
    }
    else {
        
        [loaderView.activityIndicator stopAnimating];
        
        [UIView animateWithDuration:1.f
                         animations:^{
                             
                             loaderView.ErrorLabel.alpha = 1;
                             loaderView.reloadButton.alpha = 1;
                             
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
    }
    
}


-(void)didFailToLoadObjectsfromURLPath:(NSString*)URLPath fetchedResponseObject:(id)error{
   
    
    [loaderView.activityIndicator stopAnimating];
    
    [UIView animateWithDuration:1.f
                     animations:^{
                         
                         loaderView.ErrorLabel.alpha = 1;
                         loaderView.reloadButton.alpha = 1;
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];

   
}

#pragma animations

- (void)shakeImage
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    
    positionAnimation.fromValue = @(100);
    positionAnimation.toValue = @(150);
    
    positionAnimation.velocity = @3000;
    positionAnimation.springBounciness = 15;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        //self.button.userInteractionEnabled = YES;
    }];
    [randomImage.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
