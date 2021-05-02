//
//  MusicRecognitionViewController.m
//  Blingby
//
//  Created by Simon Weingand on 23/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "MusicRecognitionViewController.h"
#import "MatchedTableViewCell.h"
#import "GnDataModel.h"
#import "BaseBlurViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

#import <GnSDKObjC/Gn.h>

#import "GnAudioVisualizeAdapter.h"

static NSString *gnsdkLicenseFilename = @"license.txt";

@interface MusicRecognitionViewController ()<GnMusicIdStreamEventsDelegate,  GnMusicIdFileEventsDelegate, GnMusicIdFileInfoEventsDelegate,  GnLookupLocalStreamIngestEventsDelegate>

/*GnSDK properties*/
@property (strong) GnMusicIdStream *gnMusicIDStream;
@property (strong) GnMic *gnMic;
@property (strong) GnAudioVisualizeAdapter *gnAudioVisualizeAdapter;
@property (strong) GnManager *gnManager;
@property (strong) GnUser *gnUser;
@property (strong) GnUserStore *gnUserStore;
@property (strong) NSMutableArray *albumDataMatches;
@property (strong) GnLocale *locale;

@property (nonatomic,strong) EZMicrophone *microphone;

/*Sample App properties*/
@property (assign) BOOL audioProcessingStarted;
@property (assign) NSTimeInterval queryBeginTimeInterval;
@property (assign) NSTimeInterval queryEndTimeInterval;
@property (strong) NSMutableArray *cancellableObjects;


@property BOOL recordingIsPaused;
@property UIDynamicAnimator *dynamicAnimator;
@property dispatch_queue_t internalQueue;
@property (strong) NSMutableArray *results;

@end

@implementation MusicRecognitionViewController

- (void)loadView {
    [super loadView];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = [BaseBlurViewController getBackgroundImage];
    backgroundImageView.alpha = 0.8;
    [self.view insertSubview:backgroundImageView atIndex:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recordingIsPaused = NO;
    
    self.statusLabel.text = @"";
    
    self.audioProcessingStarted = 0;
    self.queryBeginTimeInterval = -1;
    self.queryEndTimeInterval = -1;
    
    self.cancellableObjects = [[NSMutableArray alloc] init];
    self.albumDataMatches = [[NSMutableArray alloc] init];
    
    self.results = [[NSMutableArray alloc] init];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setPreferredSampleRate:44100 error:nil];
    [session setInputGain:0.5 error:nil];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationResignedActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    // Check if both ClientID and ClientIDTag have been set.
    if ([CLIENTID length]==0 || [CLIENTIDTAG length]==0)
    {
        self.statusLabel.text = @"Please set Client ID and Client Tag.";
        return;
    }
    
    // Check if license file has been set.
    if (gnsdkLicenseFilename==nil)
    {
        self.statusLabel.text = @"License filename not set.";
        return;
    }
    else if ([[NSBundle mainBundle] pathForResource:gnsdkLicenseFilename ofType:nil] ==nil)
    {
        self.statusLabel.text = [NSString stringWithFormat:@"License file not found:%@", gnsdkLicenseFilename];
        return;
    }
    
    __block NSError * error = nil;
    
    // -------------------------------------------------------------------------------
    // Initialize GNSDK.
    // -------------------------------------------------------------------------------
    error = [self initializeGNSDKWithClientID:CLIENTID clientIDTag:CLIENTIDTAG];
    if (error)
    {
        NSLog( @"Error: 0x%zx %@ - %@", (long)[error code], [error domain], [error localizedDescription] );
    }
    else
    {
        // -------------------------------------------------------------------------------
        // Initialize Microphone AudioSource to Start Recording.
        // -------------------------------------------------------------------------------
        
        // Configure Microphone
        self.gnMic = [[GnMic alloc] initWithSampleRate: 44100 bitsPerChannel:16 numberOfChannels: 1];
        
        // configure dispatch queue
        self.internalQueue = dispatch_queue_create("gnsdk.TaskQueue", NULL);
        
        // If configuration succeeds, start recording.
        if (self.gnMic)
        {
            [self setupMusicIDStream];
        }
    }
}

