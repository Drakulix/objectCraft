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

#import "objfw-defs.h"

#ifndef __STDC_LIMIT_MACROS
# define __STDC_LIMIT_MACROS
#endif
#ifndef __STDC_CONSTANT_MACROS
# define __STDC_CONSTANT_MACROS
#endif

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <limits.h>

#ifdef OF_OBJFW_RUNTIME
# import "runtime.h"
#else
# import <objc/objc.h>
#endif

#ifdef OF_APPLE_RUNTIME
# import <objc/runtime.h>
# import <objc/message.h>
#endif

/*! @file */

#if defined(__GNUC__)
# define restrict __restrict__
#elif __STDC_VERSION__ < 199901L
# define restrict
#endif

#ifndef __has_feature
# define __has_feature(x) 0
#endif

#ifndef __has_attribute
# define __has_attribute(x) 0
#endif

#ifdef __GNUC__
# define __GCC_VERSION__ (__GNUC__ * 100 + __GNUC_MINOR__)
#else
# define __GCC_VERSION__ 0
#endif

#if defined(__clang__) || __GCC_VERSION__ >= 406 || defined(OBJC_NEW_PROPERTIES)
# define OF_HAVE_PROPERTIES
# define OF_HAVE_OPTIONAL_PROTOCOLS
# if defined(__clang__) || __GCC_VERSION__ >= 406 || defined(OF_APPLE_RUNTIME)
#  define OF_HAVE_FAST_ENUMERATION
# endif
# define OF_HAVE_CLASS_EXTENSIONS
#endif

#if !__has_feature(objc_instancetype)
# define instancetype id
#endif

#if __has_feature(blocks)
# define OF_HAVE_BLOCKS
#endif

#if __has_feature(objc_bool)
# undef YES
# define YES __objc_yes
# undef NO
# define NO __objc_no
# ifndef __cplusplus
#  undef true
#  define true ((bool)1)
#  undef false
#  define false ((bool)0)
# endif
#endif

#if defined(__clang__) || __GCC_VERSION__ >= 406
# define OF_SENTINEL __attribute__((sentinel))
#else
# define OF_SENTINEL
#endif

#if __has_attribute(objc_requires_super)
# define OF_REQUIRES_SUPER __attribute__((objc_requires_super))
#else
# define OF_REQUIRES_SUPER
#endif

#if __has_attribute(objc_root_class)
# define OF_ROOT_CLASS __attribute__((objc_root_class))
#else
# define OF_ROOT_CLASS
#endif

#ifdef OF_APPLE_RUNTIME
# if defined(__x86_64__) || defined(__i386__) || defined(__ARM64_ARCH_8__) || \
	defined(__arm__) || defined(__ppc__)
#  define OF_HAVE_FORWARDING_TARGET_FOR_SELECTOR
#  define OF_HAVE_FORWARDING_TARGET_FOR_SELECTOR_STRET
# endif
#else
# if defined(__ELF__)
#  if defined(__amd64__) || defined(__x86_64__) || defined(__i386__) || \
	defined(__arm__) || defined(__ARM__) || defined(__ppc__) || \
	defined(__PPC__)
#   define OF_HAVE_FORWARDING_TARGET_FOR_SELECTOR
#   if __OBJFW_RUNTIME_ABI__ >= 800
#    define OF_HAVE_FORWARDING_TARGET_FOR_SELECTOR_STRET
#   endif
#  endif
#  if (defined(_MIPS_SIM) && _MIPS_SIM == _ABIO32) || \
	(defined(__mips_eabi) && _MIPS_SZPTR == 32)
#   define OF_HAVE_FORWARDING_TARGET_FOR_SELECTOR
#   if __OBJFW_RUNTIME_ABI__ >= 800
#    define OF_HAVE_FORWARDING_TARGET_FOR_SELECTOR_STRET
#   endif
#  endif
# elif defined(_WIN32) && defined(__i386__)
#   define OF_HAVE_FORWARDING_TARGET_FOR_SELECTOR
#   if __OBJFW_RUNTIME_ABI__ >= 800
#    define OF_HAVE_FORWARDING_TARGET_FOR_SELECTOR_STRET
#   endif
# endif
#endif

