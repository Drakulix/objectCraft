//
//  AdvancedFile.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 12.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@protocol OFFileProxy <OFObject>
@optional
/*!
 * @brief Creates a new OFFile with the specified path and mode.
 *
 * @param path The path to the file to open as a string
 * @param mode The mode in which the file should be opened.@n
 *	       Possible modes are:
 *	       Mode           | Description
 *	       ---------------|-------------------------------------
 *	       `r`            | read-only
 *	       `rb`           | read-only, binary
 *	       `r+`           | read-write
 *	       `rb+` or `r+b` | read-write, binary
 *	       `w`            | write-only, create, truncate
 *	       `wb`           | write-only, create, truncate, binary
 *	       `w`            | read-write, create, truncate
 *	       `wb+` or `w+b` | read-write, create, truncate, binary
 *	       `a`            | write-only, create, append
 *	       `ab`           | write-only, create, append, binary
 *	       `a+`           | read-write, create, append
 *	       `ab+` or `a+b` | read-write, create, append, binary
 * @return A new autoreleased OFFile
 */
+ (instancetype)fileWithPath: (OFString*)path
                        mode: (OFString*)mode;

/*!
 * @brief Creates a new OFFile with the specified file descriptor.
 *
 * @param fd A file descriptor, returned from for example open().
 *	     It is not closed when the OFFile object is deallocated!
 * @return A new autoreleased OFFile
 */
+ (instancetype)fileWithFileDescriptor: (int)fd;

/*!
 * @brief Returns the path fo the current working directory.
 *
 * @return The path of the current working directory
 */
+ (OFString*)currentDirectoryPath;

/*!
 * @brief Checks whether a file exists at the specified path.
 *
 * @param path The path to check
 * @return A boolean whether there is a file at the specified path
 */
+ (bool)fileExistsAtPath: (OFString*)path;

/*!
 * @brief Checks whether a directory exists at the specified path.
 *
 * @param path The path to check
 * @return A boolean whether there is a directory at the specified path
 */
+ (bool)directoryExistsAtPath: (OFString*)path;

#ifdef OF_HAVE_SYMLINK
/*!
 * @brief Checks whether a symbolic link exists at the specified path.
 *
 * @param path The path to check
 * @return A boolean whether there is a symbolic link at the specified path
 */
+ (bool)symbolicLinkExistsAtPath: (OFString*)path;
#endif

/*!
 * @brief Creates a directory at the specified path.
 *
 * @param path The path of the directory
 */
+ (void)createDirectoryAtPath: (OFString*)path;

/*!
 * @brief Creates a directory at the specified path.
 *
 * @param path The path of the directory
 * @param createParents Whether to create the parents of the directory
 */
+ (void)createDirectoryAtPath: (OFString*)path
                createParents: (bool)createParents;

/*!
 * @brief Returns an array with the items in the specified directory.
 *
 * @param path The path to the directory whose items should be returned
 * @return An array of OFStrings with the items in the specified directory
 */
+ (OFArray*)contentsOfDirectoryAtPath: (OFString*)path;

/*!
 * @brief Changes the current working directory.
 *
 * @param path The new directory to change to
 */
+ (void)changeCurrentDirectoryPath: (OFString*)path;

/*!
 * @brief Returns the size of the specified file.
 *
 * @return The size of the specified file
 */
+ (off_t)sizeOfFileAtPath: (OFString*)path;

/*!
 * @brief Returns the date of the last modification of the file.
 *
 * @return The date of the last modification of the file
 */
+ (OFDate*)modificationDateOfFileAtPath: (OFString*)path;

#ifdef OF_HAVE_CHMOD
/*!
 * @brief Changes the permissions of an item.
 *
 * This method only changes the read-only flag on Windows.
 *
 * @param path The path to the item whose permissions should be changed
 * @param permissions The new permissions for the item
 */
+ (void)changePermissionsOfItemAtPath: (OFString*)path
                          permissions: (mode_t)permissions;
#endif

#ifdef OF_HAVE_CHOWN
/*!
 * @brief Changes the owner of an item.
 *
 * This method is not available on some systems, most notably Windows.
 *
 * @param path The path to the item whose owner should be changed
 * @param owner The new owner for the item
 * @param group The new group for the item
 */
+ (void)changeOwnerOfItemAtPath: (OFString*)path
                          owner: (OFString*)owner
                          group: (OFString*)group;
#endif

/*!
 * @brief Copies a file, directory or symlink (if supported by the OS).
 *
 * The destination path must be a full path, which means it must include the
 * name of the item.
 *
 * If an item already exists, the copy operation fails. This is also the case
 * if a directory is copied and an item already exists in the destination
 * directory.
 *
 * @param source The file, directory or symlink to copy
 * @param destination The destination path
 */
+ (void)copyItemAtPath: (OFString*)source
                toPath: (OFString*)destination;

/*!
 * @brief Moves an item.
 *
 * The destination path must be a full path, which means it must include the
 * name of the item.
 *
 * If the destination is on a different logical device, the source will be
 * copied to the destination using @ref copyItemAtPath:toPath: and the source
 * removed using @ref removeItemAtPath:.
 *
 * @param source The item to rename
 * @param destination The new name for the item
 */
