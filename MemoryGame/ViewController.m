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
#import <SDWebImage/UIImageView+WebCache.h>
@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) GameObjectManager *objectManager;
@property (nonatomic, strong) UICollectionView *photoGrid;
@property (nonatomic, strong) UIImageView *randomImageView;
@end

@implementation ViewController

@synthesize photosArray;
@synthesize photoGrid;
@synthesize randomImageView;
@synthesize objectManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    objectManager = [GameObjectManager getManager];
    [objectManager setDelegate:self];
    [self loadData];
    [self addCollectionView];
    [self addImageView];
	// Do any additional setup after loading the view, typically from a nib.
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
     NSLog(@"%@",trimmedString);
    NSData* bytes = [trimmedString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * jsonDataObject = [NSJSONSerialization JSONObjectWithData:bytes options:0 error:nil];
    
    NSArray *photosJsonArray = [jsonDataObject valueForKeyPath:@"items"];
    
    int i=0;
    
    for(NSDictionary * photoJSON in photosJsonArray)
    {
        if(i<9) {
        
            PhotoData * photobj = [[PhotoData alloc] initWithJSON:photoJSON];
            
            [photosArray addObject:photobj];
            
            i++;
        }
        else
            break;
    }
    
    
    [photoGrid reloadData];
}


-(void) addCollectionView {
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    photoGrid = [[UICollectionView alloc] initWithFrame:CGRectMake(40, 50, 320, 300) collectionViewLayout:layout];
    [self.view addSubview:photoGrid];
    photoGrid.backgroundColor=[UIColor whiteColor];
    photoGrid.delegate = self;
    photoGrid.dataSource = self;
    [photoGrid registerClass:[photoCollectionCell class] forCellWithReuseIdentifier:@"photoCell"];
    
}

-(void) addImageView {
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(90, 350, 140, 140)];
    [button setBackgroundColor:[UIColor grayColor]];
    [button.layer setCornerRadius:5.f];
    
//    randomImageView = [[UIImageView alloc] initWithFrame:];
//    [randomImageView.layer setCornerRadius:5.f];
//    randomImageView.userInteractionEnabled=YES;
//    [randomImageView setBackgroundColor:[UIColor grayColor]];
//    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
//    //[gestureRecognizer setNumberOfTapsRequired:1];
//    [randomImageView addGestureRecognizer:gestureRecognizer];
    
    [button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    //[button setImage:[UIImage imageNamed:@"vehicle.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    UIControl *control = sender;
    
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:control];
    CGPoint p = [t locationInView:control];
    
    CGPoint center = control.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    control.center = center;
}

//-(void) handlePanFrom:(id) sender {
//    
//    UIControl *control = sender;
//    
//    //UITouch *t = [[event allTouches] anyObject];
//    CGPoint pPrev = [t previousLocationInView:control];
//    CGPoint p = [t locationInView:control];
//    
//    CGPoint center = control.center;
//    center.x += p.x - pPrev.x;
//    center.y += p.y - pPrev.y;
//    control.center = center;
//}

#pragma mark- CollectionViewDataSource methods

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 3;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    photoCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    if(photosArray!=nil && [photosArray count]>0) {
    
    [cell.photoView setImageWithURL:[NSURL URLWithString:[(PhotoData*)[photosArray objectAtIndex:indexPath.section*3+indexPath.row] photoURL]]
                                   placeholderImage:[UIImage imageNamed:@""]
                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                              
                                              [cell.loader stopAnimating];
                                          }];
    }
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize retval = CGSizeMake(70, 70);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 5, 10, 5);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
