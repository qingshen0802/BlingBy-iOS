//
//  RecentCollectionReusableView.h
//  Blingby
//
//  Created by Simon Weingand on 27/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionHeaderReusableView : UICollectionReusableView

@property (strong, nonatomic) UILabel *headerLabel;

- (void)setHeaderTitle:(NSString*)title;

@end
