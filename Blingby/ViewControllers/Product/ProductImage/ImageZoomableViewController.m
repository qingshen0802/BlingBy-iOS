//
//  ImageZoomableViewController.m
//  Blingby
//
//  Created by Simon Weingand on 16/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "ImageZoomableViewController.h"
#import "AppDelegate.h"

@interface ImageZoomableViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) UIImageView *mainImageView;
@end

@implementation ImageZoomableViewController

#pragma mark -
#pragma mark - View Methods
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Creates an image view with a test image
    self.mainImageView = [[UIImageView alloc] init];
    UIImage *turnImage = self.image;
    [self.mainImageView setImage:turnImage];
    
    // Add the imageview to the scrollview
    [self.mainScrollView addSubview:self.mainImageView];
    
    // Sets the following flag so that auto layout is used correctly
    self.mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mainImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Sets the scrollview delegate as self
    self.mainScrollView.delegate = self;
    
    // Sets the image frame as the image size
    self.mainImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    // Tell the scroll view the size of the contents
    self.mainScrollView.contentSize = turnImage.size;
    
    // Add doubleTap recognizer to the scrollView
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.mainScrollView addGestureRecognizer:doubleTapRecognizer];
    
    // Add two finger recognizer to the scrollView
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.mainScrollView addGestureRecognizer:twoFingerTapRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Setup the scrollview scales on viewWillAppear
    [self setupScales];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self fullScreenAnimation];
}

- (void) fullScreenAnimation {
    CGRect rect = [[[[UIApplication sharedApplication] delegate] window] bounds];
    [UIView animateWithDuration:1.0f animations:^{
        self.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        self.mainImageView.frame = self.view.bounds;
    }];
}

#pragma mark -
#pragma mark - Scroll View scales setup and center

-(void)setupScales {
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = self.mainScrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.mainScrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.mainScrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.mainScrollView.minimumZoomScale = minScale;
    self.mainScrollView.maximumZoomScale = 10.0f;
    self.mainScrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}

- (void)centerScrollViewContents {
    // This method centers the scroll view contents also used on did zoom
    CGSize boundsSize = self.mainScrollView.bounds.size;
    CGRect contentsFrame = self.mainImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.mainImageView.frame = contentsFrame;
}

#pragma mark -
#pragma mark - ScrollView Delegate methods
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.mainImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}

#pragma mark -
#pragma mark - ScrollView gesture methods
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // Get the location within the image view where we tapped
    CGPoint pointInView = [recognizer locationInView:self.mainImageView];
    
    // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.mainScrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.mainScrollView.maximumZoomScale);
    
    // Figure out the rect we want to zoom to, then zoom to it
    CGSize scrollViewSize = self.mainScrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.mainScrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.mainScrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.mainScrollView.minimumZoomScale);
    [self.mainScrollView setZoomScale:newZoomScale animated:YES];
}

#pragma mark -
#pragma mark - Rotation

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // When the orientation is changed the contentSize is reset when the frame changes. Setting this back to the relevant image size
    self.mainScrollView.contentSize = self.mainImageView.image.size;
    // Reset the scales depending on the change of values
    [self setupScales];
}

@end