-(void) dealloc
{
    [self stopRecording];
    [self.cancellableObjects removeAllObjects];
    self.cancellableObjects = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClose:(id)sender {
    self.closeButton.enabled = NO;
    [self cancelAllOperations];
    if ( self.delegate ) {
        [self.delegate closeMusicRecognition];
    }
}

- (void) initRecognition {
    
}

- (void) startRecognition {
    if(self.gnMusicIDStream)
    {
        [self.results removeAllObjects];
        
        NSError *error = nil;
        [self.cancellableObjects addObject: self.gnMusicIDStream];
        [self.gnMusicIDStream identifyAlbumAsync:&error];
        [self updateStatus: @"Identifying"];
        
        if (error)
        {
            NSLog(@"Identify Error = %@", [error localizedDescription]);
            self.queryBeginTimeInterval = -1;
        }
        else
        {
            self.queryBeginTimeInterval = [[NSDate date] timeIntervalSince1970];
        }
    }
    
    /*
     Start the microphone
     */
    [self.microphone startFetchingAudio];
    
    [self showResults:NO];
}

#pragma mark - Music ID Stream Setup

-(void) setupMusicIDStream
{
    if (!self.gnUser)
        return;
    self.recordingIsPaused = NO;
    
    __block NSError *musicIDStreamError = nil;
    @try
    {
        self.gnMusicIDStream = [[GnMusicIdStream alloc] initWithGnUser: self.gnUser preset:kPresetMicrophone locale:self.locale musicIdStreamEventsDelegate: self];
        
        musicIDStreamError = nil;
        GnMusicIdStreamOptions *options = [self.gnMusicIDStream options];
        [options resultSingle:YES error:&musicIDStreamError];
        [options lookupData:kLookupDataSonicData enable:YES error:&musicIDStreamError];
        [options lookupData:kLookupDataContent enable:YES error:&musicIDStreamError];
        [options preferResultCoverart:YES error:&musicIDStreamError];
        
        musicIDStreamError = nil;
        dispatch_async(self.internalQueue, ^
                       {
                           self.gnAudioVisualizeAdapter = [[GnAudioVisualizeAdapter alloc] initWithAudioSource:self.gnMic audioVisualizerDelegate:nil];
                           
//                           self.idNowButton.enabled = NO; //disable stream-ID until audio-processing-started callback is received
                           
                           [self.gnMusicIDStream audioProcessStartWithAudioSource:(id <GnAudioSourceDelegate>)self.gnAudioVisualizeAdapter error:&musicIDStreamError];
                           
                           if (musicIDStreamError)
                           {
                               dispatch_async(dispatch_get_main_queue(), ^
                                              {
                                                  NSLog(@"Error while starting Audio Process With AudioSource - %@", [musicIDStreamError localizedDescription]);
                                              });
                           }
                       });
    }
    @catch (NSException *exception)
    {
        NSLog( @"Error: %@ - %@ - %@", [exception name], [exception reason], [exception userInfo] );
    }
}


#pragma mark - GnManager, GnUser Initialization

-(NSError *) initializeGNSDKWithClientID: (NSString*)clientID clientIDTag: (NSString*)clientIDTag
{
    NSError*	error = nil;
    NSString*	resourcePath  = [[NSBundle mainBundle] pathForResource: gnsdkLicenseFilename ofType: nil];
    NSString*	licenseString = [NSString stringWithContentsOfFile: resourcePath
                                                        encoding: NSUTF8StringEncoding
                                                           error: &error];
    if (error)
    {
        NSLog( @"Error in reading license file %@ at path %@ - %@", gnsdkLicenseFilename, resourcePath, [error localizedDescription] );
    }
    else
    {
        @try
        {
            self.gnManager = [[GnManager alloc] initWithLicense: licenseString licenseInputMode: kLicenseInputModeString];
            self.gnUserStore = [[GnUserStore alloc] init];
            self.gnUser = [[GnUser alloc] initWithGnUserStoreDelegate: self.gnUserStore
                                                             clientId: clientID
                                                            clientTag: clientIDTag
                                                   applicationVersion: @"1.0.0.0"];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSError *localeError = nil;
                
                @try
                {
                    self.locale = [[GnLocale alloc] initWithGnLocaleGroup: kLocaleGroupMusic
                                                                 language: kLanguageEnglish
                                                                   region: kRegionGlobal
                                                               descriptor: kDescriptorSimplified
                                                                     user: self.gnUser
                                                     statusEventsDelegate: nil];
                    
                    [self.locale setGroupDefault:&localeError];
                    
                    
                    if (localeError)
                    {
                        NSLog(@"Error while loading Locale - %@", [localeError localizedDescription]);
                    }
                    
                }
                @catch (NSException *exception)
                {
                    NSLog(@"Exception %@", [exception reason]);
                }
                
            });
        }
        @catch (NSException *exception)
        {
            error = [NSError errorWithDomain: [[exception userInfo] objectForKey: @"domain"]
                                        code: [[[exception userInfo] objectForKey: @"code"] integerValue]
                                    userInfo: [NSDictionary dictionaryWithObject: [exception reason] forKey: NSLocalizedDescriptionKey]];
            self.gnManager  = nil;
            self.gnUser = nil;
        }
    }
    
    return error;
}

