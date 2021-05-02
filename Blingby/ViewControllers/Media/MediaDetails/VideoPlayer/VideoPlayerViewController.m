//
//  VideoPlayerViewController.m
//  Blingby
//
//  Created by Simon Weingand on 22/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "Media.h"
#import "SearchResult.h"
#import "AppManager.h"
#import <XCDYouTubeKit/XCDYouTubeVideoPlayerViewController.h>

@interface VideoPlayerViewController () {
    NSInteger currentTimeStamp;
    BOOL isNewVideo;
    BOOL isPause;
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;

@end
@implementation VideoPlayerViewController

- (void) setupViews:(CGRect)frame {
    self.view = [[UIView alloc] initWithFrame:frame];
    isPause = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ( isPause == NO && _videoPlayerViewController ) {
        [_videoPlayerViewController.moviePlayer play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ( _videoPlayerViewController ) {
        [_videoPlayerViewController.moviePlayer pause];
    }
}

- (void)setMedia:(Media *)media {
    if ( _media && [_media.mediaId intValue] == [media.mediaId intValue] ) {
        isNewVideo = NO;
    }
    else {
        isNewVideo = YES;
    }
    _media = media;
    
    [self setNotifications];
    [self setVideo];
}

- (void)setSearchResult:(SearchResult *)searchResult {
    if ( _searchResult && [_searchResult.contentId intValue] == [searchResult.contentId intValue] ) {
        isNewVideo = NO;
    }
    else {
        isNewVideo = YES;
    }
    _searchResult = searchResult;
    
    [self setNotifications];
    [self setVideo];
}
#pragma mark - Notifications

- (void)dealloc {
    [self removeNotifications];
    
    if ( _videoPlayerViewController ) {
        [_videoPlayerViewController.moviePlayer stop];
        _videoPlayerViewController = nil;
    }
}

- (void) setNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(play) name:kNotificationProductDetailsClosed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:kNotificationProductDetialsOpened object:nil];
}

- (void) removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:kNotificationProductDetailsClosed];
    [[NSNotificationCenter defaultCenter] removeObserver:kNotificationProductDetialsOpened];
    [[NSNotificationCenter defaultCenter] removeObserver:MPMoviePlayerPlaybackStateDidChangeNotification];
}

- (void) play {
    isPause = NO;
    if ( _videoPlayerViewController ) {
        [_videoPlayerViewController.moviePlayer play];
    }
}

- (void) pause {
    isPause = YES;
    if ( _videoPlayerViewController ) {
        [_videoPlayerViewController.moviePlayer pause];
    }
}

- (void) setVideo {
    if ( isNewVideo == NO && _videoPlayerViewController ) {
    }
    else if ( _media ) {        
        if ( _media.mediaYoutubeId ) {
            _videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:_media.mediaYoutubeId];
            [_videoPlayerViewController presentInView:self.view];
        }
        currentTimeStamp = 0;
    }
    else if ( _searchResult ) {
        if ( _searchResult.mediaYoutubeId ) {
            _videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:_searchResult.mediaYoutubeId];
            [_videoPlayerViewController presentInView:self.view];
        }
        currentTimeStamp = 0;
    }
    else {
        _videoPlayerViewController = nil;
    }
    
    if ( _videoPlayerViewController ) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMediaTimer:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:_videoPlayerViewController.moviePlayer];
        
        [_videoPlayerViewController.moviePlayer play];
    }
}

- (void) setMediaTimer:(NSNotification*) notification {
    if ( !self ) {
        return;
    }
    
    if ( isPause ) {
        [_videoPlayerViewController.moviePlayer pause];
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    MPMoviePlayerController *player = [notification object];
    if ( [player playbackState] == MPMoviePlaybackStatePlaying ) {
        [self updateItems];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateItems) userInfo:nil repeats:YES];
    }
    else {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void) updateItems {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Do background work
        dispatch_async(dispatch_get_main_queue(), ^{
            MPMoviePlayerController *player = _videoPlayerViewController.moviePlayer;
            int currentPlaybackTime = (int)[player currentPlaybackTime];
            if ( currentPlaybackTime != currentTimeStamp ) {
                currentTimeStamp = currentPlaybackTime;
                if ( self.delegate )
                    [self.delegate didChangePlayback:currentTimeStamp];
            }
        });
    });
}

@end
