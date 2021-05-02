//
//  GnAudioVisualizeAdapter.m
//  GN_Music_SDK_iOS
//
//  Copyright (c) 2014 Gracenote. All rights reserved.
//

#import "GnAudioVisualizeAdapter.h"

#import <GnSDKObjC/Gn.h>
#import "GnAudioVisualizeAdapter.h"

@import CoreAudio;
@import AudioToolbox;

@interface GnAudioVisualizeAdapter()
@property (weak) id <GnAudioSourceDelegate> audioSource;
@property NSUInteger                         numBitsPerSample;
@property NSUInteger                         numChannels;
@property float lastRMS;
@property float maxRMS;
@property id<GnAudioVisualizerDelegate>      audioVisualizerDelegate;

@end

@implementation GnAudioVisualizeAdapter

-(instancetype) initWithAudioSource:(id<GnAudioSourceDelegate>) audioSource audioVisualizerDelegate:(id<GnAudioVisualizerDelegate> )audioVisualizerDelegate
{
    self = [super init];
    
    if(self)
    {
       self.audioSource = audioSource;
       self.lastRMS = 0;
       self.audioVisualizerDelegate = audioVisualizerDelegate;
    }
    
    return self;
}


-(NSUInteger) sourceInit
{
    if ( !self.audioSource )
    {
        return 1;
    }
    
    NSUInteger retVal = [self.audioSource sourceInit];
    
    // get format information for use later
    
    if ( retVal == 0 )
    {
        self.numBitsPerSample = [self.audioSource sampleSizeInBits];
        self.numChannels = [self.audioSource numberOfChannels];
    }
    
    return retVal;
}


-(NSUInteger) numberOfChannels
{
    return self.numChannels;
}


-(NSUInteger) sampleSizeInBits
{
    return self.numBitsPerSample;
}

-(NSUInteger)  samplesPerSecond
{
    if ( self.audioSource == nil )
    {
        return 0;
    }
    
    return self.audioSource.samplesPerSecond;
}

-(NSUInteger) getData: (unsigned char*)dataBuffer dataSize: (NSUInteger)dataSize
{
    if ( !self.audioSource)
    {
        return 0;
    }
    
    NSUInteger bytesRead = [self.audioSource getData:dataBuffer dataSize:dataSize];
    
    float RMS = [self rms16:(signed char*) dataBuffer bufferSize:bytesRead];
    
    if(self.audioVisualizerDelegate && [self.audioVisualizerDelegate conformsToProtocol:@protocol(GnAudioVisualizerDelegate)] && [self.audioVisualizerDelegate respondsToSelector:@selector(RMSDidUpdateByValue:)])
    {
        [self.audioVisualizerDelegate RMSDidUpdateByValue: RMS/10];
    }

    
    
    return bytesRead;
}


-(void) sourceClose
{
    if (self.audioSource)
    {
       [self.audioSource sourceClose];

    }
}


// calculate the rms of a buffer containing 16 bit audio samples
-( float ) rms16: (signed char*) buffer  bufferSize:(NSUInteger) bufferSize
{
    float sum = 0.0;
    NSUInteger mySize = bufferSize / sizeof(short);
    short *buffer_short = (short*)buffer;
    
    for(NSUInteger i = 0; i < mySize; i++)
    {
       sum += (float)(buffer_short[i] * buffer_short[i]);
    }
    
    float sqrt1 = sqrtf( sum / mySize );
    
    return (float)(sqrt1)/mySize;
}

@end
