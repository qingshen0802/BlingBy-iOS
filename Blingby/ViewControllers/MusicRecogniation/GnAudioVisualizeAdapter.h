//
//  GnAudioVisualizeAdapter.h
//  GN_Music_SDK_iOS
//
//  Copyright (c) 2014 Gracenote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GnSDKObjC/Gn.h>

@protocol GnAudioVisualizerDelegate <NSObject>

-(void) RMSDidUpdateByValue:(float) value;

@end

@interface GnAudioVisualizeAdapter : NSObject <GnAudioSourceDelegate>

-(instancetype) initWithAudioSource:(id<GnAudioSourceDelegate>) audioSource audioVisualizerDelegate:(id<GnAudioVisualizerDelegate> )audioVisualizerDelegate;

-(instancetype) init __attribute__((unavailable("init not available. Use initWithAudioSource: instead.")));

@end
