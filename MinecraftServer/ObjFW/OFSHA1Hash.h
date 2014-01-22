/*
 * Copyright (c) 2008, 2009, 2010, 2011, 2012, 2013, 2014
 *   Jonathan Schleifer <js@webkeks.org>
 *
 * All rights reserved.
 *
 * This file is part of ObjFW. It may be distributed under the terms of the
 * Q Public License 1.0, which can be found in the file LICENSE.QPL included in
 * the packaging of this file.
 *
 * Alternatively, it may be distributed under the terms of the GNU General
 * Public License, either version 2 or 3, which can be found in the file
 * LICENSE.GPLv2 or LICENSE.GPLv3 respectively included in the packaging of this
 * file.
 */

#import "OFHash.h"

/*!
 * @brief A class which provides functions to create an SHA1 hash.
 */
@interface OFSHA1Hash: OFObject <OFHash>
{
	uint32_t _state[5];
	uint64_t _count;
	char	 _buffer[64];
	uint8_t	 _digest[20];
	bool	 _calculated;
}
@end