#if __has_feature(objc_arc)
# define OF_RETURNS_RETAINED __attribute__((ns_returns_retained))
# define OF_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
# define OF_RETURNS_INNER_POINTER __attribute__((objc_returns_inner_pointer))
# define OF_CONSUMED __attribute__((ns_consumed))
# define OF_WEAK_UNAVAILABLE __attribute__((objc_arc_weak_unavailable))
#else
# define OF_RETURNS_RETAINED
# define OF_RETURNS_NOT_RETAINED
# define OF_RETURNS_INNER_POINTER
# define OF_CONSUMED
# define OF_WEAK_UNAVAILABLE
# define __unsafe_unretained
# define __bridge
# define __autoreleasing
#endif

#define OF_RETAIN_COUNT_MAX UINT_MAX
#define OF_NOT_FOUND SIZE_MAX

/*!
 * @brief A result of a comparison.
 */
typedef enum of_comparison_result_t {
	/*! The left object is smaller than the right */
	OF_ORDERED_ASCENDING = -1,
	/*! Both objects are equal */
	OF_ORDERED_SAME = 0,
	/*! The left object is bigger than the right */
	OF_ORDERED_DESCENDING = 1
} of_comparison_result_t;

/*!
 * @brief An enum for storing endianess.
 */
typedef enum of_byte_order_t {
	/*! Most significant byte first (big endian) */
	OF_BYTE_ORDER_BIG_ENDIAN,
	/*! Least significant byte first (little endian) */
	OF_BYTE_ORDER_LITTLE_ENDIAN
} of_byte_order_t;

/*!
 * @brief A range.
 */
typedef struct of_range_t {
	/*! The start of the range */
	size_t location;
	/*! The length of the range */
	size_t length;
} of_range_t;

/*!
 * @brief A time interval in seconds.
 */
typedef double of_time_interval_t;

/*!
 * @brief A point.
 */
typedef struct of_point_t {
	/*! The x coordinate of the point */
	float x;
	/*! The y coordinate of the point */
	float y;
} of_point_t;

/*!
 * @brief A dimension.
 */
typedef struct of_dimension_t {
	/*! The width of the dimension */
	float width;
	/*! The height of the dimension */
	float height;
} of_dimension_t;

/*!
 * @brief A rectangle.
 */
typedef struct of_rectangle_t
{
	/*! The point from where the rectangle originates */
	of_point_t origin;
	/*! The size of the rectangle */
	of_dimension_t size;
} of_rectangle_t;

@class OFString;
@class OFThread;

/*!
 * @brief The protocol which all root classes implement.
 */
@protocol OFObject
/*!
 * @brief Returns the class of the object.
 *
 * @return The class of the object
 */
- (Class)class;

/*!
 * @brief Returns the superclass of the object.
 *
 * @return The superclass of the object
 */
- (Class)superclass;

/*!
 * @brief Returns a boolean whether the object of the specified kind.
 *
 * @param class_ The class whose kind is checked
 * @return A boolean whether the object is of the specified kind
 */
- (bool)isKindOfClass: (Class)class_;

/*!
 * @brief Returns a boolean whether the object is a member of the specified
 *	  class.
 *
 * @param class_ The class for which the receiver is checked
 * @return A boolean whether the object is a member of the specified class
 */
- (bool)isMemberOfClass: (Class)class_;

/*!
 * @brief Returns a boolean whether the object responds to the specified
 *	  selector.
 *
 * @param selector The selector which should be checked for respondance
 * @return A boolean whether the objects responds to the specified selector
 */
- (bool)respondsToSelector: (SEL)selector;

