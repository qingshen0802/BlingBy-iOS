//
//  GnDataModel.m
//  GN_Music_SDK_iOS
//
//  Copyright (c) 2013 Gracenote. All rights reserved.
//

#import "GnDataModel.h"

@implementation GnDataModel

-(void) startDownloadingImageFromURL:(NSURL*) imageURL
{
     if(imageURL)
     {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
         
           self.albumImageData = [NSData dataWithContentsOfURL:imageURL];
         
         });
         
     }
}

@end
