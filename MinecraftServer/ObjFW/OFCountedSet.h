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

#import "OFSet.h"

/*! @file */

#ifdef OF_HAVE_BLOCKS
/*!
 * @brief A block for enumerating an OFCountedSet.
 *
 * @param object The current object
 * @param count The count of the object
 * @param stop A pointer to a variable that can be set to true to stop the
 *	       enumeration
 */
typedef void (^of_counted_set_enumeration_block_t)(id object, size_t count,
    bool *stop);
#endif

/*!
 * @brief An abstract class for a mutable unordered set of objects, counting how
 *	  often it contains an object.
 */
@interface OFCountedSet: OFMutableSet
/*!
 * @brief Returns how often the object is in the set.
 *
 * @return How often the object is in the set
 */
- (size_t)countForObject: (id)object;

#ifdef OF_HAVE_BLOCKS
/*!
 * @brief Executes a block for each object in the set.
 *
 * @param block The block to execute for each object in the set
 */
- (void)enumerateObjectsAndCountUsingBlock:
    (of_counted_set_enumeration_block_t)block;
#endif
@end
