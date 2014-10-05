/*
 * Copyright (c) 2001 - 2011 Rococo Software Ltd., 3 Lincoln Place,
 * Dublin 2 Ireland. All Rights Reserved.
 *
 * This software is distributed under licenses restricting its use,
 * copying, distribution, and decompilation. No part of this
 * software may be reproduced in any form by any means without prior
 * written authorization of Rococo Software Ltd. and its licensors, if
 * any.
 *
 * This software is the confidential and proprietary information
 * of Rococo Software Ltd. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms of
 * the license agreement you entered into with Rococo Software Ltd.
 * Use is subject to license terms.
 *
 * Rococo Software Ltd. has intellectual property rights relating
 * to the technology embodied in this software. In particular, and
 * without limitation, these intellectual property rights may include
 * one or more patents, or pending patent applications.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "RSConfiguration.h"

#import "Place.h"
#import "Shopzone.h"
#import "Offer.h"
#import "Radio.h"
#import "Coupon.h"
#import "Product.h"
#import "Card.h"

typedef enum {
    RS_OK,
    RS_IN_PROGRESS,
    RS_ERROR,
    RS_ERROR_CACHE_MODE,
    RS_ERROR_NETWORK,
    RS_ERROR_REQUIRE_USER_REGISTRATION
} RSStatus;

typedef enum {
    LSServiceTwitter,
    LSServiceFacebook,
    LSServiceGoogle,
    LSServiceLocalsocial
} LSService;

typedef void(^RSURLConnectionHandler)(BOOL success, NSError* error, id response);

// The RSNetworkDidStartNotification will happen before a remote call is made to the server
#define RSNetworkDidStartNotification       @"RSNetworkDidStartNotification"

// The RSNetworkDidFinishNotification will happend after a remote call is returned by the server
// It will include the mode (type of call "register" or "discover") and may include errors:
// Error code 0 Error in contacting the server
#define RSNetworkDidFinishNotification      @"RSNetworkDidFinishNotification"

#define RSLocationDidChangeNotification     @"RSLocationDidChangeNotification"
#define RSObjectsDidUpdateNotification      @"RSObjectsDidUpdateNotification"
#define RSAllObjectsDidUpdateNotification   @"RSAllObjectsDidUpdateNotification"

// RSWelcomeNoticeNotification will happen when a place's welcome message is "found" and should be displayed.
// UserInfo contains a NSDictionary with the @"message" to be displayed
#define RSWelcomeNoticeNotification         @"RSWelcomeNoticeNotification"
// RSAwardNoticeNotification will happen when a place's points are successfully collected. UserInfo
// contains a NSDictionary with the @"place" @"points" to be displayed
#define RSAwardNoticeNotification          @"RSAwardNoticeNotification"

#define RSProfileStartUpdateNotification    @"RSProfileStartUpdateNotification"
#define RSProfileDidUpdateNotification      @"RSProfileDidUpdateNotification"

@interface RTSLocalsocial : NSObject {}

-(RTSLocalsocial *)init;
+(RTSLocalsocial *)sharedInstance;

// App Registration: A remote call to authenticate the current application to the server.
// Associated notification
-(RSStatus)appRegister;

// Associated notification RSProfileStartUpdateNotification | RSProfileDidUpdateNotification
-(RSStatus)appRegisterUserWithLocalsocial:(id)navCtrl;

// Discover POI (locations and their offers, shopzones...) around based on the location
-(RSStatus)discoverNearby;
-(RSStatus)discoverNearbyNoCache;

// Fetch Data which has been saved locally
-(NSArray *)getNearbyPlaces;
-(NSArray *)getNearbyOffers;
-(NSArray *)getShopzonesForPlace:(RTSPlace *)place;

-(NSArray *)getOffersForPlace:(RTSPlace *)place;
-(NSArray *)getOffersForShopzone:(RTSShopzone *)shopzone;

-(NSArray *)getProductsForPlace:(RTSPlace *)place;
-(NSArray *)getProductsForShopzone:(RTSShopzone *)shopzone;

-(NSArray *)getRadios;
-(NSArray *)getRadiosForPlace: (RTSPlace *)place;
-(NSArray *)getRadiosForShopzone:(RTSShopzone *)shopzone;

-(NSArray *)getCoupons;
-(NSArray *)getAwardStatus;

// Reload the given object including its model dependencies
-(RTSCoupon *)getCouponForOffer:(RTSOffer *)offer;
-(RTSPlace *)queryPlace: (RTSPlace *)place;
-(RTSShopzone *)queryShopzone: (RTSShopzone *)Shopzone;
-(RTSOffer *)queryOffer: (RTSOffer *)Offer;
-(RTSCoupon *)queryCoupon: (RTSCoupon *)Coupon;
-(RTSProduct *)queryProduct: (RTSProduct *)Product;

// Status control
-(BOOL)isAppRegistered;
-(BOOL)isUserRegistered;
-(BOOL)hasLocationService;
-(CLLocation *)getUserLocation;

-(void)willTerminate;
-(void)updateSettings;

-(NSDictionary *)getVersion;

// User only
-(NSDictionary *)getCurrentUser;

// User only - Remote calls to be performed on any offer that is an "offer"
-(RSStatus)redeemOffer:(RTSOffer *) offer withCompletion:(RSURLConnectionHandler)completion;

-(RSStatus)dislikeEntity:(NSObject *)entity withCompletion:(RSURLConnectionHandler)completion;
-(RSStatus)likeEntity:(NSObject *)entity withCompletion:(RSURLConnectionHandler)completion;

-(RSStatus)saveEntity:(NSObject *)entity withCompletion:(RSURLConnectionHandler)completion;
-(RSStatus)unsaveEntity:(NSObject *)entity withCompletion:(RSURLConnectionHandler)completion;

// User only - Remote call to share a string of information with the registered social network in param
-(RSStatus)share:(NSString *)message viaService:(LSService)service withCompletion:(RSURLConnectionHandler)completion;

// User only - Remote call for user managenement
-(RSStatus)refreshUserProfileWithCompletion:(RSURLConnectionHandler)completion;
-(RSStatus)refreshUserCouponsWithCompletion:(RSURLConnectionHandler)completion;
-(RSStatus)refreshUserAwardsWithCompletion:(RSURLConnectionHandler)completion;

-(RSStatus)currentUserUpdate:(NSDictionary *)data withCompletion:(RSURLConnectionHandler)completion;
-(RSStatus)currentUserLogoutWithCompletion:(RSURLConnectionHandler)completion;

// Clear all content including registration
-(void)resetAll;
@end

