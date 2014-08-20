//
//  ViewController.m
//  MemoryGame
//
//  Created by Vikas on 20/08/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "ViewController.h"
#import "photoCollectionCell.h"

@interface ViewController ()

@property (nonatomic, strong) UICollectionView *photoGrid;
@property (nonatomic, strong) UIImageView *randomImageView;
@end

@implementation ViewController

@synthesize photoGrid;
@synthesize randomImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addCollectionView];
    [self addImageView];
	// Do any additional setup after loading the view, typically from a nib.
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