#pragma mark - Status Update Methods

- (void) setStatus:(NSString*)status showStatusPrefix:(BOOL)showStatusPrefix
{
    NSString *statusToDisplay;
    
    if (showStatusPrefix) {
        NSMutableString *mstr = [NSMutableString string];
        [mstr appendString:@"Status: "];
        [mstr appendString:status];
        statusToDisplay = [NSString stringWithString:mstr];
    } else {
        statusToDisplay = status;
    }
    
    self.statusLabel.text = statusToDisplay;
}

-(void) enableOrDisableControls:(BOOL) enable
{
//    self.tableView.userInteractionEnabled = enable;
//    self.tableView.scrollEnabled = enable;
    self.closeButton.enabled = !enable;
//    [self.tableView setHidden:enable];
    if ( enable ) {
        self.resultView.alpha = 0;
        if ( [self.results count] == 0 ) {
            [self startRecognition];
        }
        else if ( self.delegate ) {
            [self.delegate enableOrDisableControls:enable];
        }
    }
    else {
        self.resultView.alpha = 0.5;
    }
}

- (void)cancelAllOperations
{
    if ( [self.cancellableObjects count] > 0 ) {
        for(int i = 0; i < [self.cancellableObjects count]; i++ )
        {
            id obj = self.cancellableObjects[i];
            if([obj isKindOfClass:[GnMusicIdStream class]])
            {
                NSError *error = nil;
                [obj identifyCancel:&error];
                if(error)
                {
                    NSLog(@"MusicIDStream Cancel Error = %@", [error localizedDescription]);
                }
            }
            else if ([obj isKindOfClass:[GnMusicIdFile class]])
            {
                [obj cancel];
            }
            else
            {
                [obj setCancel:YES];
            }
        }
    }
    [self.microphone stopFetchingAudio];
    [self stopBusyIndicator];
}

- (NSString*)stringWithPercentEscape:(NSString*) refStr
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)refStr, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),kCFStringEncodingUTF8));
}

#pragma mark - Process Album Response

