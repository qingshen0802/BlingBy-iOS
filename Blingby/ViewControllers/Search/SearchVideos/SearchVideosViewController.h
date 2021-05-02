//
//  SearchVideosViewController.h
//  Blingby
//
//  Created by Simon Weingand on 06/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVideosViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

- (void) setupViews:(CGRect)frame;
- (void) getResults:(NSString*)searchText;
- (void) setResults:(NSArray*)results;

@end
