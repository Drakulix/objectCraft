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

#import "OFObject.h"

@class OFEnumerator;
@class OFArray;

/*!
 * @brief A protocol for getting an enumerator for the object.
 */
@protocol OFEnumerating
/*!
 * @brief Returns an OFEnumerator to enumerate through all objects of the
 *	  collection.
 *
 * @returns An OFEnumerator to enumerate through all objects of the collection
 */
- (OFEnumerator*)objectEnumerator;
@end

/*!
 * @brief A class which provides methods to enumerate through collections.
 */
@interface OFEnumerator: OFObject
/*!
 * @brief Returns the next object.
 *
 * @return The next object
 */
- (id)nextObject;

/*!
 * @brief Returns an array of all remaining objects in the collection.
 *
 * @return An array of all remaining objects in the collection
 */
- (OFArray*)allObjects;

/*!
 * @brief Resets the enumerator, so the next call to nextObject returns the
 *	  first object again.
 */
- (void)reset;
@end

/*
 * This needs to be exactly like this because it's hardcoded in the compiler.
 *
 * We need this bad check to see if we already imported Cocoa, which defines
 * this as well.
 */
#define of_fast_enumeration_state_t NSFastEnumerationState
#ifndef NSINTEGER_DEFINED
/*!
 * @brief State information for fast enumerations.
 */
typedef struct of_fast_enumeration_state_t {
	/// Arbitrary state information for the enumeration
	unsigned long state;
	/// Pointer to a C array of objects to return
	__unsafe_unretained id *itemsPtr;
	/// Arbitrary state information to detect mutations
	unsigned long *mutationsPtr;
	/// Additional arbitrary state information
	unsigned long extra[5];
} of_fast_enumeration_state_t;
#endif

/*!
 * @brief A protocol for fast enumeration.
 *
 * The OFFastEnumeration protocol needs to be implemented by all classes
 * supporting fast enumeration.
 */
@protocol OFFastEnumeration
/*!
 * @brief A method which is called by the code produced by the compiler when
 *	  doing a fast enumeration.
 *
 * @param state Context information for the enumeration
 * @param objects A pointer to an array where to put the objects
 * @param count The number of objects that can be stored at objects
 * @return The number of objects returned in objects or 0 when the enumeration
 *	   finished.
 */
- (int)countByEnumeratingWithState: (of_fast_enumeration_state_t*)state
			   objects: (__unsafe_unretained id*)objects
			     count: (int)count;
@end