-(void) processAlbumResponseAndUpdateResultsTable:(id) responseAlbums
{
    id albums = nil;
    
    if([responseAlbums isKindOfClass:[GnResponseAlbums class]])
        albums = [responseAlbums albums];
    else
        albums = responseAlbums;
    
    for(GnAlbum* album in albums)
    {
        GnTrackEnumerator *tracksMatched  = [album tracksMatched];
        NSString *albumArtist = [[[album artist] name] display];
        NSString *albumTitle = [[album title] display];
        NSString *albumGenre = [album genre:kDataLevel_1] ;
        NSString *albumID = [NSString stringWithFormat:@"%@-%@", [album tui], [album tuiTag]];
        GnExternalId *externalID  =  nil;
        if ([album externalIds] && [[album externalIds] allObjects].count)
            externalID = (GnExternalId *) [[album externalIds] nextObject];
        
        NSString *albumXID = [externalID source];
        NSString *albumYear = [album year];
        NSString *albumTrackCount = [NSString stringWithFormat:@"%lu", (unsigned long)[album trackCount]];
        NSString *albumLanguage = [album language];
        
        /* Get CoverArt */
        GnContent *coverArtContent = [album coverArt];
        GnAsset *coverArtAsset = [coverArtContent asset:kImageSizeSmall];
        NSString *URLString = [NSString stringWithFormat:@"http://%@", [coverArtAsset url]];
        
        GnContent *artistImageContent = [[[album artist] contributor] image];
        GnAsset *artistImageAsset = [artistImageContent asset:kImageSizeSmall];
        NSString *artistImageURLString = [NSString stringWithFormat:@"http://%@", [artistImageAsset url]];
        
        GnContent *artistBiographyContent = [[[album artist] contributor] biography];
        NSString *artistBiographyURLString = [NSString stringWithFormat:@"http://%@", [[[artistBiographyContent assets] nextObject] url]];
        
        GnContent *albumReviewContent = [album review];
        NSString *albumReviewURLString = [NSString stringWithFormat:@"http://%@", [[[albumReviewContent assets] nextObject] url]];
        
        __block GnDataModel *gnDataModelObject = [[GnDataModel alloc] init];
        gnDataModelObject.albumArtist = albumArtist;
        gnDataModelObject.albumGenre = albumGenre;
        gnDataModelObject.albumID = albumID;
        gnDataModelObject.albumXID = albumXID;
        gnDataModelObject.albumYear = albumYear;
        gnDataModelObject.albumTitle = albumTitle;
        gnDataModelObject.albumTrackCount = albumTrackCount;
        gnDataModelObject.albumLanguage = albumLanguage;
        
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
//        __weak MusicRecognitionViewController *weakSelf = self;
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData* data, NSError* error)
         {
             
             if(data && !error)
             {
                 gnDataModelObject.albumImageData = data;
//                 [weakSelf.tableView reloadData];
             }
         }];
        
        NSURLRequest *artistImageFetchRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:artistImageURLString]];
        [NSURLConnection sendAsynchronousRequest:artistImageFetchRequest queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData* data, NSError* error){
            
            if(data && !error)
            {
                gnDataModelObject.artistImageData = data;
//                [weakSelf.tableView reloadData];
//                [self refreshArtistImage];
            }
        }];
        
        NSURLRequest *artistBiographyFetchRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:artistBiographyURLString]];
        [NSURLConnection sendAsynchronousRequest:artistBiographyFetchRequest queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData* data, NSError* error){
            
            if(data && !error)
            {
                gnDataModelObject.artistBiography = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
                
            }
        }];
        
        NSURLRequest *albumReviewFetchRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:albumReviewURLString]];
        [NSURLConnection sendAsynchronousRequest:albumReviewFetchRequest queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData* data, NSError* error){
            
            if(data && !error)
            {
                gnDataModelObject.albumReview = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
                
            }
        }];
        
        NSLog(@"Matched Album = %@", [[album title]display]);
        
        for(GnTrack *track in tracksMatched)
        {
            
            NSLog(@"  Matched Track = %@", [[track title]display]);
            
            NSString *trackArtist =  [[[track artist] name] display];
            NSString *trackMood = [track mood:kDataLevel_1] ;
            NSString *trackOrigin = [[[track artist] contributor] origin:kDataLevel_1];
            NSString *trackTempo = [track tempo:kDataLevel_1];
            NSString *trackGenre =  [track genre:kDataLevel_1];
            NSString *trackID =[NSString stringWithFormat:@"%@-%@", [track tui], [track tuiTag]];
            NSString *trackDuration = [NSString stringWithFormat:@"%lu",(unsigned long) ( [track duration]/1000)];
            NSString *currentPosition = [NSString stringWithFormat:@"%zu", (unsigned long) [track currentPosition]/1000];
            NSString *matchPosition = [NSString stringWithFormat:@"%zu", (unsigned long) [track matchPosition]/1000];
            
            
            if ([track externalIds] && [[track externalIds] allObjects].count)
                externalID = (GnExternalId *) [[track externalIds] nextObject];
            
            NSString *trackXID = [externalID source];
            NSString* trackNumber = [track trackNumber];
            NSString* trackTitle = [[track title] display];
            NSString* trackArtistType = [[[track artist] contributor] artistType:kDataLevel_1];
            
            //Allocate GnDataModel.
            gnDataModelObject.trackArtist = trackArtist;
            gnDataModelObject.trackMood = trackMood;
            gnDataModelObject.trackTempo = trackTempo;
            gnDataModelObject.trackOrigin = trackOrigin;
            gnDataModelObject.trackGenre = trackGenre;
            gnDataModelObject.trackID = trackID;
            gnDataModelObject.trackXID = trackXID;
            gnDataModelObject.trackNumber = trackNumber;
            gnDataModelObject.trackTitle = trackTitle;
            gnDataModelObject.trackArtistType = trackArtistType;
            gnDataModelObject.trackMatchPosition = matchPosition;
            gnDataModelObject.trackDuration = trackDuration;
            gnDataModelObject.currentPosition = currentPosition;
        }
        
        [self.results addObject:gnDataModelObject];
        
    }
    
    [self  performSelectorOnMainThread:@selector(refreshResults) withObject:nil waitUntilDone:NO];
    [self stopBusyIndicator];
    
    if ( self.results.count > 0 ) {
        [self performSelectorOnMainThread:@selector(showResult) withObject:nil waitUntilDone:YES];
    }
}

