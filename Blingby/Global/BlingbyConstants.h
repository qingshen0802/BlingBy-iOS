//
//  BlingbyConstants.h
//  Blingby
//
//  Created by Simon Weingand on 13/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define iOS7_0 @"7.0"
#define IS_PAD                                      ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

#define CLIENTID @"9924864"
#define CLIENTIDTAG @"28AE3447022CD0EC5D6D107900ABC490"




#pragma mark - SharedInstance

#define USER_INFO           @"user_info"

#define ANIMATION_DURATION 0.5f


#pragma mark - LOGIN

#define BLINGBY_INPUTFIELD_FONT @"HelveticaNeue"
#define BLINGBY_INPUTFIELD_FONT_SIZE (IS_PAD ? 20 : 16)

#define LOGO_IMAGE_HEIGHT (IS_PAD ? 70 : 50)
#define CLOSE_BUTTON_FONT_SIZE (IS_PAD ? 30 : 24)
#define DESCRIPTION_FONT_SIZE (IS_PAD ? 24 : 18)
#define HORIZENTAL_MARGIN 40
#define TEXT_FIELD_WIDTH 400
#define TEXT_FIELD_HEIGHT (IS_PAD ? 44 : 32)
#define TEXT_FIELD_SPACE (IS_PAD ? 12 : 8)

#define CONTENT_TOP (LOGO_IMAGE_HEIGHT + (IS_PAD ? 100 : 70))






#pragma mark - Video Radio

#define kVideoRatio                     (16.0/9.0)

#define kSoundBarHeight                 70

#define kReuseLoadingIdentifier             @"LoadingCollectionViewCell"






#pragma mark - Colors

#define BLINGBY_COLOR1 UIColorFromRGB(0x0e1724)

#define BLINGBY_COLOR2 UIColorFromRGB(0x00ade3)
#define BLINGBY_COLOR3 UIColorFromRGB(0x5ac8e8)

#define BLINGBY_COLOR4 UIColorFromRGB(0x010530)
#define BLINGBY_COLOR5 UIColorFromRGB(0x000640)


#pragma mark - Navigation and Status Bar

#define STATUS_BAR_HEIGHT 20.0f

#define NAVIGATION_BAR_HEIGHT 44.0f
#define NAVIGATION_BAR_ICON_SIZE 20.0f
#define NAVIGATION_TINT_COLOR UIColorFromRGB(0x099ccc)
#define NAVIGATION_TITLE_FONT [UIFont fontWithName:@"BauhausStd-Medium" size:(IS_PAD ? 27 : 18)]

#define SEARCH_BAR_HEIGHT 44.0f

#define COLLECTIONVIEW_CELL_SPACE (IS_PAD ? 12 : 8)



#pragma mark - CoreData

#define kCoreDataEntityMedia            @"Media"
#define kCoreDataEntityItem             @"Item"
#define kCoreDataEntityProduct          @"Product"
#define kCoreDataEntityAffiliate        @"Affiliate"
#define kCoreDataEntityDestination      @"Destination"
#define kCoreDataEntityPerson           @"Person"
#define kCoreDataEntityImage            @"Image"

#pragma mark - APIS

#define kBlingbyHostUrl                 @"http://beta.blingby.com"
#define kPostLogin                      @"/api/user/login"


#pragma mark - AUTHENTICATION

#define kParamApplicationId             @"application_id"
#define kParamApplicationKey            @"application_key"
#define kParamIpHash                    @"ip_hash"

#pragma mark - Query Params

#define kQueryParamPage                 @"page"
#define kQueryParamItemsPerPage         @"items_per_page"

#pragma mark - Root Keys

#define kRootKeyMedias                  @"medias"
#define kRootKeyMediaDetails            @"mediaDetails"
#define kRootKeyItems                   @"items"
#define kRootKeyItemDetails             @"itemDetails"
#define kRootKeyProducts                @"products"
#define kRootKeyProductDetails          @"productDetails"
#define kRootKeyAffiliates              @"field_affiliate"
#define kRootKeyImages                  @"field_product_images"

#define kRootKeyPersons                 @"persons"
#define kRootKeyPersonDetails           @"personDetails"
#define kRootKeyDestinations            @"destinations"
#define kRootKeyDestinationDetails      @"destinationDetails"
#define kRootKeySearchResults           @"results.content"



#define kItemsPerPage                   50


#pragma mark - SEARCH
#define kGetSearchResult                @"/api/search/%@"

#pragma mark - MEDIA

#define kGetMedias                      @"/api/media"
#define kGetMediaDetails                @"/api/media/%d"
#define kGetMediaItems                  @"/api/media/%d/items?page_number=%d&items_per_page=%d"
#define kGetMediaQuery                  @"/api/media?search=%@"