/*!
 * @brief Checks whether the object conforms to the specified protocol.
 *
 * @param protocol The protocol which should be checked for conformance
 * @return A boolean whether the object conforms to the specified protocol
 */
- (bool)conformsToProtocol: (Protocol*)protocol;

/*!
 * @brief Returns the implementation for the specified selector.
 *
 * @param selector The selector for which the method should be returned
 * @return The implementation for the specified selector
 */
- (IMP)methodForSelector: (SEL)selector;

/*!
 * @brief Returns the type encoding for the specified selector.
 *
 * @param selector The selector for which the type encoding should be returned
 * @return The type encoding for the specified selector
 */
- (const char*)typeEncodingForSelector: (SEL)selector;

/*!
 * @brief Performs the specified selector.
 *
 * @param selector The selector to perform
 * @return The object returned by the method specified by the selector
 */
- (id)performSelector: (SEL)selector;

/*!
 * @brief Performs the specified selector with the specified object.
 *
 * @param selector The selector to perform
 * @param object The object that is passed to the method specified by the
 *		 selector
 * @return The object returned by the method specified by the selector
 */
- (id)performSelector: (SEL)selector
	   withObject: (id)object;

/*!
 * @brief Performs the specified selector with the specified objects.
 *
 * @param selector The selector to perform
 * @param object1 The first object that is passed to the method specified by the
 *		 selector
 * @param object2 The second object that is passed to the method specified by
 *		  the selector
 * @return The object returned by the method specified by the selector
 */
- (id)performSelector: (SEL)selector
	   withObject: (id)object1
	   withObject: (id)object2;

/*!
 * @brief Checks two objects for equality.
 *
 * Classes containing data (like strings, arrays, lists etc.) should reimplement
 * this!
 *
 * @warning If you reimplement this, you also need to reimplement @ref hash to
 *	    return the same hash for objects which are equal!
 *
 * @param object The object which should be tested for equality
 * @return A boolean whether the object is equal to the specified object
 */
- (bool)isEqual: (id)object;

/*!
 * @brief Calculates a hash for the object.
 *
 * Classes containing data (like strings, arrays, lists etc.) should reimplement
 * this!
 *
 * @warning If you reimplement this, you also need to reimplement @ref isEqual:
 *	    to behave in a way compatible to your reimplementation of this
 *	    method!
 *
 * @return A 32 bit hash for the object
 */
- (uint32_t)hash;

/*!
 * @brief Increases the retain count.
 *
 * Each time an object is released, the retain count gets decreased and the
 * object deallocated if it reaches 0.
 */
- retain;

/*!
 * @brief Returns the retain count.
 *
 * @return The retain count
 */
- (unsigned int)retainCount;

/*!
 * @brief Decreases the retain count.
 *
 * Each time an object is released, the retain count gets decreased and the
 * object deallocated if it reaches 0.
 */
- (void)release;

/*!
 * @brief Adds the object to the topmost OFAutoreleasePool of the thread's
 *	  autorelease pool stack.
 *
 * @return The object
 */
- autorelease;

/*!
 * @brief Returns the receiver.
 *
 * @return The receiver
 */
- self;

/*!
 * @brief Returns whether the object is a proxy object.
 *
 * @return A boolean whether the object is a proxy object
 */
- (bool)isProxy;
@end

/*!
 * @brief The root class for all other classes inside ObjFW.
 */
OF_ROOT_CLASS
@interface OFObject <OFObject>
{
@private
	Class _isa;
}

/*!
 * @brief A method which is called once when the class is loaded into the
 *	  runtime.
 *
 * Derived classes can overide this to execute their own code when the class is
 * loaded.
 */
+ (void)load;

/*!
 * @brief A method which is called the moment before the first call to the class
 *	  is being made.
 *
 * Derived classes can override this to execute their own code on
 * initialization. They should make sure to not execute any code if self is not
 * the class itself, as it might happen that the method was called for a
 * subclass which did not override this method.
 */