- (void) showResult {
    [self showResults:YES];
}
#pragma mark - Recording Interruptions

-(void) startRecording
{
    if (self.gnMusicIDStream)
    {
        NSError *error = nil;
        [self.gnMusicIDStream audioProcessStartWithAudioSource:self.gnMic error:&error];
        [self.microphone startFetchingAudio];
        
        NSLog(@"Error while starting audio Process %@", [error localizedDescription]);
    }
}

-(void) stopRecording
{
    NSError *error = nil;
    [self.gnMusicIDStream audioProcessStop:&error];
    [self.microphone stopFetchingAudio];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}


-(void) updateStatus: (NSString *)status
{
    //	The text view must be updated from the main thread or it throws an exception...
    dispatch_async( dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat: @"%@\n", status];
    });
}

-(void) stopBusyIndicator
{
//    dispatch_async( dispatch_get_main_queue(), ^{
//        
//        [self enableOrDisableControls:YES];
////        [self.busyIndicator stopAnimating];
////        [self.busyIndicator setHidden:YES];
//    });
}


#pragma mark - GnMusicIDStreamEventsDelegate Methods

-(void) musicIdStreamIdentifyingStatusEvent: (GnMusicIdStreamIdentifyingStatus)status cancellableDelegate: (id <GnCancellableDelegate>)canceller
{
    NSString *statusString = nil;
    
    switch (status)
    {
        case kStatusIdentifyingInvalid:
            statusString = @"Error";
            break;
            
        case kStatusIdentifyingStarted:
            statusString = @"Identifying";
            break;
            
        case kStatusIdentifyingFpGenerated:
            statusString = @"Fingerprint Generated";
            break;
            
        case kStatusIdentifyingLocalQueryStarted:
            statusString = @"Local Query Started";
//            self.lookupSourceIsLocal = 1;
            self.queryBeginTimeInterval = [[NSDate date] timeIntervalSince1970];
            break;
            
        case kStatusIdentifyingLocalQueryEnded:
            statusString = @"Local Query Ended";
//            self.lookupSourceIsLocal = 1;
            self.queryEndTimeInterval = [[NSDate date] timeIntervalSince1970];
            break;
            
        case kStatusIdentifyingOnlineQueryStarted:
            statusString = @"Online Query Started";
//            self.lookupSourceIsLocal = 0;
            break;
            
        case kStatusIdentifyingOnlineQueryEnded:
            statusString = @"Online Query Ended";
            self.queryEndTimeInterval = [[NSDate date] timeIntervalSince1970];
            break;
            
        case kStatusIdentifyingEnded:
            statusString = @"Identification Ended";
            break;
    }
    
    if (statusString)
    {
        /*	Don't update status unless we have something to show.	*/
        [self updateStatus: statusString];
    }
}

-(void) musicIdStreamProcessingStatusEvent: (GnMusicIdStreamProcessingStatus)status cancellableDelegate: (id <GnCancellableDelegate>)canceller
{
    switch (status)
    {
        case  kStatusProcessingInvalid:
            break;
        case   kStatusProcessingAudioNone:
            break;
        case kStatusProcessingAudioStarted:
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               self.audioProcessingStarted = YES;
                           });
            break;
        }
        case   kStatusProcessingAudioEnded:
            break;
        case  kStatusProcessingAudioSilence:
            break;
        case  kStatusProcessingAudioNoise:
            break;
        case kStatusProcessingAudioSpeech:
            break;
        case  kStatusProcessingAudioMusic:
            break;
        case  kStatusProcessingTransitionNone:
            break;
        case  kStatusProcessingTransitionChannelChange:
            break;
        case  kStatusProcessingTransitionContentToContent:
            break;
        case kStatusProcessingErrorNoClassifier:
            break;
    }
}

