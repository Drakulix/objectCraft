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

@class OFDataArray;

/*!
 * @brief A protocol implemented by classes that support encoding to a
 *	  MessagePack representation.
 */
@protocol OFMessagePackRepresentation
/*!
 * @brief Returns the MessagePack representation of the object as an
 *	  OFDataArray.
 *
 * @return The MessagePack representation of the object as an OFDataArray.
 */
- (OFDataArray*)messagePackRepresentation;
@end