+ (void)moveItemAtPath: (OFString*)source
                toPath: (OFString*)destination;

/*!
 * @brief Removes the item at the specified path.
 *
 * If the item at the specified path is a directory, it is removed recursively.
 *
 * @param path The path to the item which should be removed
 */
+ (void)removeItemAtPath: (OFString*)path;

#ifdef OF_HAVE_LINK
/*!
 * @brief Creates a hard link for the specified item.
 *
 * The destination path must be a full path, which means it must include the
 * name of the item.
 *
 * This method is not available on some systems, most notably Windows.
 *
 * @param source The path of the item for which a link should be created
 * @param destination The path of the item which should link to the source
 */
+ (void)linkItemAtPath: (OFString*)source
                toPath: (OFString*)destination;
#endif

#ifdef OF_HAVE_SYMLINK
/*!
 * @brief Creates a symbolic link for an item.
 *
 * The destination path must be a full path, which means it must include the
 * name of the item.
 *
 * This method is not available on some systems, most notably Windows.
 *
 * @param destination The path of the item which should symbolically link to the
 *		      source
 * @param source The path of the item for which a symbolic link should be
 *		 created
 */
+ (void)createSymbolicLinkAtPath: (OFString*)destination
             withDestinationPath: (OFString*)source;

/*!
 * @brief Returns the destination of the symbolic link at the specified path.
 *
 * @param path The path to the symbolic link
 * @return The destination of the symbolic link at the specified path
 */
+ (OFString*)destinationOfSymbolicLinkAtPath: (OFString*)path;
#endif

/*!
 * @brief Initializes an already allocated OFFile.
 *
 * @param path The path to the file to open as a string
 * @param mode The mode in which the file should be opened.@n
 *	       Possible modes are:
 *	       Mode           | Description
 *	       ---------------|-------------------------------------
 *	       `r`            | read-only
 *	       `rb`           | read-only, binary
 *	       `r+`           | read-write
 *	       `rb+` or `r+b` | read-write, binary
 *	       `w`            | write-only, create, truncate
 *	       `wb`           | write-only, create, truncate, binary
 *	       `w`            | read-write, create, truncate
 *	       `wb+` or `w+b` | read-write, create, truncate, binary
 *	       `a`            | write-only, create, append
 *	       `ab`           | write-only, create, append, binary
 *	       `a+`           | read-write, create, append
 *	       `ab+` or `a+b` | read-write, create, append, binary
 * @return An initialized OFFile
 */
- initWithPath: (OFString*)path
          mode: (OFString*)mode;

/*!
 * @brief Initializes an already allocated OFFile.
 *
 * @param fd A file descriptor, returned from for example open().
 *	     It is not closed when the OFFile object is deallocated!
 */
- initWithFileDescriptor: (int)fd;

/*!
 * @brief Seeks to the specified absolute offset.
 *
 * @param offset The offset in bytes
 * @param whence From where to seek.@n
 *		 Possible values are:
 *		 Value      | Description
 *		 -----------|---------------------------------------
 *		 `SEEK_SET` | Seek to the specified byte
 *		 `SEEK_CUR` | Seek to the current location + offset
 *		 `SEEK_END` | Seek to the end of the stream + offset
 * @return The new offset form the start of the file
 */
- (off_t)seekToOffset: (off_t)offset
               whence: (int)whence;

/*!
 * @brief Seek the stream on the lowlevel.
 *
 * @warning Do not call this directly!
 *
 * Override this with this method with your actual seek implementation when
 * subclassing!
 *
 * @param offset The offset to seek to
 * @param whence From where to seek.@n
 *		 Possible values are:
 *		 Value      | Description
 *		 -----------|---------------------------------------
 *		 `SEEK_SET` | Seek to the specified byte
 *		 `SEEK_CUR` | Seek to the current location + offset
 *		 `SEEK_END` | Seek to the end of the stream + offset
 * @return The new offset from the start of the file
 */
- (off_t)lowlevelSeekToOffset: (off_t)offset
                       whence: (int)whence;

/*!
 * @brief Returns a boolean whether the end of the stream has been reached.
 *
 * @return A boolean whether the end of the stream has been reached
 */
- (bool)isAtEndOfStream;

/*!
 * @brief Reads *at most* size bytes from the stream into a buffer.
 *
 * On network streams, this might read less than the specified number of bytes.
 * If you want to read exactly the specified number of bytes, use
 * @ref readIntoBuffer:exactLength:. Note that a read can even return 0 bytes -
 * this does not necessarily mean that the stream ended, so you still need to
 * check @ref isAtEndOfStream.
 *
 * @param buffer The buffer into which the data is read
 * @param length The length of the data that should be read at most.
 *		 The buffer *must* be *at least* this big!
 * @return The number of bytes read
 */
- (size_t)readIntoBuffer: (void*)buffer
                  length: (size_t)length;

/*!
 * @brief Reads exactly the specified length bytes from the stream into a
 *	  buffer.
 *
 * Unlike @ref readIntoBuffer:length:, this method does not return when less
 * than the specified length has been read - instead, it waits until it got
 * exactly the specified length.
 *
 * @warning Only call this when you know that specified amount of data is
 *	    available! Otherwise you will get an exception!
 *
 * @param buffer The buffer into which the data is read
 * @param length The length of the data that should be read.
 *		 The buffer *must* be *at least* this big!
 */