+ (void)initialize;

/*!
 * @brief Allocates memory for an instance of the class and sets up the memory
 *	  pool for the object.
 *
 * This method will never return nil, instead, it will throw an
 * OFAllocFailedException.
 *
 * @return The allocated object
 */
+ alloc;

/*!
 * @brief Allocates memory for a new instance and calls @ref init on it.
 * @return An allocated and initialized object
 */
+ new;

/*!
 * @brief Returns the class.
 *
 * @return The class
 */
+ (Class)class;

/*!
 * @brief Returns the name of the class as a string.
 *
 * @return The name of the class as a string
 */
+ (OFString*)className;

/*!
 * @brief Returns a boolean whether the class is a subclass of the specified
 *	  class.
 *
 * @param class_ The class which is checked for being a superclass
 * @return A boolean whether the class is a subclass of the specified class
 */
+ (bool)isSubclassOfClass: (Class)class_;

/*!
 * @brief Returns the superclass of the class.
 *
 * @return The superclass of the class
 */
+ (Class)superclass;

/*!
 * @brief Checks whether instances of the class respond to a given selector.
 *
 * @param selector The selector which should be checked for respondance
 * @return A boolean whether instances of the class respond to the specified
 *	   selector
 */
+ (bool)instancesRespondToSelector: (SEL)selector;

/*!
 * @brief Checks whether the class conforms to a given protocol.
 *
 * @param protocol The protocol which should be checked for conformance
 * @return A boolean whether the class conforms to the specified protocol
 */
+ (bool)conformsToProtocol: (Protocol*)protocol;

/*!
 * @brief Returns the implementation of the instance method for the specified
 *	  selector.
 *
 * @param selector The selector for which the method should be returned
 * @return The implementation of the instance method for the specified selector
 *	   or nil if it isn't implemented
 */
+ (IMP)instanceMethodForSelector: (SEL)selector;

/*!
 * @brief Returns the type encoding of the instance method for the specified
 *	  selector.
 *
 * @param selector The selector for which the type encoding should be returned
 * @return The type encoding of the instance method for the specified selector
 */
+ (const char*)typeEncodingForInstanceSelector: (SEL)selector;

/*!
 * @brief Returns a description for the class, which is usually the class name.
 *
 * This is mostly for debugging purposes.
 *
 * @return A description for the class, which is usually the class name
 */
+ (OFString*)description;

/*!
 * @brief Replaces a class method with a class method from another class.
 *
 * @param selector The selector of the class method to replace
 * @param class_ The class from which the new class method should be taken
 * @return The old implementation
 */
+ (IMP)replaceClassMethod: (SEL)selector
      withMethodFromClass: (Class)class_;

/*!
 * @brief Replaces an instance method with an instance method from another
 *	  class.
 *
 * @param selector The selector of the instance method to replace
 * @param class_ The class from which the new instance method should be taken
 * @return The old implementation
 */
+ (IMP)replaceInstanceMethod: (SEL)selector
	 withMethodFromClass: (Class)class_;

/*!
 * @brief Replaces or adds a class method.
 *
 * If the method already exists, it is replaced and the old implementation
 * returned. If the method does not exist, it is added with the specified type
 * encoding.
 *
 * @param selector The selector for the new method
 * @param implementation The implementation for the new method
 * @param typeEncoding The type encoding for the new method
 * @return The old implementation or nil if the method was added
 */
+ (IMP)replaceClassMethod: (SEL)selector
       withImplementation: (IMP)implementation
	     typeEncoding: (const char*)typeEncoding;

/*!
 * @brief Replaces or adds an instance method.
 *
 * If the method already exists, it is replaced and the old implementation
 * returned. If the method does not exist, it is added with the specified type
 * encoding.
 *
 * @param selector The selector for the new method
 * @param implementation The implementation for the new method
 * @param typeEncoding The type encoding for the new method
 * @return The old implementation or nil if the method was added
 */
