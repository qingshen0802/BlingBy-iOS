//
//  HomeVideoViewController.h
//  Blingby
//
//  Created by Simon Weingand on 10/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//


#import <UIKit/UIKit.h>

@class AVPlayer;

@interface AVPlayerPlaybackView : UIView

@property (nonatomic, strong) AVPlayer* player;

- (void)setPlayer:(AVPlayer*)player;
- (void)setVideoFillMode:(NSString *)fillMode;

@end
