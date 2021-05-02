//
//  BaseViewController.m
//  Blingby
//
//  Created by Simon Weingand on 02/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"
#import "AppDelegate.h"
#import "ProductPopupViewController.h"
#import "Item.h"

@interface BaseViewController () {
    BOOL isShowedProductDetails;
}

@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isShowedProductDetails = NO;
    
    [self initViews];
    [self setGesture];
    
    self.blurredBgImage.image = [self blurWithImageEffects:[UIImage imageNamed:@"intro-under-blur"]];
    self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProductPopup:) name:kNotificationProductDetialsOpened object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideProductPopup:) name:kNotificationProductDetailsClosed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuButtonTapped:) name:kNotificationNavMenuButtonTapped object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:kNotificationProductDetialsOpened];
    [[NSNotificationCenter defaultCenter] removeObserver:kNotificationProductDetailsClosed];
    [[NSNotificationCenter defaultCenter] removeObserver:kNotificationNavMenuButtonTapped];
}

#pragma mark - Gesture

- (void) setGesture {
    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;
    
    NSDictionary *transitionData = self.transitions.all[3];
    id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
    if (transition == (id)[NSNull null]) {
        self.slidingViewController.delegate = nil;
    } else {
        self.slidingViewController.delegate = transition;
    }
    
    NSString *transitionName = transitionData[@"name"];
    if ([transitionName isEqualToString:METransitionNameDynamic]) {
        self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
        self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    } else {
        self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
        self.slidingViewController.customAnchoredGestures = @[];
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    
}

- (void) removeGesture {
    [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
    [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handleGesture:)];
    
    return _dynamicTransitionPanGesture;
}

- (void) handleGesture:(UIPanGestureRecognizer *)recognizer {
    if ( isShowedProductDetails == NO )
    {
        [self.transitions.dynamicTransition handlePanGesture:recognizer];
    }
}

#pragma mark - Navigation Bar

- (void)menuButtonTapped:(id)sender {
    if ( isShowedProductDetails == NO ) {
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
    }
}

#pragma mark - ProductPopupViewController

- (void) showProductPopup:(NSNotification*) notification {
    isShowedProductDetails = YES;
    [self removeGesture];
    ProductPopupViewController *productPopupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductPopupViewController"];
    [productPopupViewController showProductDetails:self.slidingViewController.topViewController item:[notification object]];
}

- (void) hideProductPopup:(NSNotification*) notification {
    isShowedProductDetails = NO;
    [self performSelector:@selector(setGesture) withObject:nil afterDelay:0.5];
}

@end