- (void)readIntoBuffer: (void*)buffer
           exactLength: (size_t)length;

#ifdef OF_HAVE_SOCKETS
/*!
 * @brief Asyncronously reads *at most* size bytes from the stream into a
 *	  buffer.
 *
 * On network streams, this might read less than the specified number of bytes.
 * If you want to read exactly the specified number of bytes, use
 * @ref asyncReadIntoBuffer:exactLength:block:. Note that a read can even
 * return 0 bytes - this does not necessarily mean that the stream ended, so
 * you still need to check @ref isAtEndOfStream.
 *
 * @note The stream must implement @ref fileDescriptorForReading and return a
 *	 valid file descriptor in order for this to work!
 *
 * @param buffer The buffer into which the data is read.
 *		 The buffer must not be free'd before the async read completed!
 * @param length The length of the data that should be read at most.
 *		 The buffer *must* be *at least* this big!
 * @param target The target on which the selector should be called when the
 *		 data has been received. If the method returns true, it will be
 *		 called again with the same buffer and maximum length when more
 *		 data has been received. If you want the next method in the
 *		 queue to handle the data received next, you need to return
 *		 false from the method.
 * @param selector The selector to call on the target. The signature must be
 *		   `bool (OFStream *stream, void *buffer, size_t size,
 *		   OFException *exception)`.
 */
- (void)asyncReadIntoBuffer: (void*)buffer
                     length: (size_t)length
                     target: (id)target
                   selector: (SEL)selector;

/*!
 * @brief Asyncronously reads exactly the specified length bytes from the
 *	  stream into a buffer.
 *
 * Unlike @ref asyncReadIntoBuffer:length:target:selector:, this method does
 * not call the method when less than the specified length has been read -
 * instead, it waits until it got exactly the specified length, the stream has
 * ended or an exception occurred.
 *
 * @note The stream must implement @ref fileDescriptorForReading and return a
 *	 valid file descriptor in order for this to work!
 *
 * @param buffer The buffer into which the data is read
 * @param length The length of the data that should be read.
 *		 The buffer *must* be *at least* this big!
 * @param target The target on which the selector should be called when the
 *		 data has been received. If the method returns true, it will be
 *		 called again with the same buffer and exact length when more
 *		 data has been received. If you want the next method in the
 *		 queue to handle the data received next, you need to return
 *		 false from the method.
 * @param selector The selector to call on the target. The signature must be
 *		   `bool (OFStream *stream, void *buffer, size_t size,
 *		   OFException *exception)`.
 */
- (void)asyncReadIntoBuffer: (void*)buffer
                exactLength: (size_t)length
                     target: (id)target
                   selector: (SEL)selector;

# ifdef OF_HAVE_BLOCKS
/*!
 * @brief Asyncronously reads *at most* ref size bytes from the stream into a
 *	  buffer.
 *
 * On network streams, this might read less than the specified number of bytes.
 * If you want to read exactly the specified number of bytes, use
 * @ref asyncReadIntoBuffer:exactLength:block:. Note that a read can even
 * return 0 bytes - this does not necessarily mean that the stream ended, so
 * you still need to check @ref isAtEndOfStream.
 *
 * @note The stream must implement @ref fileDescriptorForReading and return a
 *	 valid file descriptor in order for this to work!
 *
 * @param buffer The buffer into which the data is read.
 *		 The buffer must not be free'd before the async read completed!
 * @param length The length of the data that should be read at most.
 *		 The buffer *must* be *at least* this big!
 * @param block The block to call when the data has been received.
 *		If the block returns true, it will be called again with the same
 *		buffer and maximum length when more data has been received. If
 *		you want the next block in the queue to handle the data
 *		received next, you need to return false from the block.
 */
- (void)asyncReadIntoBuffer: (void*)buffer
                     length: (size_t)length
                      block: (of_stream_async_read_block_t)block;

/*!
 * @brief Asyncronously reads exactly the specified length bytes from the
 *	  stream into a buffer.
 *
 * Unlike @ref asyncReadIntoBuffer:length:block:, this method does not invoke
 * the block when less than the specified length has been read - instead, it
 * waits until it got exactly the specified length, the stream has ended or an
 * exception occurred.
 *
 * @note The stream must implement @ref fileDescriptorForReading and return a
 *	 valid file descriptor in order for this to work!
 *
 * @param buffer The buffer into which the data is read
 * @param length The length of the data that should be read.
 *		 The buffer *must* be *at least* this big!
 * @param block The block to call when the data has been received.
 *		If the block returns true, it will be called again with the same
 *		buffer and exact length when more data has been received. If
 *		you want the next block in the queue to handle the data
 *		received next, you need to return false from the block.
 */
- (void)asyncReadIntoBuffer: (void*)buffer
                exactLength: (size_t)length
                      block: (of_stream_async_read_block_t)block;
# endif
#endif

/*!
 * @brief Reads a uint8_t from the stream.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @return A uint8_t from the stream
 */
- (uint8_t)readInt8;

