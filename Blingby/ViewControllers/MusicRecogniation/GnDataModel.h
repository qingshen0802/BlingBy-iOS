//
//  GnDataModel.h
//  GN_Music_SDK_iOS
//
//  Copyright (c) 2013 Gracenote. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GnDataModel : NSObject

@property (strong) NSString *albumArtist;
@property (strong) NSString *albumGenre;
@property (strong) NSString *albumID;
@property (strong) NSString *albumXID;
@property (strong) NSString *albumYear;
@property (strong) NSString *albumTitle;
@property (strong) NSString *albumTrackCount;
@property (strong) NSString *albumLanguage;
@property (strong) NSString *albumReview;
@property (strong) NSData* albumImageData;
@property (strong) NSString* albumImageURLString;


@property (strong) NSString *trackArtist;
@property (strong) NSString *trackMood;
@property (strong) NSData* artistImageData;
@property (strong) NSString* artistImageURLString;
@property (strong) NSString *artistBiography;

@property (strong) NSString *currentPosition;
@property (strong) NSString *trackMatchPosition;	
@property (strong) NSString *trackDuration;
@property (strong) NSString *trackTempo;
@property (strong) NSString *trackOrigin;
@property (strong) NSString *trackGenre;
@property (strong) NSString *trackID;
@property (strong) NSString *trackXID;
@property (strong) NSString *trackNumber;
@property (strong) NSString *trackTitle;
@property (strong) NSString *trackArtistType;

-(void) startDownloadingImageFromURL:(NSURL*) imageURL;

@end
