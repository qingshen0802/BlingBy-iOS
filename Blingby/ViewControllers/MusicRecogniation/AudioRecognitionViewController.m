//
//  AudioRecognitionViewController.m
//  Blingby
//
//  Created by Simon Weingand on 10/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "AudioRecognitionViewController.h"

@interface AudioRecognitionViewController ()

@end

@implementation AudioRecognitionViewController

@synthesize audioPlot;
@synthesize microphone;
@synthesize statusLabel;

#pragma mark - Initialization
-(id)init {
    self = [super init];
    if(self){
        [self initializeViewController];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initializeViewController];
    }
    return self;
}

#pragma mark - Initialize View Controller Here
-(void)initializeViewController {
    // Create an instance of the microphone and tell it to use this view controller instance as the delegate
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
}

- (void)loadView {
    [super loadView];
    [self addContentView];
    [self addCloseButton];
}


- (void) viewDidLoad {
    [super viewDidLoad];
    /*
     Customizing the audio plot's look
     */
    // Background color
    self.audioPlot.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    // Waveform color
    self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    // Plot type
    self.audioPlot.plotType        = EZPlotTypeBuffer;

    /*
     Start the microphone
     */
    [self.microphone startFetchingAudio];
}

#pragma mark - Setup Views

- (void) addContentView {
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    audioPlot = [[EZAudioPlot alloc] initWithFrame:rect];
    audioPlot.alpha = 0.5;
    [self.view addSubview:audioPlot];
    
    CGFloat statusLabelTop = (CONTENT_TOP - LOGO_IMAGE_HEIGHT) / 2 + 20;
    
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, statusLabelTop, rect.size.width, LOGO_IMAGE_HEIGHT)];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.textColor = [UIColor whiteColor];
    [statusLabel setFont:[UIFont fontWithName:BLINGBY_INPUTFIELD_FONT size:(IS_PAD ? 32 : 24)]];
    [self.view addSubview:statusLabel];
    
    self.resultView = [[UIView alloc] initWithFrame:CGRectMake(0, CONTENT_TOP, rect.size.width, rect.size.height - CONTENT_TOP)];
    self.resultView.alpha = 0.0;
    [self.view addSubview:self.resultView];
    
    CGRect imageFrame = CGRectMake(kPaddingForLabel, 0, 70, 70);
    self.imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    [self.resultView addSubview:self.imageView];
    
    CGFloat leftForLabels = imageFrame.origin.x + imageFrame.size.width + kPaddingForLabel;
    
    CGRect titleFrame = CGRectMake(leftForLabels, 0, rect.size.width - leftForLabels - kPaddingForLabel, 30);
    self.titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:BLINGBY_INPUTFIELD_FONT size:(IS_PAD ? 24 : 18)];
    [self.resultView addSubview:self.titleLabel];
    
    CGRect descriptionFrame = CGRectMake(leftForLabels, titleFrame.origin.y + titleFrame.size.height + kPaddingForLabel, rect.size.width - leftForLabels - kPaddingForLabel, 30);
    self.descriptionLabel = [[UILabel alloc] initWithFrame:descriptionFrame];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.font = [UIFont fontWithName:BLINGBY_INPUTFIELD_FONT size:(IS_PAD ? 20 : 14)];
    [self.resultView addSubview:self.descriptionLabel];
    [self.resultView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedResult)]];
}

-(void)pinch:(UIPinchGestureRecognizer*)pinch {
    
}

#pragma mark - Actions
- (void) closeView {
    
}

- (void) selectedResult {
    
}

#pragma mark - EZMicrophoneDelegate
// Note that any callback that provides streamed audio data (like streaming microphone input) happens on a separate audio thread that should not be blocked. When we feed audio data into any of the UI components we need to explicity create a GCD block on the main thread to properly get the UI to work.
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.
    
    // See the Thread Safety warning above, but in a nutshell these callbacks happen on a separate audio thread. We wrap any UI updating in a GCD block on the main thread to avoid blocking that audio flow.
    dispatch_async(dispatch_get_main_queue(),^{
        // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
        [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
}

-(void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription {
    // The AudioStreamBasicDescription of the microphone stream. This is useful when configuring the EZRecorder or telling another component what audio format type to expect.
    // Here's a print function to allow you to inspect it a little easier
    [EZAudio printASBD:audioStreamBasicDescription];
}

-(void)microphone:(EZMicrophone *)microphone
    hasBufferList:(AudioBufferList *)bufferList
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as a buffer list that can be directly fed into the EZRecorder or EZOutput. Say whattt...
}

@end
