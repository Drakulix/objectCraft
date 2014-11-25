AC_INIT([ObjectCraft], [0.0.2], [drakulix@portingteam.com], [objectCraft], [http://github.com/drakulix/objectCraft])
AM_INIT_AUTOMAKE([no-define])

AC_CHECK_TOOL(OBJFW_CONFIG, objfw-config)
AS_IF([test x"$OBJFW_CONFIG" = x""], [
       AC_MSG_ERROR(You need ObjFW and objfw-config installed!)
])
test x"$OBJC" = x"" && OBJC="$($OBJFW_CONFIG --objc)"

AC_LANG([Objective C])
AC_PROG_OBJC([clang])
AC_PROG_OBJCXX([clang])
AC_CONFIG_FILES([Makefile])
AC_CONFIG_HEADERS([config.h])

CPP="$OBJCPP"
CPPFLAGS="$CPPFLAGS $OBJCPPFLAGS $($OBJFW_CONFIG --cppflags)"
OBJCFLAGS="$OBJCFLAGS -Wall $($OBJFW_CONFIG --objcflags) -DOS_OBJECT_USE_OBJC=0"
LDFLAGS="$LDFLAGS $($OBJFW_CONFIG --ldflags)"
LIBS="$LIBS $($OBJFW_CONFIG --libs)"

# TO-DO add --enable-static flag to compile standalone against libobjfw.a file

AC_CHECK_LIB([z], [
    inflate
])

AC_MSG_CHECKING([for kernel-based libdispatch])
AC_TRY_LINK([
    #import <ObjFW/ObjFW.h>
    #import <dispatch/dispatch.h>
], [
    dispatch_sync(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^{
        of_log(@"dispatched!");
    });
], [
    AC_MSG_RESULT(yes)
], [
    AC_MSG_RESULT(no)
    AC_MSG_CHECKING([for userland libdispatch])
    LDFLAGS="$LDFLAGS -ldispatch"
    AC_TRY_LINK([
        #import <ObjFW/ObjFW.h>
        #import <dispatch/dispatch.h>
    ], [
        dispatch_sync(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            of_log(@"Dispatched!");
        });
    ], [
        AC_MSG_RESULT(yes)
    ], [
        AC_MSG_RESULT(no)
        AC_MSG_ERROR(You need to have libdispatch installed!)
    ])
])

AC_ARG_ENABLE(debug,
AS_HELP_STRING([--enable-debug],
               [enable debugging, default: no]),
[case "${enableval}" in
             yes) debug=true ;;
             no)  debug=false ;;
             *)   AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
esac],
[debug=false])

AM_CONDITIONAL(DEBUG, test x"$debug" = x"true")

AC_SUBST([OBJC_CFLAGS])
AC_OUTPUT