+ (IMP)replaceInstanceMethod: (SEL)selector
	  withImplementation: (IMP)implementation
		typeEncoding: (const char*)typeEncoding;

/*!
 * @brief Adds all methods from the specified class to the class that is the
 *	  receiver.
 *
 * Methods implemented by the receiving class itself will not be overridden,
 * however methods implemented by its superclass will. Therefore it behaves
 * similar as if the specified class is the superclass of the receiver.
 *
 * All methods from the superclasses of the specified class will also be added.
 *
 * If the specified class is a superclass of the receiving class, nothing is
 * done.
 *
 * The methods which will be added from the specified class are not allowed to
 * use super or access instance variables, instead they have to use accessors.
 *
 * @param class_ The class from which the instance methods should be inherited
 */
+ (void)inheritMethodsFromClass: (Class)class_;

/*!
 * @brief Try to resolve the specified class method.
 *
 * This method is called if a class method was not found, so that an
 * implementation can be provided at runtime.
 *
 * @return Whether the method has been added to the class
 */
+ (bool)resolveClassMethod: (SEL)selector;

/*!
 * @brief Try to resolve the specified instance method.
 *
 * This method is called if an instance method was not found, so that an
 * implementation can be provided at runtime.
 *
 * @return Whether the method has been added to the class
 */
+ (bool)resolveInstanceMethod: (SEL)selector;

/*!
 * @brief Returns the class.
 *
 * This method exists so that classes can be used in collections requiring
 * conformance to the OFCopying protocol.
 *
 * @return The class of the object
 */
+ copy;

/*!
 * @brief Initializes an already allocated object.
 *
 * Derived classes may override this, but need to do
 * @code
 *   self = [super init]
 * @endcode
 * before they do any initialization themselves. @ref init may never return nil,
 * instead an exception (for example OFInitializationFailedException) should be
 * thrown.
 *
 * @return An initialized object
 */
- init;

/*!
 * @brief Returns the name of the object's class.
 *
 * @return The name of the object's class
 */
- (OFString*)className;

/*!
 * @brief Returns a description for the object.
 *
 * This is mostly for debugging purposes.
 *
 * @return A description for the object
 */
- (OFString*)description;

/*!
 * @brief Allocates memory and stores it in the object's memory pool.
 *
 * It will be free'd automatically when the object is deallocated.
 *
 * @param size The size of the memory to allocate
 * @return A pointer to the allocated memory
 */
- (void*)allocMemoryWithSize: (size_t)size;

/*!
 * @brief Allocates memory for the specified number of items and stores it in
 *	  the object's memory pool.
 *
 * It will be free'd automatically when the object is deallocated.
 *
 * @param size The size of each item to allocate
 * @param count The number of items to allocate
 * @return A pointer to the allocated memory
 */
- (void*)allocMemoryWithSize: (size_t)size
		       count: (size_t)count;

/*!
 * @brief Resizes memory in the object's memory pool to the specified size.
 *
 * If the pointer is NULL, this is equivalent to allocating memory.
 * If the size is 0, this is equivalent to freeing memory.
 *
 * @param pointer A pointer to the already allocated memory
 * @param size The new size for the memory chunk
 * @return A pointer to the resized memory chunk
 */
- (void*)resizeMemory: (void*)pointer
		 size: (size_t)size;

/*!
 * @brief Resizes memory in the object's memory pool to the specific number of
 *	  items of the specified size.
 *
 * If the pointer is NULL, this is equivalent to allocating memory.
 * If the size or number of items is 0, this is equivalent to freeing memory.
 *
 * @param pointer A pointer to the already allocated memory
 * @param size The size of each item to resize to
 * @param count The number of items to resize to
 * @return A pointer to the resized memory chunk
 */
