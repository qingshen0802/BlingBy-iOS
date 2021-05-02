//
//  VideoPlayerViewController.h
//  Blingby
//
//  Created by Simon Weingand on 22/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;
@class SearchResult;

@protocol VideoPlayerViewControllerDelegate <NSObject>

@optional
- (void) didChangePlayback:(NSInteger) currentPlaybackTime;

@end

@interface VideoPlayerViewController : UIViewController

@property (weak, nonatomic) id<VideoPlayerViewControllerDelegate> delegate;

@property (nonatomic, strong) Media *media;
@property (nonatomic, strong) SearchResult *searchResult;

- (void) setupViews:(CGRect)frame;
- (void) play;
- (void) pause;
- (void) setNotifications;
- (void) removeNotifications;

@end