-(void) statusEvent: (GnStatus) status
    percentComplete: (NSUInteger)percentComplete
     bytesTotalSent: (NSUInteger) bytesTotalSent
 bytesTotalReceived: (NSUInteger) bytesTotalReceived
cancellableDelegate: (id <GnCancellableDelegate>) canceller
{
    NSString *statusString = nil;
    
    switch (status)
    {
        case kStatusUnknown:
            statusString = @"Status Unknown";
            break;
            
        case  kStatusBegin:
            statusString = @"Status Begin";
            break;
            
        case kStatusProgress:
            break;
            
        case  kStatusComplete:
            statusString = @"Status Complete";
            break;
            
        case kStatusErrorInfo:
            statusString = @"No Match";
            [self stopBusyIndicator];
            break;
            
        case kStatusConnecting:
            statusString = @"Status Connecting";
            break;
            
        case kStatusSending:
            statusString = @"Status Sending";
            break;
            
        case kStatusReceiving:
            statusString = @"Status Receiving";
            break;
            
        case kStatusDisconnected:
            statusString = @"Status Disconnected";
            break;
            
        case kStatusReading:
            statusString = @"Status Reading";
            break;
            
        case kStatusWriting:
            statusString = @"Status Writing";
            break;
            
        case kStatusCancelled:
            statusString = @"Status Cancelled";
            break;
    }
    
    [self updateStatus: [NSString stringWithFormat:@"%@ [%zu%%]", statusString?statusString:@"", (long)percentComplete]];
}

-(void) musicIdStreamAlbumResult: (GnResponseAlbums*)result cancellableDelegate: (id <GnCancellableDelegate>)canceller
{
    if ( [self.cancellableObjects containsObject:self.gnMusicIDStream] )
        [self.cancellableObjects removeObject:self.gnMusicIDStream];
    
//    if(self.cancellableObjects.count==0)
//    {
//        self.cancelOperationsButton.enabled = NO;
//    }
    
    [self stopBusyIndicator];
    [self processAlbumResponseAndUpdateResultsTable:result];
}

-(void) musicIdStreamIdentifyCompletedWithError: (NSError*)completeError
{
    NSString *statusString = [NSString stringWithFormat:@"%@ - [%zx]", [completeError localizedDescription], (long)[completeError code] ];
    
    if ( [self.cancellableObjects containsObject:self.gnMusicIDStream] )
        [self.cancellableObjects removeObject:self.gnMusicIDStream];
    
//    if(self.cancellableObjects.count==0)
//    {
//        self.cancelOperationsButton.enabled = NO;
//    }
    
    [self updateStatus: statusString];
    [self stopBusyIndicator];
}

-(BOOL) cancelIdentify
{
    return NO;
}

#pragma mark - Other Methods

- (void) showResults:(BOOL)isShowResult {
//    [self.tableView setHidden:!isShowResult];
//    [self.statusLabel setHidden:isShowResult];
//    [self.busyIndicator setHidden:isShowResult];
    if ( isShowResult ) {
        self.statusLabel.text = @"Finished";
        GnDataModel *model = self.results[0];
        if ( model.albumImageData ) {
            self.imageView.image = [UIImage imageWithData:model.albumImageData];
        }
        else {
            self.imageView.image = [UIImage imageNamed:@"placeholder"];
        }
        self.titleLabel.text = model.trackTitle ? model.trackTitle : model.albumTitle;
        self.descriptionLabel.text = model.trackArtist ? model.trackArtist : model.albumArtist;
        
        self.resultView.alpha = 0.8;
    }
    else {
        self.resultView.alpha = 0.0;
    }
    [self.audioPlot setHidden:isShowResult];
    
    if ( self.delegate ) {
        [self.delegate enableOrDisableControls:isShowResult];
    }
    
//    [self.tableView reloadData];
    
    [self.view setNeedsDisplay];
}

- (void)closeView {
    [self.view endEditing:YES];
    if ( self.delegate ) {
        [self.delegate closeMusicRecognition];
    }
}

- (void) selectedResult {
    if ( self.delegate && [self.results count] > 0 ) {
        GnDataModel *model = (GnDataModel*)self.results[0];
        [self.delegate selectedDataModel:model.trackTitle ? model.trackTitle : model.albumTitle];
    }
}

#pragma mark - MusicIdFileEventsDelegate Methods

