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

#include <errno.h>

#import "OFException.h"

/*!
 * @brief An exception indicating a file couldn't be opened.
 */
@interface OFOpenFileFailedException: OFException
{
	OFString *_path, *_mode;
	int _errNo;
}

#ifdef OF_HAVE_PROPERTIES
@property (readonly, copy) OFString *path, *mode;
@property (readonly) int errNo;
#endif

/*!
 * @brief Creates a new, autoreleased open file failed exception.
 *
 * @param path A string with the path of the file tried to open
 * @param mode A string with the mode in which the file should have been opened
 * @return A new, autoreleased open file failed exception
 */
+ (instancetype)exceptionWithPath: (OFString*)path
			     mode: (OFString*)mode;

/*!
 * @brief Initializes an already allocated open file failed exception.
 *
 * @param path A string with the path of the file which couldn't be opened
 * @param mode A string with the mode in which the file should have been opened
 * @return An initialized open file failed exception
 */
- initWithPath: (OFString*)path
	  mode: (OFString*)mode;

/*!
 * @brief Returns a string with the path of the file which couldn't be opened.
 *
 * @return A string with the path of the file which couldn't be opened
 */
- (OFString*)path;

/*!
 * @brief Returns a string with the mode in which the file should have been
 *	  opened.
 *
 * @return A string with the mode in which the file should have been opened
 */
- (OFString*)mode;

/*!
 * @brief Returns the errno from when the exception was created.
 *
 * @return The errno from when the exception was created
 */
- (int)errNo;
@end
