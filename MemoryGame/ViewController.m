//
//  ViewController.m
//  MemoryGame
//
//  Created by Vikas on 20/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "ViewController.h"
#import "photoCollectionCell.h"
#import "GameObjectManager.h"
#import "PhotoData.h"
#import "DraggableImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ViewController () {
    
    int seconds;
    int imagesToBePlaced;
    int randomNum;
    //CGRect randomImageActualframe;
    
}

@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) GameObjectManager *objectManager;
@property (nonatomic, strong) UICollectionView *photoGrid;
@property (nonatomic, strong) UIImageView *randomImage;
@property (nonatomic, strong) NSMutableArray *imagesDisplayed;

@end

@implementation ViewController

@synthesize imagesDisplayed;
@synthesize randomImage;
@synthesize timerLabel;
@synthesize timer;
@synthesize photosArray;
@synthesize photoGrid;
@synthesize objectManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setInitialParams];
    [objectManager setDelegate:self];
    [self loadData];
    
    [self addCollectionView];
    [self addImageView];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) setInitialParams {
    objectManager = [GameObjectManager getManager];
    seconds = 15;
    imagesToBePlaced = 9;
    
    imagesDisplayed = [[NSMutableArray alloc] init];
    
    for(int i=0;i<9;i++) {
        [imagesDisplayed addObject:[NSNumber numberWithInt:0]];
    }
    
}

-(void) addTimerLabel {
    
    timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 200, 50)];
    
    [timerLabel setFont:[UIFont fontWithName:@"helvetica" size:30]];
    timerLabel.text = [NSString stringWithFormat:@"00:%i", seconds];
    timerLabel.textColor = [UIColor redColor];
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
        timerLabel.text = @"START!!";
        [self invertImages];
        [timer invalidate];
        
        [self SelectRandomImage];
    }
}

-(void) SelectRandomImage {
    
    if(imagesToBePlaced!=0)
    {
        randomNum = arc4random() %9;
        imagesToBePlaced--;
        
        while([[imagesDisplayed objectAtIndex:randomNum] intValue]==1) {
            randomNum = arc4random() %9;
        }
        
        //randomImageActualframe = [[photoGrid cellForItemAtIndexPath:[NSIndexPath indexPathForRow:randomNum/3 inSection:randomNum%3]] frame];
        
        [randomImage setImageWithURL:[NSURL URLWithString:[(PhotoData*)[photosArray objectAtIndex:randomNum] photoURL]]
                       placeholderImage:[UIImage imageNamed:@""]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  
                              }];
        
        
    }
    else {
        
        //
    }
    
}


-(void) invertImages {
    
    NSArray *visibleCellIndexPaths = [photoGrid indexPathsForVisibleItems];
    
    for(NSIndexPath * indexPath in visibleCellIndexPaths)
    {
        id cell =[photoGrid cellForItemAtIndexPath:indexPath];
        ((photoCollectionCell*)cell).photoView.image = [UIImage imageNamed:@"download.jpeg"];
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
    randomImage.image= [UIImage imageNamed:@"download.jpeg"];
    [self.view addSubview:randomImage];
    

}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    int index = indexPath.section*3+indexPath.row;
    
    if(index == randomNum)
    {
        id cell =[photoGrid cellForItemAtIndexPath:indexPath];
                [((photoCollectionCell*)cell).photoView setImageWithURL:[NSURL URLWithString:[(PhotoData*)[photosArray objectAtIndex:index] photoURL]]
            placeholderImage:[UIImage imageNamed:@""]
            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
            }];
        
        [imagesDisplayed setObject:[NSNumber numberWithInt:1] atIndexedSubscript:index];
        [self SelectRandomImage];

        
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
    
    int arrayIndex = indexPath.section*3+indexPath.row;
    
    if(photosArray!=nil && [photosArray count]>0) {
    
    [cell.photoView setImageWithURL:[NSURL URLWithString:[(PhotoData*)[photosArray objectAtIndex:arrayIndex] photoURL]]
                                   placeholderImage:[UIImage imageNamed:@""]
                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                              
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

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize retval = CGSizeMake(80,80);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 5, 10, 5);
}


-(void) loadData {
    
    NSString *urlPath = @"/services/feeds/photos_public.gne";
    NSDictionary *queryParams = @{@"format" : @"json"};
    [objectManager getObjectForClass:[PhotoData class] fromURLPath:urlPath withParams:queryParams];
    
}

-(void) didLoadObjectsForClass:(Class)klass fromURLPath:(NSString *)URLPath fetchedResponseObject:(id)responseObject
{
    photosArray = [[NSMutableArray alloc] init];
    NSString *jsonString = [NSString stringWithUTF8String:[responseObject bytes]];
    NSString *trimmedString = [jsonString substringWithRange:NSMakeRange(15, jsonString.length-16)];
    NSLog(@"%@",jsonString);
    NSLog(@"==========================================");
    NSLog(@"%@",trimmedString);
    NSData* bytes = [trimmedString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonParsingError = nil;
    NSDictionary * jsonDataObject = [NSJSONSerialization JSONObjectWithData:bytes options:0 error:&jsonParsingError];
    NSArray *photosJsonArray = [jsonDataObject valueForKeyPath:@"items"];
    
    int i=0;
    
    for(NSDictionary * photoJSON in photosJsonArray)
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
    
    
    [photoGrid reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
