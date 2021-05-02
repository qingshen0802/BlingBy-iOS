//
//  AudioRecognitionViewController.h
//  Blingby
//
//  Created by Simon Weingand on 10/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BasePopupViewController.h"
#import <EZAudio/EZAudio.h>

@interface AudioRecognitionViewController : BasePopupViewController<EZMicrophoneDelegate>

@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIView *resultView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

#pragma mark - Components
/**
 The CoreGraphics based audio plot
 */
@property (nonatomic,strong) EZAudioPlot *audioPlot;

/**
 The microphone component
 */
@property (nonatomic,strong) EZMicrophone *microphone;

@end