/*!
 * @brief Reads a uint16_t from the stream which is encoded in big endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @return A uint16_t from the stream in native endianess
 */
- (uint16_t)readBigEndianInt16;

/*!
 * @brief Reads a uint32_t from the stream which is encoded in big endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @return A uint32_t from the stream in the native endianess
 */
- (uint32_t)readBigEndianInt32;

/*!
 * @brief Reads a uint64_t from the stream which is encoded in big endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @return A uint64_t from the stream in the native endianess
 */
- (uint64_t)readBigEndianInt64;

/*!
 * @brief Reads a float from the stream which is encoded in big endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @return A float from the stream in the native endianess
 */
- (float)readBigEndianFloat;

/*!
 * @brief Reads a double from the stream which is encoded in big endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @return A double from the stream in the native endianess
 */
- (double)readBigEndianDouble;

/*!
 * @brief Reads the specified number of uint16_ts from the stream which are
 *	  encoded in big endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param buffer A buffer of sufficient size to store the specified number of
 *		 uint16_ts
 * @param count The number of uint16_ts to read
 * @return The number of bytes read
 */
- (size_t)readBigEndianInt16sIntoBuffer: (uint16_t*)buffer
                                  count: (size_t)count;

/*!
 * @brief Reads the specified number of uint32_ts from the stream which are
 *	  encoded in big endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param buffer A buffer of sufficient size to store the specified number of
 *		 uint32_ts
 * @param count The number of uint32_ts to read
 * @return The number of bytes read
 */
- (size_t)readBigEndianInt32sIntoBuffer: (uint32_t*)buffer
                                  count: (size_t)count;

/*!
 * @brief Reads the specified number of uint64_ts from the stream which are
 *	  encoded in big endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param buffer A buffer of sufficient size to store the specified number of
 *		 uint64_ts
 * @param count The number of uint64_ts to read
 * @return The number of bytes read
 */
- (size_t)readBigEndianInt64sIntoBuffer: (uint64_t*)buffer
                                  count: (size_t)count;

/*!
 * @brief Reads the specified number of floats from the stream which are encoded
 *	  in big endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param buffer A buffer of sufficient size to store the specified number of
 *		 floats
 * @param count The number of floats to read
 * @return The number of bytes read
 */
- (size_t)readBigEndianFloatsIntoBuffer: (float*)buffer
                                  count: (size_t)count;

/*!
 * @brief Reads the specified number of doubles from the stream which are
 *	  encoded in big endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param buffer A buffer of sufficient size to store the specified number of
 *		 doubles
 * @param count The number of doubles to read
 * @return The number of bytes read
 */
- (size_t)readBigEndianDoublesIntoBuffer: (double*)buffer
                                   count: (size_t)count;

/*!
 * @brief Reads a uint16_t from the stream which is encoded in little endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @return A uint16_t from the stream in native endianess
 */
- (uint16_t)readLittleEndianInt16;

/*!
 * @brief Reads a uint32_t from the stream which is encoded in little endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @return A uint32_t from the stream in the native endianess
 */
- (uint32_t)readLittleEndianInt32;

/*!
 * @brief Reads a uint64_t from the stream which is encoded in little endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @return A uint64_t from the stream in the native endianess
 */
- (uint64_t)readLittleEndianInt64;

/*!
 * @brief Reads a float from the stream which is encoded in little endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @return A float from the stream in the native endianess
 */
- (float)readLittleEndianFloat;

/*!
 * @brief Reads a double from the stream which is encoded in little endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @return A double from the stream in the native endianess
 */
- (double)readLittleEndianDouble;

/*!
 * @brief Reads the specified number of uint16_ts from the stream which are
 *	  encoded in little endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param buffer A buffer of sufficient size to store the specified number of
 *		 uint16_ts
 * @param count The number of uint16_ts to read
 * @return The number of bytes read
 */
- (size_t)readLittleEndianInt16sIntoBuffer: (uint16_t*)buffer
                                     count: (size_t)count;

/*!
 * @brief Reads the specified number of uint32_ts from the stream which are
 *	  encoded in little endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param buffer A buffer of sufficient size to store the specified number of
 *		 uint32_ts
 * @param count The number of uint32_ts to read
 * @return The number of bytes read
 */
- (size_t)readLittleEndianInt32sIntoBuffer: (uint32_t*)buffer
                                     count: (size_t)count;

/*!
 * @brief Reads the specified number of uint64_ts from the stream which are
 *	  encoded in little endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param buffer A buffer of sufficient size to store the specified number of
 *		 uint64_ts
 * @param count The number of uint64_ts to read
 * @return The number of bytes read
 */
- (size_t)readLittleEndianInt64sIntoBuffer: (uint64_t*)buffer
                                     count: (size_t)count;

/*!
 * @brief Reads the specified number of floats from the stream which are
 *	  encoded in little endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param buffer A buffer of sufficient size to store the specified number of
 *		 floats
 * @param count The number of floats to read
 * @return The number of bytes read
 */
- (size_t)readLittleEndianFloatsIntoBuffer: (float*)buffer
                                     count: (size_t)count;

/*!
 * @brief Reads the specified number of doubles from the stream which are
 *	  encoded in little endian.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param buffer A buffer of sufficient size to store the specified number of
 *		 doubles
 * @param count The number of doubles to read
 * @return The number of bytes read
 */