- (void*)resizeMemory: (void*)pointer
		 size: (size_t)size
		count: (size_t)count;

/*!
 * @brief Frees allocated memory and removes it from the object's memory pool.
 *
 * Does nothing if the pointer is NULL.
 *
 * @param pointer A pointer to the allocated memory
 */
- (void)freeMemory: (void*)pointer;

/*!
 * @brief Deallocates the object.
 *
 * It is automatically called when the retain count reaches zero.
 *
 * This also frees all memory in its memory pool.
 */
- (void)dealloc;

/*!
 * @brief Performs the specified selector after the specified delay.
 *
 * @param selector The selector to perform
 * @param delay The delay after which the selector will be performed
 */
- (void)performSelector: (SEL)selector
	     afterDelay: (of_time_interval_t)delay;

/*!
 * @brief Performs the specified selector with the specified object after the
 *	  specified delay.
 *
 * @param selector The selector to perform
 * @param object The object that is passed to the method specified by the
 *		 selector
 * @param delay The delay after which the selector will be performed
 */
- (void)performSelector: (SEL)selector
	     withObject: (id)object
	     afterDelay: (of_time_interval_t)delay;

/*!
 * @brief Performs the specified selector with the specified objects after the
 *	  specified delay.
 *
 * @param selector The selector to perform
 * @param object1 The first object that is passed to the method specified by the
 *		 selector
 * @param object2 The second object that is passed to the method specified by
 *		  the selector
 * @param delay The delay after which the selector will be performed
 */
- (void)performSelector: (SEL)selector
	     withObject: (id)object1
	     withObject: (id)object2
	     afterDelay: (of_time_interval_t)delay;

#ifdef OF_HAVE_THREADS
/*!
 * @brief Performs the specified selector on the specified thread.
 *
 * @param selector The selector to perform
 * @param thread The thread on which to perform the selector
 * @param waitUntilDone Whether to wait until the perform finished
 */
- (void)performSelector: (SEL)selector
	       onThread: (OFThread*)thread
	  waitUntilDone: (bool)waitUntilDone;

/*!
 * @brief Performs the specified selector on the specified thread with the
 *	  specified object.
 *
 * @param selector The selector to perform
 * @param thread The thread on which to perform the selector
 * @param object The object that is passed to the method specified by the
 *		 selector
 * @param waitUntilDone Whether to wait until the perform finished
 */
- (void)performSelector: (SEL)selector
	       onThread: (OFThread*)thread
	     withObject: (id)object
	  waitUntilDone: (bool)waitUntilDone;

/*!
 * @brief Performs the specified selector on the specified thread with the
 *	  specified objects.
 *
 * @param selector The selector to perform
 * @param thread The thread on which to perform the selector
 * @param object1 The first object that is passed to the method specified by the
 *		 selector
 * @param object2 The second object that is passed to the method specified by
 *		  the selector
 * @param waitUntilDone Whether to wait until the perform finished
 */
- (void)performSelector: (SEL)selector
	       onThread: (OFThread*)thread
	     withObject: (id)object1
	     withObject: (id)object2
	  waitUntilDone: (bool)waitUntilDone;

/*!
 * @brief Performs the specified selector on the main thread.
 *
 * @param selector The selector to perform
 * @param waitUntilDone Whether to wait until the perform finished
 */
- (void)performSelectorOnMainThread: (SEL)selector
		      waitUntilDone: (bool)waitUntilDone;

/*!
 * @brief Performs the specified selector on the main thread with the specified
 *	  object.
 *
 * @param selector The selector to perform
 * @param object The object that is passed to the method specified by the
 *		 selector
 * @param waitUntilDone Whether to wait until the perform finished
 */
- (void)performSelectorOnMainThread: (SEL)selector
			 withObject: (id)object
		      waitUntilDone: (bool)waitUntilDone;

