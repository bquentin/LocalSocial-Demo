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

@class RTSCoupon;

@interface RTSCoupon : NSObject

@property (nonatomic,retain) NSString    *uuid;
@property (nonatomic,retain) NSString    *code;
@property (nonatomic,retain) NSDate      *redeemed_at;
@property (nonatomic,retain) NSDate      *expires_at;
@property (nonatomic,retain) NSString    *offer_uuid;
@property (nonatomic,retain) NSString    *offer_image;
@property (nonatomic,retain) NSString    *offer_name;
@property (nonatomic,retain) NSString    *offer_location;
@property (nonatomic,retain) NSString    *offer_description;

@end