-(void) musicIdFileAlbumResult: (GnResponseAlbums*)albumResult currentAlbum: (NSUInteger)currentAlbum totalAlbums: (NSUInteger)totalAlbums cancellableDelegate: (id <GnCancellableDelegate>)canceller
{
    [self processAlbumResponseAndUpdateResultsTable:albumResult];
}

-(void) refreshResults
{
    if (self.results.count==0)
    {
        [self updateStatus: @"No Match"];
    }
    else
    {
        [self updateStatus: [NSString stringWithFormat: @"Found %d", (int)self.results.count]];
    }
    
//    [self.busyIndicator stopAnimating];
}

-(void) gatherFingerprint: (GnMusicIdFileInfo*) fileInfo
              currentFile: (NSUInteger)currentFile
               totalFiles: (NSUInteger) totalFiles
      cancellableDelegate: (id <GnCancellableDelegate>) canceller
{
    NSError *error = nil;
    GnAudioFile *gnAudioFile = [[GnAudioFile alloc] initWithAudioFileURL:[NSURL URLWithString:[fileInfo identifier:&error]]];
    
    if(!error)
    {
        [fileInfo fingerprintFromSource:gnAudioFile error:&error];
        
        if(error)
        {
            NSLog(@"Fingerprint error - %@", [error localizedDescription]);
        }
    }
    else
        NSLog(@"GnAudioFile Error - %@", [error localizedDescription]);
    
}

-(void) musicIdFileComplete:(NSError*) completeError
{
    [self performSelectorOnMainThread:@selector(refreshResults) withObject:nil waitUntilDone:NO];
    
    // mechanism assumes app only has one GnMusicIdFile operation at a time, so it
    // can remove the GnMusicIdFile object is finds in the cancellable objects
    for(id obj in self.cancellableObjects)
    {
        if ([obj isKindOfClass:[GnMusicIdFile class]])
        {
            [self.cancellableObjects removeObject:obj];
            break;
        }
    }
    
    [self stopBusyIndicator];
    
}


-(void) musicIdFileMatchResult: (GnResponseDataMatches*)matchesResult currentAlbum: (NSUInteger)currentAlbum totalAlbums: (NSUInteger)totalAlbums cancellableDelegate: (id <GnCancellableDelegate>)canceller;

{
    GnDataMatchEnumerator *matches = [matchesResult dataMatches];
    
    for (GnDataMatch * match in matches)
    {
        if ([match isAlbum] == YES)
        {
            GnAlbum  * album       = [match getAsAlbum];
            if(!album)
                continue;
            
            [self.albumDataMatches addObject:album];
        }
    }
    
    if(currentAlbum>=totalAlbums)
        [self processAlbumResponseAndUpdateResultsTable:self.albumDataMatches];
    
    [self stopBusyIndicator];
}


-(void) musicIdFileResultNotFound: (GnMusicIdFileInfo*) fileinfo
                      currentFile: (NSUInteger) currentFile
                       totalFiles: (NSUInteger) totalFiles
              cancellableDelegate: (id <GnCancellableDelegate>) canceller
{
    [self updateStatus: @"No Match"];
}

-(void) gatherMetadata: (GnMusicIdFileInfo*) fileInfo
           currentFile: (NSUInteger) currentFile
            totalFiles: (NSUInteger) totalFiles
   cancellableDelegate: (id <GnCancellableDelegate>) canceller
{
    NSError *error = nil;
    NSString* filePath = [fileInfo identifier:&error];
    
    if (error)
    {
        NSLog(@"Error while retrieving filename %@ ", [error localizedDescription]);
    }
    else
    {
        AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:filePath]];
        if (asset)
        {
            NSString * supportedMetaDataFormatStr = AVMetadataFormatID3Metadata;
            
            for (NSString * metaDataFormatStr in [asset availableMetadataFormats] ) {
                if ([metaDataFormatStr isEqualToString:AVMetadataFormatiTunesMetadata] == YES)
                {
                    supportedMetaDataFormatStr = AVMetadataFormatiTunesMetadata;
                    break;
                }
                else if ([metaDataFormatStr isEqualToString:AVMetadataFormatID3Metadata] == YES)
                {
                    supportedMetaDataFormatStr = AVMetadataFormatID3Metadata;
                    break;
                }
                
            }
            
            NSArray *metadataArray =  [asset metadataForFormat:supportedMetaDataFormatStr];
            
            NSMutableString *metadataKeys = [NSMutableString stringWithFormat:@""];
            
            for(AVMetadataItem* item in metadataArray)
            {
                // NSLog(@"AVMetadataItem Key = %@ Value = %@",item.key, item.value );
                
                if([[item commonKey] isEqualToString:@"title"])
                {
                    [fileInfo trackTitleWithValue:(NSString*) [item value] error:nil];
                    [metadataKeys appendString: (NSString*)[item value]];
                    [metadataKeys appendString:@","];
                }
                else if([[item commonKey] isEqualToString:@"albumName"])
                {
                    [fileInfo albumTitleWithValue:(NSString*) [item value] error:nil];
                    [metadataKeys appendString: (NSString*)[item value]];
                    [metadataKeys appendString:@","];
                }
                else if([[item commonKey] isEqualToString:@"artist"])
                {
                    [fileInfo trackArtistWithValue:(NSString*) [item value] error:nil];
                    [metadataKeys appendString: (NSString*)[item value]];
                    [metadataKeys appendString:@","];
                }
            }
            
        }
    }
}