/*!
 * @brief Performs the specified selector on the main thread with the specified
 *	  objects.
 *
 * @param selector The selector to perform
 * @param object1 The first object that is passed to the method specified by the
 *		 selector
 * @param object2 The second object that is passed to the method specified by
 *		  the selector
 * @param waitUntilDone Whether to wait until the perform finished
 */
- (void)performSelectorOnMainThread: (SEL)selector
			 withObject: (id)object1
			 withObject: (id)object2
		      waitUntilDone: (bool)waitUntilDone;

/*!
 * @brief Performs the specified selector on the specified thread after the
 *	  specified delay.
 *
 * @param selector The selector to perform
 * @param thread The thread on which to perform the selector
 * @param delay The delay after which the selector will be performed
 */
- (void)performSelector: (SEL)selector
	       onThread: (OFThread*)thread
	     afterDelay: (of_time_interval_t)delay;

/*!
 * @brief Performs the specified selector on the specified thread with the
 *	  specified object after the specified delay.
 *
 * @param selector The selector to perform
 * @param thread The thread on which to perform the selector
 * @param object The object that is passed to the method specified by the
 *		 selector
 * @param delay The delay after which the selector will be performed
 */
- (void)performSelector: (SEL)selector
	       onThread: (OFThread*)thread
	     withObject: (id)object
	     afterDelay: (of_time_interval_t)delay;

/*!
 * @brief Performs the specified selector on the specified thread with the
 *	  specified objects after the specified delay.
 *
 * @param selector The selector to perform
 * @param thread The thread on which to perform the selector
 * @param object1 The first object that is passed to the method specified by the
 *		 selector
 * @param object2 The second object that is passed to the method specified by
 *		  the selector
 * @param delay The delay after which the selector will be performed
 */
- (void)performSelector: (SEL)selector
	       onThread: (OFThread*)thread
	     withObject: (id)object1
	     withObject: (id)object2
	     afterDelay: (of_time_interval_t)delay;
#endif

/*!
 * @brief This method is called when @ref resolveClassMethod: or
 *	  @ref resolveInstanceMethod: returned false. It should return a target
 *	  to which the message should be forwarded.
 *
 * @note When the message should not be forwarded, you should not return nil,
 *	 but instead return the result of the superclass!
 *
 * @return The target to forward the message to
 */
- (id)forwardingTargetForSelector: (SEL)selector;

/*!
 * @brief Handles messages which are not understood by the receiver.
 *
 * @warning If you override this method, you must make sure that it never
 *	    returns.
 *
 * @param selector The selector not understood by the receiver
 */
- (void)doesNotRecognizeSelector: (SEL)selector;
@end

/*!
 * @brief A protocol for the creation of copies.
 */
@protocol OFCopying
/*!
 * @brief Copies the object.
 *
 * For classes which can be immutable or mutable, this returns an immutable
 * copy. If only a mutable version of the class exists, it creates a mutable
 * copy.
 *
 * @return A copy of the object
 */
- copy;
@end

/*!
 * @brief A protocol for the creation of mutable copies.
 *
 * This protocol is implemented by objects that can be mutable and immutable
 * and allows returning a mutable copy.
 */
@protocol OFMutableCopying
/*!
 * @brief Creates a mutable copy of the object.
 *
 * @return A mutable copy of the object
 */
- mutableCopy;
@end

/*!
 * @brief A protocol for comparing objects.
 *
 * This protocol is implemented by objects that can be compared.
 */
@protocol OFComparing <OFObject>
/*!
 * @brief Compares the object with another object.
 *
 * @param object An object to compare the object to
 * @return The result of the comparison
 */
- (of_comparison_result_t)compare: (id <OFComparing>)object;
@end

#import "OFObject+Serialization.h"

#ifdef __cplusplus
extern "C" {
#endif
extern id of_alloc_object(Class class_, size_t extraSize, size_t extraAlignment,
    void **extra);
extern uint32_t of_hash_seed;
#ifdef __cplusplus
}
#endif
