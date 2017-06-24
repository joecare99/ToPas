/* Test CScan with Windows Borland C++ 6 (BCB) by R.Peters

Please update the search path as appropriate for your installation!
*/

#pragma Include "e:\b6\Include\" "+Sys\"
//#pragma Include "e:\b6\Include\Sys\"
//#pragma Include "f:\Delphi\CScan\ZipDll\"

//always defined when compiling for Windows
#define _WIN32 1

//architecture, value x00 roughly equals 80x86 (pentium:500, newer:600)
#define _M_IX86 500

//compiler
//#define _MSC_VER 1300
//- accepts strange construct: /##/
//#define _MSC_VER 1000

#define __BORLANDC__ 0x0560
#define _CHAR_UNSIGNED	1
#define __WIN32__	1
#define __TURBOC__ 	0x0560
#define __TLS__ 1
#define _CPPUNWIND	1
#define __MT__ 1
#define __CDECL__ 1
#define __FLAT__  1
#define __TURBOC 1
#define __WIN32__ 1

#define __DLL__	1
#define _Windows 1
#define WIN32 1
#define NDEBUG 1
#define USE_STRM_INPUT 1
#define MULTITHREAD 1


//__declspec has a list of modifiers
#define __declspec(modifiers)

//undefine the following when handled by the parser!

//convert __int64 into the internal type
#define __int64 int64_t

//calling conventions
#define cdecl __cdecl
#define _cdecl  __cdecl
#define __cdecl
#define __fastcall
#define __stdcall

//inline functions
//forwarders
//#define inline  __inline
//#define _inline __inline
//#define __forceinline __inline
//define this one as required
//#define __inline

#include  <WINDOWS.H>
//  from here just tests it
#define _fastcall __fastcall


#include "ZipDll\Zip.h"


//#define size_t int
//typedef unsigned char uch;

size_t test3(uch a);


size_t test3(uch a)
{
	return 5;
}

// end