-(void) musicIdFileStatusEvent: (GnMusicIdFileInfo*) fileinfo
                        status: (GnMusicIdFileCallbackStatus) status
                   currentFile: (NSUInteger) currentFile
                    totalFiles: (NSUInteger) totalFiles
           cancellableDelegate: (id <GnCancellableDelegate>) canceller
{
    NSString *statusString = nil;
    
    switch (status)
    {
        case kMusicIdFileCallbackStatusProcessingBegin:
            statusString = @"Processing Begin";
            break;
        case kMusicIdFileCallbackStatusFileInfoQuery:
            statusString = @"File Info Query";
            break;
        case kMusicIdFileCallbackStatusProcessingComplete:
            statusString = @"Processing Complete";
            break;
        case kMusicIdFileCallbackStatusProcessingError:
            statusString = @"Processing Error";
            break;
        case kMusicIdFileCallbackStatusError:
            statusString = @"Error";
            break;
    }
    
    [self updateStatus: statusString];
}


#pragma mark - NavigationBar delegate methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}


#pragma mark - Application Notifications

-(void) applicationResignedActive:(NSNotification*) notification
{
    // to ensure no pending identifications deliver results while your app is
    // not active it is good practice to call cancel
    // it is safe to call identifyCancel if no identify is pending
    [self.gnMusicIDStream identifyCancel:NULL];
    
    // stopping audio processing while the app is inactive to release the
    // microphone for other apps to use
    [self stopRecording];
    [self.microphone stopFetchingAudio];
    dispatch_sync(self.internalQueue, ^
                  {
                      self.recordingIsPaused = YES;
                      
                  });
}

-(void) applicationDidBecomeActive:(NSNotification*) notification
{
    if(self.recordingIsPaused)
    {
        self.recordingIsPaused = NO;
        __block NSError *musicIDStreamError = nil;
        
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        dispatch_async(self.internalQueue, ^
                       {
                           [self.microphone startFetchingAudio];
                           [self.gnMusicIDStream audioProcessStartWithAudioSource:(id <GnAudioSourceDelegate>)self.gnAudioVisualizeAdapter error:&musicIDStreamError];
                           
                           if (musicIDStreamError)
                           {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                   NSLog(@"Error while starting Audio Process With AudioSource - %@", [musicIDStreamError localizedDescription]);
                               });
                           }
                       });
    }
}

#pragma mark - GnLogEventsDelegate Methods

-(BOOL) logMessage:(NSUInteger) packageId filterMask:(NSUInteger) filterMask errorCode:(NSUInteger) errorCode message:(NSString*) message
{
    NSString *debugString = [NSString stringWithFormat:@"Package Id:[%lu] filter Mask:[%lu] error Code: [%lu] Message:[%@]",(unsigned long)packageId, (unsigned long)filterMask, (unsigned long)errorCode, message];
    NSLog(@"%@", debugString);
    
    return YES;
}

#pragma mark - GnLookupLocalStreamIngestEventsDelegate

-(void) statusEvent: (GnLookupLocalStreamIngestStatus)status bundleId: (NSString*)bundleId cancellableDelegate: (id <GnCancellableDelegate>)canceller
{
    NSLog(@"status = %ld", (long)status);
}

@end