#define kParamMediaId                   @"media_id"
#define kParamMediaTitle                @"title"
#define kParamMediaDescription          @"description"
#define kParamMediaType                 @"field_media_type"
#define kParamMediaSegment              @"field_segment"
#define kParamMediaOrigination          @"field_media_origination"
#define kParamMediaRecordLabel          @"field_record_label"
#define kParamMediaGenre                @"field_genre"
#define kParamMediaYear                 @"field_year"
#define kParamMediaTags                 @"field_tags"
#define kParamMediaEmotion              @"field_emotion"
#define kParamMediaYoutubeId            @"field_media_youtube_id"
#define kParamMediaVimeoId              @"field_media_vimeo_id"
#define kParamMediaArtistName           @"field_media_artist_name"
#define kParamMediaSubTitle             @"field_media_sub_title"
#define kParamMediaLength               @"field_media_length"

#define kParamItems                     @"items"


#pragma mark - ITEMS < MEDIA

#define kGetItemDetails                 @"/api/items/%d"
#define kGetItemProducts                @"/api/items/%d/products?page_number=%d&items_per_page=%d"

#define kParamItemId                    @"item_id"
#define kParamItemTitle                 @"title"
#define kParamItemMediaTimeStamp        @"field_media_time_stamp"
#define kParamItemCreativeDesc          @"field_item_creative_desc"
#define kParamItemExperienceText        @"field_item_experience_text"
#define kParamItemExperienceGroup       @"field_item_experience_group"
#define kParamItemProducts              @"field_item_products"
#define kParamItemDestination           @"field_destination"
#define kParamItemPerson                @"field_item_person"
#define kParamItemProducts              @"field_item_products"


#pragma mark - PRODUCTS

#define kGetProducts                    @"/api/products/?page_number=%d&items_per_page=%d"
#define kGetProductDetails              @"/api/products/%d"
#define kGetProductAffiliates           @"/api/items/%d/affiliates?page_number=%d&items_per_page=%d"
#define kGetProductQuery                @"/api/products/?search=%@&page_number=%d&items_per_page=%d"
#define kGetTopProducts                 @"/api/products/?top=%d&page_number=%d&items_per_page=%d"

#define kParamProductId                 @"product_id"
#define kParamProductTitle              @"title"
#define kParamProductUPC_SKU            @"field_product_upc_sku"
#define kParamProductStyleId            @"field_product_style_id"
#define kParamProductDescription        @"description"
#define kParamProductImages             @"field_product_images"
#define kParamProductAffiliate          @"field_affiliate"
#define kParamProductTags               @"field_tags"


#pragma mark - AFFILIATE

#define kGetAllAffiliates               @"/api/product/%d/affiliates"
#define kGetAffilateDetails             @"/api/affilate/%d"

#define kParamAffiliateId               @"affiliate_id"
#define kParamAffiliateTitle            @"title"
#define kParamAffiliateUrl              @"field_affiliate_url"
#define kParamAffiliateGyftId           @"field_affiliate_gyft_id"
#define kParamAffiliateType             @"field_affiliate_type"


#pragma mark - DESTINATION

#define kGetDestinations                @"/api/destinations"
#define kGetDestinationDetails          @"/api/destination/%d"

#define kParamDestinationId             @"destination_id"
#define kParamDestinationTitle          @"title"
#define kParamDestinationDescription    @"description"
#define kParamDestinationImages         @"field_destination_images"
#define kParamDestinationCoords         @"field_destination_coords"


#pragma mark - PERSON

#define kGetPersons                     @"/api/persons"
#define kGetPersonDetails               @"/api/person/%d"
#define kGetTopPeoples                  @"/api/people/?top=%d&page_number=%d&items_per_page=%d"

#define kParamPersonId                  @"person_id"
#define kParamPersonTitle               @"title"
#define kParamPersonDescription         @"description"
#define kParamPersonDestinationImages   @"field_destination_images"


#pragma mark - NOTIFICATION

#define kNotificationNavMenuButtonTapped @"navigation_bar_menu_tapped"
#define kNotificationPopularVideos      @"popular_videos"
#define kNotificationMediaItems         @"media_items"
#define kNotificationSetVideo           @"set_video"
#define kNotificationUpdateItems        @"update_items"
#define kNotificationProductDetialsOpened   @"product_details_opened"
#define kNotificationProductDetailsClosed   @"product_details_closed"
#define kNotificationProductChanged         @"product_changed"


#define kNotificationMediaDetails       @"media_details"

#define kNotificationLoggedIn           @"logged_in"
#define kNotificationLoggedOUt          @"looged_out"


#pragma mark - CollectionViewCell

#define kRecentCellCountperRow              1
#define kPopularVideoCellCountPerRow        (IS_PAD ? 3 : 1)
#define kItemCellCountPerRow                (IS_PAD ? 4 : 2)
#define kSavedAndSearchItemCellCountPerRow  (IS_PAD ? 2 : 1)
#define kPaddingForLabel                    8



#pragma mark - Recents

#define kRecentMedias                   @"recent_medias"
#define kRecentDestinations             @"recent_destinations"
#define kRecentPersons                  @"recent_persons"
#define kSavedItems                     @"saved_items"

#define kRecentMaxLimit                 3

#define kCollectionViewSectionHeaderHeight  (IS_PAD ? 50 : 35)
#define kCollectionViewSectionHeaderFont    ([UIFont fontWithName:@"HelveticaNeue" size:IS_PAD ? 20.0f : 14.0f])


@interface BlingbyConstants : NSObject

@end