- (size_t)readLittleEndianDoublesIntoBuffer: (double*)buffer
                                      count: (size_t)count;

/*!
 * @brief Reads the specified number of items with an item size of 1 from the
 *	  stream and returns them in an OFDataArray.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param count The number of items to read
 * @return An OFDataArray with count items.
 */
- (OFDataArray*)readDataArrayWithCount: (size_t)count;

/*!
 * @brief Reads the specified number of items with the specified item size from
 *	  the stream and returns them in an OFDataArray.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param itemSize The size of each item
 * @param count The number of items to read
 * @return An OFDataArray with count items.
 */
- (OFDataArray*)readDataArrayWithItemSize: (size_t)itemSize
                                    count: (size_t)count;

/*!
 * @brief Returns an OFDataArray with all the remaining data of the stream.
 *
 * @return An OFDataArray with an item size of 1 with all the data of the
 *	   stream until the end of the stream is reached.
 */
- (OFDataArray*)readDataArrayTillEndOfStream;

/*!
 * @brief Reads a string with the specified length from the stream.
 *
 * If a \\0 appears in the stream, the string will be truncated at the \\0 and
 * the rest of the bytes of the string will be lost. This way, reading from the
 * stream will not break because of a \\0 because the specified number of bytes
 * is still being read and only the string gets truncated.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param length The length (in bytes) of the string to read from the stream
 * @return A string with the specified length
 */
- (OFString*)readStringWithLength: (size_t)length;

/*!
 * @brief Reads a string with the specified encoding and length from the stream.
 *
 * If a \\0 appears in the stream, the string will be truncated at the \\0 and
 * the rest of the bytes of the string will be lost. This way, reading from the
 * stream will not break because of a \\0 because the specified number of bytes
 * is still being read and only the string gets truncated.
 *
 * @warning Only call this when you know that enough data is available!
 *	    Otherwise you will get an exception!
 *
 * @param encoding The encoding of the string to read from the stream
 * @param length The length (in bytes) of the string to read from the stream
 * @return A string with the specified length
 */
- (OFString*)readStringWithLength: (size_t)length
                         encoding: (of_string_encoding_t)encoding;

/*!
 * @brief Reads until a newline, \\0 or end of stream occurs.
 *
 * @return The line that was read, autoreleased, or nil if the end of the
 *	   stream has been reached.
 */
- (OFString*)readLine;

/*!
 * @brief Reads with the specified encoding until a newline, \\0 or end of
 *	  stream occurs.
 *
 * @param encoding The encoding used by the stream
 * @return The line that was read, autoreleased, or nil if the end of the
 *	   stream has been reached.
 */
- (OFString*)readLineWithEncoding: (of_string_encoding_t)encoding;

#ifdef OF_HAVE_SOCKETS
/*!
 * @brief Asyncronously reads until a newline, \\0, end of stream or an
 *	  exception occurs.
 *
 * @note The stream must implement @ref fileDescriptorForReading and return a
 *	 valid file descriptor in order for this to work!
 *
 * @param target The target on which to call the selector when the data has
 *		 been received. If the method returns true, it will be called
 *		 again when the next line has been received. If you want the
 *		 next method in the queue to handle the next line, you need to
 *		 return false from the method
 * @param selector The selector to call on the target. The signature must be
 *		   `bool (OFStream *stream, OFString *line,
 *		   OFException *exception)`.
 */
- (void)asyncReadLineWithTarget: (id)target
                       selector: (SEL)selector;

/*!
 * @brief Asyncronously reads with the specified encoding until a newline, \\0,
 *	  end of stream or an exception occurs.
 *
 * @note The stream must implement @ref fileDescriptorForReading and return a
 *	 valid file descriptor in order for this to work!
 *
 * @param encoding The encoding used by the stream
 * @param target The target on which to call the selector when the data has
 *		 been received. If the method returns true, it will be called
 *		 again when the next line has been received. If you want the
 *		 next method in the queue to handle the next line, you need to
 *		 return false from the method
 * @param selector The selector to call on the target. The signature must be
 *		   `bool (OFStream *stream, OFString *line,
 *		   OFException *exception)`.
 */
- (void)asyncReadLineWithEncoding: (of_string_encoding_t)encoding
                           target: (id)target
                         selector: (SEL)selector;

# ifdef OF_HAVE_BLOCKS
/*!
 * @brief Asyncronously reads until a newline, \\0, end of stream or an
 *	  exception occurs.
 *
 * @note The stream must implement @ref fileDescriptorForReading and return a
 *	 valid file descriptor in order for this to work!
 *
 * @param block The block to call when the data has been received.
 *		If the block returns true, it will be called again when the next
 *		line has been received. If you want the next block in the queue
 *		to handle the next line, you need to return false from the
 *		block.
 */
- (void)asyncReadLineWithBlock: (of_stream_async_read_line_block_t)block;

