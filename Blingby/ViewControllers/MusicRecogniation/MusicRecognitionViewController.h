//
//  MusicRecognitionViewController.h
//  Blingby
//
//  Created by Simon Weingand on 23/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "AudioRecognitionViewController.h"

@protocol MusicRecognitionViewControllerDelegate <NSObject>

@optional
- (void) closeMusicRecognition;
- (void) enableOrDisableControls:(BOOL) enable;
- (void) selectedDataModel:(NSString*) title;

@end

@interface MusicRecognitionViewController : AudioRecognitionViewController

@property (weak, nonatomic) id<MusicRecognitionViewControllerDelegate> delegate;

- (void) initRecognition;
- (void) startRecognition;

@end
