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


@interface RTSConfiguration : NSObject

@property (nonatomic,retain)  NSString*      host;
@property (nonatomic,retain)  NSString*      host_api;
@property (nonatomic,retain)  NSString*      client_id;
@property (nonatomic,retain)  NSString*      client_secret;
@property (nonatomic,retain)  NSString*      app_callback;
@property (nonatomic,retain)  NSString*      merchant;

@property (nonatomic,readwrite)  unsigned int   range;                          // Range for nearby search (2km) - set to 0 for infinite
@property (nonatomic,readwrite)  unsigned int   scanlog_time;                   // Proximity status to be sent to the server (every 60s) - set to 0 to disable

@property (nonatomic,readwrite)  float          thresholdRefreshTime;
@property (nonatomic,readwrite)  float          thresholdRefreshDistance;

@property (nonatomic,readwrite)  unsigned int   place_ordering;
@property (nonatomic,readwrite)  unsigned int   shopzone_ordering;
@property (nonatomic,readwrite)  unsigned int   offer_ordering;

// 0 Alphabetical (By zone, then distance, then Alphabetical on the Place, Shopzone, RTSOffer)
// 1 Promotional  (By zone, then distance, then order items in each zone by its order or arrival in the zone)
// 2 Limited Promotional (By zone, then distance, then Promotional ordering for items in proximity (not when distance only))
// BQ TODO: replace with enum so can also use names for debugging
#define AlphabeticalOrdering        0
#define PromotionalOrdering         1
#define LimitedPromotionalOrdering  2


+(RTSConfiguration *)sharedInstance;
+(void)configChanged;

@end