/*!
 * @brief Asyncronously reads with the specified encoding until a newline, \\0,
 *	  end of stream or an exception occurs.
 *
 * @note The stream must implement @ref fileDescriptorForReading and return a
 *	 valid file descriptor in order for this to work!
 *
 * @param encoding The encoding used by the stream
 * @param block The block to call when the data has been received.
 *		If the block returns true, it will be called again when the next
 *		line has been received. If you want the next block in the queue
 *		to handle the next line, you need to return false from the
 *		block.
 */
- (void)asyncReadLineWithEncoding: (of_string_encoding_t)encoding
                            block: (of_stream_async_read_line_block_t)block;
# endif
#endif

/*!
 * @brief Tries to read a line from the stream (see readLine) and returns nil if
 *	  no complete line has been received yet.
 *
 * @return The line that was read, autoreleased, or nil if the line is not
 *	   complete yet
 */
- (OFString*)tryReadLine;

/*!
 * @brief Tries to read a line from the stream with the specified encoding (see
 *	  @ref readLineWithEncoding:) and returns nil if no complete line has
 *	  been received yet.
 *
 * @param encoding The encoding used by the stream
 * @return The line that was read, autoreleased, or nil if the line is not
 *	   complete yet
 */
- (OFString*)tryReadLineWithEncoding: (of_string_encoding_t)encoding;

/*!
 * @brief Reads until the specified string or \\0 is found or the end of stream
 *	  occurs.
 *
 * @param delimiter The delimiter
 * @return The line that was read, autoreleased, or nil if the end of the
 *	   stream has been reached.
 */
- (OFString*)readTillDelimiter: (OFString*)delimiter;

/*!
 * @brief Reads until the specified string or \\0 is found or the end of stream
 *	  occurs.
 *
 * @param delimiter The delimiter
 * @param encoding The encoding used by the stream
 * @return The line that was read, autoreleased, or nil if the end of the
 *	   stream has been reached.
 */
- (OFString*)readTillDelimiter: (OFString*)delimiter
                      encoding: (of_string_encoding_t)encoding;

/*!
 * @brief Tries to reads until the specified string or \\0 is found or the end
 *	  of stream (see @ref readTillDelimiter:) and returns nil if not enough
 *	  data has been received yet.
 *
 * @param delimiter The delimiter
 * @return The line that was read, autoreleased, or nil if the end of the
 *	   stream has been reached.
 */
- (OFString*)tryReadTillDelimiter: (OFString*)delimiter;

/*!
 * @brief Tries to read until the specified string or \\0 is found or the end
 *	  of stream occurs (see @ref readTillDelimiter:encoding:) and
 *	  returns nil if not enough data has been received yet.
 *
 * @param delimiter The delimiter
 * @param encoding The encoding used by the stream
 * @return The line that was read, autoreleased, or nil if the end of the
 *	   stream has been reached.
 */
- (OFString*)tryReadTillDelimiter: (OFString*)delimiter
                         encoding: (of_string_encoding_t)encoding;

/*!
 * @brief Returns a boolen whether writes are buffered.
 *
 * @return A boolean whether writes are buffered
 */
- (bool)isWriteBufferEnabled;

/*!
 * @brief Enables or disables the write buffer.
 *
 * @param enable Whether the write buffer should be enabled or disabled
 */
- (void)setWriteBufferEnabled: (bool)enable;

/*!
 * @brief Writes everythig in the write buffer to the stream.
 */
- (void)flushWriteBuffer;

/*!
 * @brief Writes from a buffer into the stream.
 *
 * @param buffer The buffer from which the data is written to the stream
 * @param length The length of the data that should be written
 */
- (void)writeBuffer: (const void*)buffer
             length: (size_t)length;

/*!
 * @brief Writes a uint8_t into the stream.
 *
 * @param int8 A uint8_t
 */
- (void)writeInt8: (uint8_t)int8;

/*!
 * @brief Writes a uint16_t into the stream, encoded in big endian.
 *
 * @param int16 A uint16_t
 */
- (void)writeBigEndianInt16: (uint16_t)int16;

/*!
 * @brief Writes a uint32_t into the stream, encoded in big endian.
 *
 * @param int32 A uint32_t
 */
- (void)writeBigEndianInt32: (uint32_t)int32;

/*!
 * @brief Writes a uint64_t into the stream, encoded in big endian.
 *
 * @param int64 A uint64_t
 */
- (void)writeBigEndianInt64: (uint64_t)int64;

/*!
 * @brief Writes a float into the stream, encoded in big endian.
 *
 * @param float_ A float
 */
- (void)writeBigEndianFloat: (float)float_;

/*!
 * @brief Writes a double into the stream, encoded in big endian.
 *
 * @param double_ A double
 */
- (void)writeBigEndianDouble: (double)double_;

/*!
 * @brief Writes the specified number of uint16_ts into the stream, encoded in
 *	  big endian.
 *
 * @param buffer The buffer from which the data is written to the stream after
 *		 it has been byte swapped if necessary
 * @param count The number of uint16_ts to write
 * @return The number of bytes written to the stream
 */
- (size_t)writeBigEndianInt16s: (const uint16_t*)buffer
                         count: (size_t)count;

/*!
 * @brief Writes the specified number of uint32_ts into the stream, encoded in
 *	  big endian.
 *
 * @param buffer The buffer from which the data is written to the stream after
 *		 it has been byte swapped if necessary
 * @param count The number of uint32_ts to write
 * @return The number of bytes written to the stream
 */
