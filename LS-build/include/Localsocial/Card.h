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
#import "Product.h"

@class RTSCard;

@interface RTSCard : NSObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * url_image;
@property (nonatomic, retain) RTSProduct * product;

@end


