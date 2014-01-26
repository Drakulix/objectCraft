AC_INIT([ObjectCraft], [0.0.1], [drakulix@portingteam.com], [objectCraft], [http://github.com/drakulix])
AM_INIT_AUTOMAKE([no-define])
AC_LANG([Objective C])
AC_PROG_OBJC
AC_PROG_OBJCPP
AC_CONFIG_FILES([Makefile])
# Get OBJFW library and include locations
AC_ARG_WITH([objfw-include-path],
  [AS_HELP_STRING([--with-objfw-include-path],
    [location of the OBJFW headers, defaults to /usr/include/objfw])],
  [OBJFW_CFLAGS="-I$withval"],
  [OBJFW_CFLAGS='-I/usr/local/include'])
AC_SUBST([OBJFW_CFLAGS])
AC_ARG_WITH([objfw-lib-path],
  [AS_HELP_STRING([--with-objfw-lib-path], [location of the ObjFW libraries])],
  [OBJFW_LIBS="-L$withval -lobjfw"],
  [OBJFW_LIBS='-lobjfw'])
AC_SUBST([OBJFW_LIBS])
OBJC_CFLAGS="-Wall -fexceptions -fobjc-exceptions -funwind-tables -fconstant-string-class=OFConstantString"

my_save_cflags="$CFLAGS"
CFLAGS=-fno-constant-cfstrings
AC_MSG_CHECKING([whether OBJC supports -fno-constant-cfstrings])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
    [AC_MSG_RESULT([yes])]
    [OBJC_CFLAGS="$OBJC_CFLAGS -fno-constant-cfstrings"],
    [AC_MSG_RESULT([no])]
)
CFLAGS="$my_save_cflags"

AC_SUBST([OBJC_CFLAGS])
AC_OUTPUT