- (size_t)writeBigEndianInt32s: (const uint32_t*)buffer
                         count: (size_t)count;

/*!
 * @brief Writes the specified number of uint64_ts into the stream, encoded in
 *	  big endian.
 *
 * @param buffer The buffer from which the data is written to the stream after
 *		 it has been byte swapped if necessary
 * @param count The number of uint64_ts to write
 * @return The number of bytes written to the stream
 */
- (size_t)writeBigEndianInt64s: (const uint64_t*)buffer
                         count: (size_t)count;

/*!
 * @brief Writes the specified number of floats into the stream, encoded in big
 *	  endian.
 *
 * @param buffer The buffer from which the data is written to the stream after
 *		 it has been byte swapped if necessary
 * @param count The number of floats to write
 * @return The number of bytes written to the stream
 */
- (size_t)writeBigEndianFloats: (const float*)buffer
                         count: (size_t)count;

/*!
 * @brief Writes the specified number of doubles into the stream, encoded in
 *	  big endian.
 *
 * @param buffer The buffer from which the data is written to the stream after
 *		 it has been byte swapped if necessary
 * @param count The number of doubles to write
 * @return The number of bytes written to the stream
 */
- (size_t)writeBigEndianDoubles: (const double*)buffer
                          count: (size_t)count;

/*!
 * @brief Writes a uint16_t into the stream, encoded in little endian.
 *
 * @param int16 A uint16_t
 */
- (void)writeLittleEndianInt16: (uint16_t)int16;

/*!
 * @brief Writes a uint32_t into the stream, encoded in little endian.
 *
 * @param int32 A uint32_t
 */
- (void)writeLittleEndianInt32: (uint32_t)int32;

/*!
 * @brief Writes a uint64_t into the stream, encoded in little endian.
 *
 * @param int64 A uint64_t
 */
- (void)writeLittleEndianInt64: (uint64_t)int64;

/*!
 * @brief Writes a float into the stream, encoded in little endian.
 *
 * @param float_ A float
 */
- (void)writeLittleEndianFloat: (float)float_;

/*!
 * @brief Writes a double into the stream, encoded in little endian.
 *
 * @param double_ A double
 */
- (void)writeLittleEndianDouble: (double)double_;

/*!
 * @brief Writes the specified number of uint16_ts into the stream, encoded in
 *	  little endian.
 *
 * @param buffer The buffer from which the data is written to the stream after
 *		 it has been byte swapped if necessary
 * @param count The number of uint16_ts to write
 * @return The number of bytes written to the stream
 */
- (size_t)writeLittleEndianInt16s: (const uint16_t*)buffer
                            count: (size_t)count;

/*!
 * @brief Writes the specified number of uint32_ts into the stream, encoded in
 *	  little endian.
 *
 * @param count The number of uint32_ts to write
 * @param buffer The buffer from which the data is written to the stream after
 *		 it has been byte swapped if necessary
 * @return The number of bytes written to the stream
 */
- (size_t)writeLittleEndianInt32s: (const uint32_t*)buffer
                            count: (size_t)count;

/*!
 * @brief Writes the specified number of uint64_ts into the stream, encoded in
 *	  little endian.
 *
 * @param buffer The buffer from which the data is written to the stream after
 *		 it has been byte swapped if necessary
 * @param count The number of uint64_ts to write
 * @return The number of bytes written to the stream
 */
- (size_t)writeLittleEndianInt64s: (const uint64_t*)buffer
                            count: (size_t)count;

/*!
 * @brief Writes the specified number of floats into the stream, encoded in
 *	  little endian.
 *
 * @param buffer The buffer from which the data is written to the stream after
 *		 it has been byte swapped if necessary
 * @param count The number of floats to write
 * @return The number of bytes written to the stream
 */
- (size_t)writeLittleEndianFloats: (const float*)buffer
                            count: (size_t)count;

/*!
 * @brief Writes the specified number of doubles into the stream, encoded in
 *	  little endian.
 *
 * @param buffer The buffer from which the data is written to the stream after
 *		 it has been byte swapped if necessary
 * @param count The number of doubles to write
 * @return The number of bytes written to the stream
 */
- (size_t)writeLittleEndianDoubles: (const double*)buffer
                             count: (size_t)count;

/*!
 * @brief Writes from an OFDataArray into the stream.
 *
 * @param dataArray The OFDataArray to write into the stream
 * @return The number of bytes written
 */
- (size_t)writeDataArray: (OFDataArray*)dataArray;

/*!
 * @brief Writes a string into the stream, without the trailing zero.
 *
 * @param string The string from which the data is written to the stream
 * @return The number of bytes written
 */
- (size_t)writeString: (OFString*)string;

/*!
 * @brief Writes a string into the stream in the specified encoding, without
 *	  the trailing zero.
 *
 * @param string The string from which the data is written to the stream
 * @param encoding The encoding in which to write the string to the stream
 * @return The number of bytes written
 */
- (size_t)writeString: (OFString*)string
             encoding: (of_string_encoding_t)encoding;

/*!
 * @brief Writes a string into the stream with a trailing newline.
 *
 * @param string The string from which the data is written to the stream
 * @return The number of bytes written
 */
- (size_t)writeLine: (OFString*)string;

/*!
 * @brief Writes a string into the stream in the specified encoding with a
 *	  trailing newline.
 *
 * @param string The string from which the data is written to the stream
 * @param encoding The encoding in which to write the string to the stream
 * @return The number of bytes written
 */
- (size_t)writeLine: (OFString*)string
           encoding: (of_string_encoding_t)encoding;

/*!
 * @brief Writes a formatted string into the stream.
 *
 * See printf for the format syntax. As an addition, %@ is available as format
 * specifier for objects, %C for of_unichar_t and %S for const of_unichar_t*.
 *
 * @param format A string used as format
 * @return The number of bytes written
 */
- (size_t)writeFormat: (OFConstantString*)format, ...;

/*!
 * @brief Writes a formatted string into the stream.
 *
 * See printf for the format syntax. As an addition, %@ is available as format
 * specifier for objects, %C for of_unichar_t and %S for const of_unichar_t*.
 *
 * @param format A string used as format
 * @param arguments The arguments used in the format string
 * @return The number of bytes written
 */
- (size_t)writeFormat: (OFConstantString*)format
            arguments: (va_list)arguments;

/*!
 * @brief Returns the number of bytes still present in the internal read buffer.
 *
 * @return The number of bytes still present in the internal read buffer.
 */
- (size_t)numberOfBytesInReadBuffer;

/*!
 * @brief Returns whether the stream is in blocking mode.
 *
 * @return Whether the stream is in blocking mode
 */
- (bool)isBlocking;

/*!
 * @brief Enables or disables non-blocking I/O.
 *
 * By default, a stream is in blocking mode.
 * On Win32, this currently only works for sockets!
 *
 * @param enable Whether the stream should be blocking
 */
- (void)setBlocking: (bool)enable;

/*!
 * @brief Returns the file descriptor for the read end of the stream.
 *
 * @return The file descriptor for the read end of the stream
 */
- (int)fileDescriptorForReading;

/*!
 * @brief Returns the file descriptor for the write end of the stream.
 *
 * @return The file descriptor for the write end of the stream
 */
- (int)fileDescriptorForWriting;

#ifdef OF_HAVE_SOCKETS
/*!
 * @brief Cancels all pending asyncronous requests on the stream.
 *
 * @warning You are not allowed to call this inside the handler of an
 *	    asyncronous request, as this would cancel the asyncronous request
 *	    that is currently being handled! To cancel all pending asyncronous
 *	    requests after the handler has finished executing, you may schedule
 *	    a timer for this method with a timeout of 0 from inside the handler.
 */
- (void)cancelAsyncRequests;
#endif

/*!
 * @brief "Reverses" a read operation, meaning the bytes from the specified
 *	  buffer will be returned on the next read operation.
 *
 * This is useful for reading into a buffer, parsing the data and then giving
 * back the data which does not need to be processed. This can be used to
 * optimize situations in which the length of the data that needs to be
 * processed is not known before all data has been processed - for example in
 * decompression - in which it would otherwise be necessary to read byte by
 * byte to avoid consuming bytes that need to be parsed by something else -
 * for example the data descriptor in a ZIP archive which immediately follows
 * the compressed data.
 *
 * If the stream is a file, this method does not change any data in the file.
 *
 * If the stream is seekable, a seek operation will discard any data which was
 * unread.
 *
 * @param buffer The buffer to unread
 * @param length The length of the buffer to unread
 */
- (void)unreadFromBuffer: (const void*)buffer
                  length: (size_t)length;

/*!
 * @brief Closes the stream.
 */
- (void)close;

/*!
 * @brief Performs a lowlevel read.
 *
 * @warning Do not call this directly!
 *
 * Override this method with your actual read implementation when subclassing!
 *
 * @param buffer The buffer for the data to read
 * @param length The length of the buffer
 * @return The number of bytes read
 */
- (size_t)lowlevelReadIntoBuffer: (void*)buffer
                          length: (size_t)length;

/*!
 * @brief Performs a lowlevel write.
 *
 * @warning Do not call this directly!
 *
 * Override this method with your actual write implementation when subclassing!
 *
 * @param buffer The buffer with the data to write
 * @param length The length of the data to write
 */
- (void)lowlevelWriteBuffer: (const void*)buffer
                     length: (size_t)length;

/*!
 * @brief Returns whether the lowlevel is at the end of the stream.
 *
 * @warning Do not call this directly!
 *
 * Override this method with your actual end of stream checking implementation
 * when subclassing!
 *
 * @return Whether the lowlevel is at the end of the stream
 */
- (bool)lowlevelIsAtEndOfStream;

@end

@interface AdvancedFile : OFObject<OFFileProxy> {
    OFString *filePath;
    OFString *mode;
    OFFile *file;
    off_t offset;
    
    AdvancedFile *preFile;
    AdvancedFile *nextFile;
}

+ (AdvancedFile *)fileWithPath:(OFString *)path mode:(OFString *)mode;
- (instancetype)initWithPath:(OFString *)path mode:(OFString *)_mode;
- (OFString *)filePath;

//forward everything to OFFile

@end
