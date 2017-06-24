#line 1 "f:\dodi.d7\cscan\topas.06\parsetest.c"
/*test some special cases
*/

#pragma Include "G:\Program Files\Borland\CBuilder4\Include\"
#define	_EXPFUNC extern

#pragma Source "F:\DoDi.CJ\archivers\arc-5.21e\"
#pragma Module "arc.c"
#line 1 "f:\dodi.cj\archivers\arc-5.21e\arc.c"
/*
 * $Header: /var/local/hyc/src/arc/RCS/arc.c,v 2.0 1991/11/12 00:30:01 hyc Exp $
 */

/*  ARC - Archive utility
  
    Version 5.21, created on 04/22/87 at 15:05:21
  
(C) COPYRIGHT 1985-87 by System Enhancement Associates; ALL RIGHTS RESERVED
  
    By:	 Thom Henderson
  
    Description:
	 This program is a general archive utility, and is used to maintain
	 an archive of files.  An "archive" is a single file that combines
	 many files, reducing storage space and allowing multiple files to
	 be handled as one.
  
    Instructions:
	 Run this program with no arguments for complete instructions.
  
    Programming notes:
	 ARC Version 2 differs from version 1 in that archive entries
	 are automatically compressed when they are added to the archive,
	 making a separate compression step unecessary.	 The nature of the
	 compression is indicated by the header version number placed in
	 each archive entry, as follows:
  
	 1 = Old style, no compression
	 2 = New style, no compression
	 3 = Compression of repeated characters only
	 4 = Compression of repeated characters plus Huffman SQueezing
	 5 = Lempel-Zev packing of repeated strings (old style)
	 6 = Lempel-Zev packing of repeated strings (new style)
	 7 = Lempel-Zev Williams packing with improved hash function
	 8 = Dynamic Lempel-Zev packing with adaptive reset
	 9 = Dynamic Lempel-Zev packing, larger hash table
  
	 Type 5, Lempel-Zev packing, was added as of version 4.0
  
	 Type 6 is Lempel-Zev packing where runs of repeated characters
	 have been collapsed, and was added as of version 4.1
  
	 Type 7 is a variation of Lempel-Zev using a different hash
	 function which yields speed improvements of 20-25%, and was
	 added as of version 4.6
  
	 Type 8 is a different implementation of Lempel-Zev, using a
	 variable code size and an adaptive block reset, and was added
	 as of version 5.0
  
	 Type 9 is a slight modification of type 8, first used by Phil
	 Katz in his PKARC utilites. The primary difference is the use
	 of a hash table twice as large as for type 8, and that this
	 algorithm called Squashing, doesn't perform run-length encoding
	 on the input data.
  
	 Verion 4.3 introduced a temporary file for holding the result
	 of the first crunch pass, thus speeding up crunching.
  
	 Version 4.4 introduced the ARCTEMP environment string, so that
	 the temporary crunch file may be placed on a ramdisk.	Also
	 added was the distinction bewteen Adding a file in all cases,
	 and Updating a file only if the disk file is newer than the
	 corresponding archive entry.
  
	 The compression method to use is determined when the file is
	 added, based on whichever method yields the smallest result.
  
    Language:
	 Computer Innovations Optimizing C86
*/
#include <stdio.h>
#line 1 "g:\program files\borland\cbuilder4\include\stdio.h"
/*  stdio.h
#include "arc.h"

    Definitions for stream input/output.

*/

/*
 *      C/C++ Run Time Library - Version 9.5
 *
 *      Copyright (c) 1987, 1999 by Inprise Corporation
 *      All Rights Reserved.
 *
 */

/* $Revision:   9.10  $ */

#ifndef __STDIO_H
#define __STDIO_H
#define _INC_STDIO  /* MSC Guard name */

#ifndef ___STDDEF_H
#include <_stddef.h>
#line 1 "g:\program files\borland\cbuilder4\include\_stddef.h"
/*  _stddef.h
#endif

    multi-includable Definitions for common types, and NULL

*/

/*
 *      C/C++ Run Time Library - Version 9.5
 *
 *      Copyright (c) 1987, 1999 by Inprise Corporation
 *      All Rights Reserved.
 *
 */

/* $Revision:   9.1  $ */

#ifndef ___STDDEF_H
#define ___STDDEF_H

#if !defined(___DEFS_H)
#include <_defs.h>
#line 1 "g:\program files\borland\cbuilder4\include\_defs.h"
/*  _defs.h
#endif

    Common definitions for pointer size and calling conventions.

    Calling conventions:
    _RTLENTRY       Specifies the calling convention used by the RTL

    _USERENTRY      Specifies the calling convention the RTL expects user
                    compiled functions to use (for callbacks)

    Export (and size for DOS) information:
    _EXPCLASS       Exports class if building DLL version of library
                    For DOS16 also provides size information

    _EXPDATA        Exports data if building DLL version of library

    _EXPFUNC        Exports function if building DLL version of library
                    For DOS16 also provides size information

    _FAR            Promotes data pointers to far in DLLs (DOS16 only)

    Obsolete versions:
    _Cdecl          Use _RTLENTRY
    _CLASSTYPE      Use _EXPCLASS
    _FARFUNC        Use _EXPFUNC
    _FARCALL        Use _EXPFUNC and declare function explicity __far
*/

/*
 *      C/C++ Run Time Library - Version 9.5
 *
 *      Copyright (c) 1991, 1999 by Inprise Corporation
 *      All Rights Reserved.
 *
 */

/* $Revision:   9.3  $ */

#ifndef ___DEFS_H
#define ___DEFS_H

#define _RTLENTRY  __cdecl
#define _USERENTRY __cdecl

#if defined(__PAS__)
>#    define _RTLENTRYF  __pascal
>#    define _USERENTRYF __pascal
>#else
#    define _RTLENTRYF  _RTLENTRY
#    define _USERENTRYF _USERENTRY
#endif

#define _FAR
#if defined(_BUILDRTLDLL)
>#    define _EXPCLASS  __export
>#    define _EXPDATA   __export
>#    define _EXPFUNC   __export
>#    define _RWSTDBUILDDLL
>#elif defined(_RTLDLL)
>#    define _EXPCLASS  __import
>#    define _EXPDATA   __import
>#    define _EXPFUNC   __import
>#    define _RWSTDDLL
>#else
#    define _EXPCLASS
#    define _EXPDATA
#    define _EXPFUNC
#endif


#define _EXPFUNC32  _EXPFUNC
#define _EXPFUNC16


#define _Cdecl      _RTLENTRY
#define _CType      _RTLENTRYF
#define _CLASSTYPE  _EXPCLASS
#define _FARFUNC    _EXPFUNC
#define _FARCALL    _EXPFUNC __far


#if defined(__cplusplus)
>#   define _PTRDEF(name) typedef name _FAR * P##name;
>#   define _REFDEF(name) typedef name _FAR & R##name;
>#   define _REFPTRDEF(name) typedef name _FAR * _FAR & RP##name;
>#   define _PTRCONSTDEF(name) typedef const name _FAR * PC##name;
>#   define _REFCONSTDEF(name) typedef const name _FAR & RC##name;
>
>#if 0
>>>/*********** Obsolete definitions for OWL 1.0 *************/
>>>#   define _CLASSDEF(name) class _EXPCLASS name; \
>>>           _PTRDEF(name) \
>>>           _REFDEF(name) \
>>>           _REFPTRDEF(name) \
>>>           _PTRCONSTDEF(name) \
>>>           _REFCONSTDEF(name)
>>>#endif /* 0 */
>#endif

#endif  /* ___DEFS_H */
//EOF "_defs.h"
#line 22 "g:\program files\borland\cbuilder4\include\_stddef.h"

#ifndef NULL
#include <_null.h>
#line 1 "g:\program files\borland\cbuilder4\include\_null.h"
/*  _null.h
#endif

    Definition of NULL.

*/

/*
 *      C/C++ Run Time Library - Version 9.5
 *
 *      Copyright (c) 1987, 1999 by Inprise Corporation
 *      All Rights Reserved.
 *
 */

/* $Revision:   9.1  $ */

#ifndef NULL
#  if defined(__cplusplus) || defined(_Windows)
>#    define NULL 0
>#  else
#    define NULL ((void *)0)
#  endif
#endif

//EOF "_null.h"
#line 26 "g:\program files\borland\cbuilder4\include\_stddef.h"

#ifdef __cplusplus
>namespace std {
>#endif /* __cplusplus */

/* Define __STD to expand to std:: or nothing depending on being in C++. */
#ifdef __cplusplus
>#  define __STD std::
>#else
#  define __STD
#endif

/*
   Define the size_t type in the std namespace if in C++ or globally if in C.
   If we're in C++, make the _SIZE_T macro expand to std::size_t
*/

#if !defined(_SIZE_T) && !defined(_SIZE_T_DEFINED)
#  define _SIZE_T_DEFINED
   typedef unsigned int size_t;
#  if defined(__cplusplus)
>#    define _SIZE_T std::size_t
>#  else
#    define _SIZE_T size_t
#  endif
#endif


#if !defined(RC_INVOKED)

#if defined(__STDC__)
>#pragma warn -nak
>#endif

#endif  /* !RC_INVOKED */

#ifndef _PTRDIFF_T
#define _PTRDIFF_T
typedef int     ptrdiff_t;
#endif


#define offsetof( s_name, m_name )  (_SIZE_T)&(((s_name _FAR *)0)->m_name)

#ifndef __cplusplus
#if !defined(_WCHAR_T) && !defined(_WCHAR_T_DEFINED)
#define _WCHAR_T
#define _WCHAR_T_DEFINED  /* For WINDOWS.H */
typedef unsigned short wchar_t;
#endif
#endif

/*
   Define the wint_t type in the std namespace if in C++ or globally if in C.
   If we're in C++, make the _WINT_T macro expand to std::wint_t
*/

#if !defined(_WINT_T)
typedef wchar_t wint_t;
#  ifdef __cplusplus
>#    define _WINT_T std::wint_t
>#  else
#    define _WINT_T wint_t
#  endif
#endif

#ifndef _WCTYPE_T_DEFINED
typedef wchar_t wctype_t;
#define _WCTYPE_T_DEFINED
#endif

#ifdef __cplusplus
>extern "C" {
>#endif
extern unsigned long _RTLENTRY _EXPFUNC __threadid(void);
#define _threadid (__threadid())

#ifdef  __cplusplus
>}
>#endif

#if !defined(RC_INVOKED)

#if defined(__STDC__)
>#pragma warn .nak
>#endif

#endif  /* !RC_INVOKED */

#ifdef __cplusplus
>} // std
>#endif /* __cplusplus */

#endif  /* __STDDEF_H */

#if defined(__cplusplus) && !defined(__USING_CNAME__) && !defined(___STDDEF_H_USING_LIST)
>#define ___STDDEF_H_USING_LIST
>     using std::ptrdiff_t;
>     using std::__threadid;
>     using std::size_t;
>     using std::wint_t;
>     using std::wctype_t;
>#endif /* __USING_CNAME__ */
//EOF "_stddef.h"
#line 23 "g:\program files\borland\cbuilder4\include\stdio.h"

#if !defined(___NFILE_H)
#include <_nfile.h>
#line 1 "g:\program files\borland\cbuilder4\include\_nfile.h"
/*  _nfile.h
#endif

    Maximum number of open files

*/

/*
 *      C/C++ Run Time Library - Version 9.5
 *
 *      Copyright (c) 1991, 1999 by Inprise Corporation
 *      All Rights Reserved.
 *
 */

/* $Revision:   9.1  $ */

#ifndef ___NFILE_H
#define ___NFILE_H


#define _NFILE_ 50

#endif
//EOF "_nfile.h"
#line 27 "g:\program files\borland\cbuilder4\include\stdio.h"

#ifdef __cplusplus
>namespace std {
>#endif /* __cplusplus */


#if !defined(RC_INVOKED)

#if defined(__STDC__)
>#pragma warn -nak
>#endif

#pragma pack(push, 1)

#endif  /* !RC_INVOKED */

/* Definition of the file position type
*/
typedef long    fpos_t;

/* An external reference to _floatconvert (using #pragma extref _floatconvert)
 * forces floating point format conversions to be linked.
 */
extern int _floatconvert;

/* Bufferisation type to be used as 3rd argument for "setvbuf" function
*/
#define _IOFBF  0
#define _IOLBF  1
#define _IONBF  2

/*  "flags" bits definitions
*/
#define _F_RDWR 0x0003                  /* Read/write flag       */
#define _F_READ 0x0001                  /* Read only file        */
#define _F_WRIT 0x0002                  /* Write only file       */
#define _F_BUF  0x0004                  /* Malloc'ed Buffer data */
#define _F_LBUF 0x0008                  /* line-buffered file    */
#define _F_ERR  0x0010                  /* Error indicator       */
#define _F_EOF  0x0020                  /* EOF indicator         */
#define _F_BIN  0x0040                  /* Binary file indicator */
#define _F_IN   0x0080                  /* Data is incoming      */
#define _F_OUT  0x0100                  /* Data is outgoing      */
#define _F_TERM 0x0200                  /* File is a terminal    */

/* End-of-file constant definition
*/
#define EOF (-1)                /* End of file indicator */
#define WEOF (_WINT_T)(0xFFFF)   /* wide-character end of file indicator */

/* Default buffer size use by "setbuf" function
*/
#define BUFSIZ  512         /* Buffer size for stdio */

/* Size of an arry large enough to hold a temporary file name string
*/
#define L_ctermid   5       /* CON: plus null byte */
#define P_tmpdir    ""      /* temporary directory */
#define L_tmpnam    13      /* tmpnam buffer size */

/* Constants to be used as 3rd argument for "fseek" function
*/
#define SEEK_CUR    1
#define SEEK_END    2
#define SEEK_SET    0

/* Number of unique file names that shall be generated by "tmpnam" function
*/
#define TMP_MAX     0xFFFF

/* Definition of the control structure for streams
*/
typedef struct
{
        unsigned char  *curp;       /* Current active pointer     */
        unsigned char  *buffer;     /* Data transfer buffer       */
        int             level;      /* fill/empty level of buffer */
        int             bsize;      /* Buffer size                */
        unsigned short  istemp;     /* Temporary file indicator   */
        unsigned short  flags;      /* File status flags          */
        wchar_t         hold;       /* Ungetc char if no buffer   */
        char            fd;         /* File descriptor            */
        unsigned char   token;      /* Used for validity checking */
}       FILE;                       /* This is the FILE object    */

/* Number of files that can be open simultaneously
*/
#if defined(__STDC__)
>#define FOPEN_MAX (_NFILE_)
>#else
#define FOPEN_MAX (_NFILE_)
#define SYS_OPEN  (_NFILE_)
#endif

#define FILENAME_MAX 260

#ifdef __cplusplus
>extern "C" {
>#endif

/* Standard I/O predefined streams
*/
extern  FILE        _RTLENTRY _EXPDATA _streams[];
extern  unsigned    _RTLENTRY _EXPDATA _nfile;

#define stdin   (&_streams[0])
#define stdout  (&_streams[1])
#define stderr  (&_streams[2])

/* __getStream() is used internally with CG only, but prototyped here for
  consistancy with the 16-bit version.
*/
FILE * _RTLENTRY _EXPFUNC __getStream( int );
#ifdef __cplusplus
>}
>#endif


#ifdef __cplusplus
>extern "C" {
>#endif
void      _RTLENTRY _EXPFUNC clearerr(FILE * __stream);
int       _RTLENTRY _EXPFUNC fclose(FILE * __stream);
int       _RTLENTRY _EXPFUNC fflush(FILE * __stream);
int       _RTLENTRY _EXPFUNC fgetc(FILE * __stream);
_WINT_T   _RTLENTRY _EXPFUNC fgetwc(FILE * __stream);
int       _RTLENTRY _EXPFUNC fgetpos(FILE * __stream, fpos_t*__pos);
char  *   _RTLENTRY _EXPFUNC fgets(char * __s, int __n, FILE * __stream);
wchar_t*  _RTLENTRY _EXPFUNC fgetws(wchar_t * __s, int __n, FILE * __stream);
FILE  *   _RTLENTRY _EXPFUNC fopen(const char * __path, const char * __mode);
FILE  *   _RTLENTRY _EXPFUNC _wfopen(const wchar_t * __path,
                                 const wchar_t * __mode);
int       _RTLENTRY _EXPFUNC fprintf(FILE * __stream, const char * __format, ...);
int       _RTLENTRY _EXPFUNC fwprintf(FILE * __stream, const wchar_t *__format, ...);
int       _RTLENTRY _EXPFUNC fputc(int __c, FILE * __stream);
_WINT_T   _RTLENTRY _EXPFUNC fputwc(_WINT_T __c, FILE * __stream);
int       _RTLENTRY _EXPFUNC fputs(const char * __s, FILE * __stream);
int       _RTLENTRY _EXPFUNC fputws(const wchar_t * __s, FILE * __stream);
_SIZE_T   _RTLENTRY _EXPFUNC fread(void * __ptr, _SIZE_T __size, _SIZE_T __n,
                                 FILE * __stream);
FILE  *   _RTLENTRY _EXPFUNC freopen(const char * __path, const char * __mode,
                                 FILE * __stream);
FILE  *   _RTLENTRY _EXPFUNC _wfreopen(const wchar_t * __path, const wchar_t * __mode,
                                 FILE * __stream);
int       _RTLENTRY _EXPFUNC fscanf(FILE * __stream, const char * __format, ...);
int       _RTLENTRY _EXPFUNC fwscanf(FILE *__stream, const wchar_t *__format, ...);
int       _RTLENTRY _EXPFUNC fseek(FILE * __stream, long __offset, int __whence);
int       _RTLENTRY _EXPFUNC fsetpos(FILE * __stream, const fpos_t*__pos);
long      _RTLENTRY _EXPFUNC ftell(FILE * __stream);
_SIZE_T   _RTLENTRY _EXPFUNC fwrite(const void * __ptr, _SIZE_T __size, _SIZE_T __n,
                                 FILE * __stream);
char  *   _RTLENTRY _EXPFUNC gets(char * __s);
wchar_t*  _RTLENTRY _EXPFUNC _getws(wchar_t * __s);
int       _RTLENTRY _EXPFUNC _pclose(FILE *__stream);
void      _RTLENTRY _EXPFUNC perror(const char * __s);
void      _RTLENTRY _EXPFUNC _wperror(const wchar_t * __s);
FILE *    _RTLENTRY _EXPFUNC _popen(const char * __command, const char * __mode);
FILE *    _RTLENTRY _EXPFUNC _wpopen(const wchar_t * __command,
                                 const wchar_t * __mode);

int       _RTLENTRY _EXPFUNC printf(const char * __format, ...);
int       _RTLENTRY _EXPFUNC wprintf(const wchar_t * __format, ...);
int       _RTLENTRY _EXPFUNC puts(const char * __s);
int       _RTLENTRY _EXPFUNC _putws(const wchar_t * __s);

int       _RTLENTRY _EXPFUNC remove(const char * __path);
int       _RTLENTRY _EXPFUNC _wremove(const wchar_t * __path);
int       _RTLENTRY _EXPFUNC rename(const char * __oldname,const char * __newname);
int       _RTLENTRY _EXPFUNC _wrename(const wchar_t * __oldname,const wchar_t * __newname);
void      _RTLENTRY _EXPFUNC rewind(FILE * __stream);
int       _RTLENTRY _EXPFUNC scanf(const char * __format, ...);
int       _RTLENTRY _EXPFUNC wscanf(const wchar_t * __format, ...);
void      _RTLENTRY _EXPFUNC setbuf(FILE * __stream, char * __buf);
int       _RTLENTRY _EXPFUNC setvbuf(FILE * __stream, char * __buf,
                                 int __type, _SIZE_T __size);
int       _RTLENTRY _EXPFUNC sprintf(char * __buffer, const char * __format, ...);
int       _RTLENTRY _EXPFUNC swprintf(wchar_t * __buffer, const wchar_t * __format, ...);
int       _RTLENTRY _EXPFUNC snprintf(char * __buffer, _SIZE_T __nsize,
                                 const char * __format, ...);
int       _RTLENTRY _EXPFUNC snwprintf(wchar_t * __buffer, _SIZE_T __nsize,
                                 const wchar_t * __format, ...);
#ifndef __STDC__
int       _RTLENTRY _EXPFUNC _snprintf(char * __buffer, _SIZE_T __nsize,
                                 const char * __format, ...);
int       _RTLENTRY _EXPFUNC _snwprintf(wchar_t * __buffer, _SIZE_T __nsize,
                                 const wchar_t * __format, ...);
#endif
int       _RTLENTRY _EXPFUNC sscanf(const char * __buffer,
                                 const char * __format, ...);
int       _RTLENTRY _EXPFUNC swscanf(const wchar_t * __buffer,
                                 const wchar_t * __format, ...);
char  *   _RTLENTRY _EXPFUNC strerror(int __errnum);
FILE  *   _RTLENTRY _EXPFUNC tmpfile(void);
char  *   _RTLENTRY _EXPFUNC tmpnam(char * __s);
wchar_t * _RTLENTRY _EXPFUNC _wtmpnam(wchar_t * __s);
int       _RTLENTRY _EXPFUNC ungetc(int __c, FILE * __stream);
_WINT_T   _RTLENTRY _EXPFUNC ungetwc(_WINT_T __c, FILE * __stream);
int       _RTLENTRY _EXPFUNC vfprintf(FILE * __stream, const char * __format,
                                 void * __arglist);
int       _RTLENTRY _EXPFUNC vfscanf(FILE * __stream, const char * __format,
                                 void * __arglist);
int       _RTLENTRY _EXPFUNC vprintf(const char * __format, void * __arglist);
int       _RTLENTRY _EXPFUNC vscanf(const char * __format, void * __arglist);
int       _RTLENTRY _EXPFUNC vsprintf(char * __buffer, const char * __format,
                                 void * __arglist);
int       _RTLENTRY _EXPFUNC vsnprintf(char * __buffer, _SIZE_T __nsize, const char * __format,
                                 void * __arglist);
int       _RTLENTRY _EXPFUNC vsscanf(const char * __buffer, const char * __format,
                                 void * __arglist);
int       _RTLENTRY _EXPFUNC vfwprintf(FILE * __stream, const wchar_t * __format,
                                 void * __arglist);
int       _RTLENTRY _EXPFUNC vfwscanf(FILE * __stream, const wchar_t * __format,
                                 void * __arglist);
int       _RTLENTRY _EXPFUNC vwprintf(const wchar_t * __format, void * __arglist);
int       _RTLENTRY _EXPFUNC vwscanf(const wchar_t * __format, void * __arglist);
int       _RTLENTRY _EXPFUNC vswprintf(wchar_t * __buffer, const wchar_t * __format,
                                 void * __arglist);
int       _RTLENTRY _EXPFUNC vsnwprintf(wchar_t * __buffer, _SIZE_T __nsize, const wchar_t * __format,
                                 void * __arglist);
int       _RTLENTRY _EXPFUNC vswscanf(const wchar_t * __buffer, const wchar_t * __format,
                                 void * __arglist);
int       _RTLENTRY _EXPFUNC _unlink(const char * __path);
int       _RTLENTRY _EXPFUNC _wunlink(const wchar_t * __path);
#ifndef   __STDC__
int       _RTLENTRY _EXPFUNC _vsnprintf(char * __buffer, _SIZE_T __nsize, const char * __format,
                                 void * __arglist);
int       _RTLENTRY _EXPFUNC _vsnwprintf(wchar_t * __buffer, _SIZE_T __nsize, const wchar_t * __format,
                                 void * __arglist);
#endif

int       _RTLENTRY _EXPFUNC getc(FILE * __fp);
_WINT_T   _RTLENTRY _EXPFUNC getwc(FILE * __fp);
int       _RTLENTRY _EXPFUNC getchar(void);
_WINT_T   _RTLENTRY _EXPFUNC getwchar(void);
int       _RTLENTRY _EXPFUNC putchar(const int __c);
_WINT_T   _RTLENTRY _EXPFUNC putwchar(const _WINT_T __c);
int       _RTLENTRY _EXPFUNC putc(const int __c, FILE * __fp);
_WINT_T   _RTLENTRY _EXPFUNC putwc(const _WINT_T __c, FILE * __fp);
int       _RTLENTRY _EXPFUNC feof(FILE * __fp);
int       _RTLENTRY _EXPFUNC ferror(FILE * __fp);
int       _RTLENTRY _EXPFUNC _fileno(FILE _FAR *__fp);
int       _RTLENTRY _EXPFUNC _flushall(void);
int       _RTLENTRY _EXPFUNC _fcloseall(void);
FILE  *   _RTLENTRY _EXPFUNC _fdopen(int __handle, char * __type);
FILE  *   _RTLENTRY _EXPFUNC _wfdopen(int __handle, wchar_t * __type);
int       _RTLENTRY _EXPFUNC _fgetchar(void);
_WINT_T   _RTLENTRY _EXPFUNC _fgetwchar(void);
int       _RTLENTRY _EXPFUNC _fputchar(int __c);
_WINT_T   _RTLENTRY _EXPFUNC _fputwchar(_WINT_T __c);
FILE  *   _RTLENTRY _EXPFUNC _fsopen (const char * __path, const char * __mode, int __shflag);
FILE  *   _RTLENTRY _EXPFUNC _wfsopen (const wchar_t * __path,
                                 const wchar_t * __mode, int __shflag);
#ifdef __IN_SOPEN
>int       _RTLENTRY _EXPFUNC _sopen ();
>#else
int       _RTLENTRY _EXPFUNC _sopen (const char *__path, int __access, int __shflag,
                                 ... /* unsigned mode */);
#endif
int       _RTLENTRY _EXPFUNC _wsopen (const wchar_t *__path, int __access, int __shflag,
                                 ... /* unsigned mode */);
int       _RTLENTRY _EXPFUNC _getw(FILE * __stream);
int       _RTLENTRY _EXPFUNC _putw(int __w, FILE * __stream);
int       _RTLENTRY _EXPFUNC _rmtmp(void);
char  *   _RTLENTRY _EXPFUNC _strerror(const char * __s);
char  *   _RTLENTRY _EXPFUNC _tempnam(char * __dir, char * __pfx);
wchar_t * _RTLENTRY _EXPFUNC _wtempnam(wchar_t * __dir, wchar_t * __pfx);
int       _RTLENTRY _EXPFUNC _fgetc(FILE * __stream);           /* used by getc() macro */
_WINT_T   _RTLENTRY _EXPFUNC _fgetwc(FILE * __stream);
int       _RTLENTRY _EXPFUNC _fputc(char __c, FILE * __stream); /* used by putc() macro */
_WINT_T   _RTLENTRY _EXPFUNC _fputwc(wchar_t __c, FILE * __stream);
#if !defined(__STDC__)
int       _RTLENTRY _EXPFUNC flushall(void);
FILE  *   _RTLENTRY _EXPFUNC fdopen(int __handle, char * __type);
int       _RTLENTRY _EXPFUNC fputchar(int __c);
int       _RTLENTRY _EXPFUNC fgetchar(void);
int       _RTLENTRY _EXPFUNC fileno(FILE * __fp);
int       _RTLENTRY _EXPFUNC fcloseall(void);
char  *   _RTLENTRY _EXPFUNC tempnam(char * __dir, char * __pfx);
int       _RTLENTRY _EXPFUNC rmtmp(void);
int       _RTLENTRY _EXPFUNC unlink(const char * __path);
int       _RTLENTRY _EXPFUNC getw(FILE * __stream);
int       _RTLENTRY _EXPFUNC putw(int __w, FILE * __stream);
int       _RTLENTRY _EXPFUNC sopen (const char *__path, int __access, int __shflag,
                                 ... /* unsigned mode */);
#endif
#ifdef  __cplusplus
>}
>#endif

/*  The following macros provide for common functions */

#if !defined(__CODEGUARD__)

#define ferror(__f)   ((__f)->flags & _F_ERR)
#define feof(__f)     ((__f)->flags & _F_EOF)
#define fileno(__f)   ((__f)->fd)
#define _fileno(__f)   ((__f)->fd)

#define getc(__f) \
  ((--((__f)->level) >= 0) ? (unsigned char)(*(__f)->curp++) : \
    _fgetc (__f))

#define putc(__c,__f) \
  ((++((__f)->level) < 0) ? (unsigned char)(*(__f)->curp++=(__c)) : \
    _fputc (((char)(__c)),__f))

#define getchar()   getc(stdin)
#define getwchar()  getwc(stdin)
#define putchar(__c)  putc((__c), stdout)
#define putwchar(__c) putwc((__c), stdout)

#endif

#define ungetc(__c,__f) ungetc((__c),__f)   /* traditionally a macro */

#if !defined(RC_INVOKED)

/* restore default packing */
#pragma pack(pop)

#if defined(__STDC__)
>#pragma warn .nak
>#endif

#endif  /* !RC_INVOKED */

#ifdef __cplusplus
>} // std
>#endif /* __cplusplus */

#endif  /* __STDIO_H */

#if defined(__cplusplus) && !defined(__USING_CNAME__) && !defined(__STDIO_H_USING_LIST)
>#define __STDIO_H_USING_LIST
>     using std::FILE;
>     using std::__getStream;
>     using std::_fcloseall;
>     using std::_fdopen;
>     using std::_fgetc;
>     using std::_fgetchar;
>     using std::_fgetwc;
>     using std::_fgetwchar;
>     using std::_fileno;
>     using std::_floatconvert;
>     using std::_flushall;
>     using std::_fputc;
>     using std::_fputchar;
>     using std::_fputwc;
>     using std::_fputwchar;
>     using std::_fsopen;
>     using std::_getw;
>     using std::_getws;
>     using std::_pclose;
>     using std::_popen;
>     using std::_putw;
>     using std::_putws;
>     using std::_rmtmp;
>     using std::_sopen;
>     using std::_streams;
>     using std::_strerror;
>     using std::_tempnam;
>     using std::_unlink;
>     using std::_wfdopen;
>     using std::_wfopen;
>     using std::_wfreopen;
>     using std::_wfsopen;
>     using std::_wperror;
>     using std::_wpopen;
>     using std::_wremove;
>     using std::_wrename;
>     using std::_wsopen;
>     using std::_wtempnam;
>     using std::_wtmpnam;
>     using std::_wunlink;
>     using std::clearerr;
>     using std::fclose;
>     using std::feof;
>     using std::ferror;
>     using std::fflush;
>     using std::fgetc;
>     using std::fgetpos;
>     using std::fgets;
>     using std::fgetwc;
>     using std::fgetws;
>     using std::fopen;
>     using std::fpos_t;
>     using std::fprintf;
>     using std::fputc;
>     using std::fputs;
>     using std::fputwc;
>     using std::fputws;
>     using std::fread;
>     using std::freopen;
>     using std::fscanf;
>     using std::fseek;
>     using std::fsetpos;
>     using std::ftell;
>     using std::fwprintf;
>     using std::fwrite;
>     using std::fwscanf;
>     using std::getc;
>     using std::getchar;
>     using std::gets;
>     using std::getwc;
>     using std::getwchar;
>     using std::perror;
>     using std::printf;
>     using std::putc;
>     using std::putchar;
>     using std::puts;
>     using std::putwc;
>     using std::putwchar;
>     using std::remove;
>     using std::rename;
>     using std::rewind;
>     using std::scanf;
>     using std::setbuf;
>     using std::setvbuf;
>     using std::snprintf;
>     using std::snwprintf;
>     using std::sprintf;
>     using std::sscanf;
>     using std::strerror;
>     using std::swprintf;
>     using std::swscanf;
>     using std::tmpfile;
>     using std::tmpnam;
>     using std::ungetc;
>     using std::ungetwc;
>     using std::vfprintf;
>     using std::vfscanf;
>     using std::vfwprintf;
>     using std::vfwscanf;
>     using std::vprintf;
>     using std::vscanf;
>     using std::vsnprintf;
>     using std::vsnwprintf;
>     using std::vsprintf;
>     using std::vsscanf;
>     using std::vswprintf;
>     using std::vswscanf;
>     using std::vwprintf;
>     using std::vwscanf;
>     using std::wprintf;
>     using std::wscanf;
>
>#if !defined(__STDC__)
>>>     using std::_snprintf;
>>>     using std::_snwprintf;
>>>     using std::_vsnprintf;
>>>     using std::_vsnwprintf;
>>>     using std::fcloseall;
>>>     using std::fdopen;
>>>     using std::fgetchar;
>>>     using std::fileno;
>>>     using std::flushall;
>>>     using std::fputchar;
>>>     using std::getw;
>>>     using std::putw;
>>>     using std::rmtmp;
>>>     using std::sopen;
>>>     using std::tempnam;
>>>     using std::unlink;
>>>#endif // !__STDC__
>
>#endif /* __USING_CNAME__ */
//EOF "stdio.h"
#line 74 "f:\dodi.cj\archivers\arc-5.21e\arc.c"
#line 1 "f:\dodi.cj\archivers\arc-5.21e\arc.h"
/*

 * $Header: /var/local/hyc/src/arc/RCS/arc.h,v 2.0 1991/11/12 00:30:01 hyc Exp hyc $
 */

#undef	DOS	/* Just in case... */
#undef	UNIX

/*
 * Assumptions:
 * char = 8 bits
 * short = 16 bits
 * long = 32 bits
 * int >= 16 bits
 */

#if	MSDOS || GEMDOS
>#define	DOS	1
>#define	CUTOFF	'\\'
>#define	OPEN_R	"rb"
>#define	OPEN_W	"wb"
>#if	__GNUC__
>>>#include <types.h>
>>>#include <string.h>
>>>#endif
>#endif

#if	!MSDOS
#define	envfind	getenv
#define	setmem(a, b, c)	memset(a, c, b)
#endif

#if	BSD || SYSV
>#define	UNIX	1
>#define	CUTOFF	'/'
>#define	OPEN_R	"r"
>#define	OPEN_W	"w"
>#include <ctype.h>
>#include <sys/types.h>
>#endif

#if	_MTS
>#define	CUTOFF	sepchr[0]
>#define	OPEN_R	"rb"
>#define	OPEN_W	"wb"
>#endif

#define	MYBUF	32766		/* Used for fopens and filecopy() */

#if	_MTS || SYSV
>#define	rindex	strrchr
>#define	index	strchr
>#endif

#if	__STDC__
>#include <stdlib.h>
>#define	VOID	void
>#define	PROTO(args)	args
>#else
#define	VOID	int
#define	PROTO(args)	()
#endif

/*  ARC - Archive utility - ARC Header
  
    Version 2.17, created on 04/22/87 at 13:09:43
  
(C) COPYRIGHT 1985,86 by System Enhancement Associates; ALL RIGHTS RESERVED
  
    By:	 Thom Henderson
  
    Description: 
	 This is the header file for the ARC archive utility.  It defines
	 global parameters and the references to the external data.
  
  
    Language:
	 Computer Innovations Optimizing C86
*/

#define ARCMARK 26		/* special archive marker        */
#define ARCVER 9		/* archive header version code   */
#define STRLEN 100		/* system standard string length */
#define FNLEN 13		/* file name length              */
#define MAXARG 400		/* maximum number of arguments   */

#if	!UNIX
typedef unsigned int	u_int;
#ifndef	__GNUC__
typedef unsigned char	u_char;
typedef unsigned short	u_short;
#endif
#endif
#define	reg	register

#ifndef DONT_DEFINE		/* Defined by arcdata.c */
#include "arcs.h"
#line 1 "f:\dodi.cj\archivers\arc-5.21e\arcs.h"
/*

 * $Header: /var/local/hyc/src/arc/RCS/arcs.h,v 2.0 1991/11/12 00:30:01 hyc Exp $
 */

/*
 * ARC - Archive utility - Archive file header format
 * 
 * Version 2.12, created on 12/17/85 at 14:40:26
 * 
 * (C) COPYRIGHT 1985 by System Enhancement Associates; ALL RIGHTS RESERVED
 * 
 * By:  Thom Henderson
 * 
 * Description: This file defines the format of an archive file header,
 * excluding the archive marker and the header version number.
 * 
 * Each entry in an archive begins with a one byte archive marker, which is set
 * to 26.  The marker is followed by a one byte header type code, from zero
 * to 7.
 * 
 * If the header type code is zero, then it is an end marker, and no more data
 * should be read from the archive.
 * 
 * If the header type code is in the range 2 to 7, then it is followed by a
 * standard archive header, which is defined below.
 * 
 * If the header type code is one, then it is followed by an older format
 * archive header.  The older format header does not contain the true length.
 * A header should be read for a length of sizeof(struct heads)-sizeof(long).
 * Then set length equal to size and change the header version to 2.
 * 
 * Programming note: The crc value given in the header is based on the unpacked
 * data.
 * 
 * Language: Computer Innovations Optimizing C86
 */

struct heads {			/* archive entry header format */
    char    name[FNLEN];		/* file name */
            long size;		/* size of file, in bytes */
    unsigned    short date;	/* creation date */
    unsigned    short time;	/* creation time */
                short crc;	/* cyclic redundancy check */
                long length;	/* true file length */
};
//EOF "arcs.h"
#line 97 "f:\dodi.cj\archivers\arc-5.21e\arc.h"
extern int      keepbak;	/* true if saving the old archive */
#if	!DOS
extern int      image;		/* true to suppress CRLF/LF x-late */
#endif
#if	_MTS
>extern char     sepchr[2];	/* Shared file separator, default = ':' */
>extern char     tmpchr[2];	/* Temporary file prefix, default = '-' */
>#endif
#if	GEMDOS
>extern int      hold;		/* hold screen before exiting */
>#endif
extern int      warn;		/* true to print warnings */
extern int      note;		/* true to print comments */
extern int      bose;		/* true to be verbose */
extern int      nocomp;		/* true to suppress compression */
extern int      overlay;	/* true to overlay on extract */
extern int      kludge;		/* kludge flag */
extern char    *arctemp;	/* arc temp file prefix */
extern char    *password;	/* encryption password pointer */
extern int      nerrs;		/* number of errors encountered */
extern int      changing;	/* true if archive being modified */

extern char     hdrver;		/* header version */

extern FILE    *arc;		/* the old archive */
extern FILE    *new;		/* the new archive */
extern char     arcname[STRLEN];/* storage for archive name */
extern char     bakname[STRLEN];/* storage for backup copy name */
extern char     newname[STRLEN];/* storage for new archive name */
extern u_short	arcdate;	/* archive date stamp */
extern u_short	arctime;	/* archive time stamp */
extern u_short	olddate;	/* old archive date stamp */
extern u_short	oldtime;	/* old archive time stamp */
extern int      dosquash;	/* squash instead of crunch */
#endif				/* DONT_DEFINE */
//EOF "arc.h"
#line 75 "f:\dodi.cj\archivers\arc-5.21e\arc.c"
#if	UNIX
>#include <sys/types.h>
>#include <sys/stat.h>
>#endif

#include <string.h>
#line 1 "g:\program files\borland\cbuilder4\include\string.h"
/*  string.h


    Definitions for string functions.

*/

/*
 *      C/C++ Run Time Library - Version 9.5
 *
 *      Copyright (c) 1987, 1999 by Inprise Corporation
 *      All Rights Reserved.
 *
 */

/* $Revision:   9.5  $ */

#ifndef __STRING_H
#define __STRING_H
#define _INC_STRING  /* MSC Guard name */

#ifndef ___STDDEF_H
>#include <_stddef.h>
>#endif

#if !defined(__STDC__) && defined(__USELOCALES__)
>#if !defined(__LOCALE_H)
>>>#include <locale.h>
>>>#endif
>#endif  /* !__STDC__ && __USELOCALES__ */

#if !defined(RC_INVOKED)

#ifndef __MEM_H
#include <mem.h>  /* All mem... functions have now been moved to MEM.H */
#line 1 "g:\program files\borland\cbuilder4\include\mem.h"
/*  mem.h
#endif

    Memory manipulation functions

*/

/*
 *      C/C++ Run Time Library - Version 9.5
 *
 *      Copyright (c) 1987, 1999 by Inprise Corporation
 *      All Rights Reserved.
 *
 */

/* $Revision:   9.3  $ */

#if !defined(__MEM_H)
#define __MEM_H

#ifndef ___STDDEF_H
>#include <_stddef.h>
>#endif

#if !defined(RC_INVOKED)

#if defined(__STDC__)
>#pragma warn -nak
>#endif

#endif  /* !RC_INVOKED */


#ifdef __cplusplus
>extern "C" {
>#endif

/* Intrinsic functions, defined outside of the namespace */

void _FAR * _RTLENTRY  _EXPFUNC16 __memchr__(const void _FAR * __s, int __c, _SIZE_T __n);
int         _RTLENTRY  _EXPFUNC16 __memcmp__(const void _FAR * __s1, const void _FAR * __s2, _SIZE_T __n);
void _FAR * _RTLENTRY  _EXPFUNC16 __memcpy__(void _FAR * __dest, const void _FAR * __src, _SIZE_T __n);
void _FAR * _RTLENTRYF _EXPFUNC16 __memset__(void _FAR * __s, int __c, _SIZE_T __n);

#ifdef __cplusplus
>namespace std {
>#endif

void _FAR * _RTLENTRY  _EXPFUNC memccpy(void _FAR *__dest, const void _FAR *__src,
                                        int __c, _SIZE_T __n);
int         _RTLENTRY  _EXPFUNC memcmp(const void _FAR *__s1, const void _FAR *__s2,
                                       _SIZE_T __n);
void _FAR * _RTLENTRY  _EXPFUNC memcpy(void _FAR *__dest, const void _FAR *__src,
                                       _SIZE_T __n);
int         _RTLENTRY  _EXPFUNC memicmp(const void _FAR *__s1, const void _FAR *__s2,
                                        _SIZE_T __n);
void _FAR * _RTLENTRYF _EXPFUNC memmove(void _FAR *__dest, const void _FAR *__src,
                                        _SIZE_T __n);
void _FAR * _RTLENTRYF _EXPFUNC memset(void _FAR *__s, int __c, _SIZE_T __n);

void *          _RTLENTRY  _EXPFUNC _wmemset(void *__s, int __c, _SIZE_T __n);
void *          _RTLENTRY  _EXPFUNC _wmemcpy(void *__dest, const void *__src, _SIZE_T __n);

#if defined(__cplusplus)
>extern "C++"
>{
>          void _FAR * _RTLENTRY _EXPFUNC32 memchr(void _FAR *__s, int __c, _SIZE_T __n);
>    const void _FAR * _RTLENTRY _EXPFUNC32 memchr(const void _FAR *__s, int __c, _SIZE_T __n);
>          void      * _RTLENTRY _EXPFUNC32 _wmemchr(void *__s, int __c, _SIZE_T __n);
>    const void      * _RTLENTRY _EXPFUNC32 _wmemchr(const void *__s, int __c, _SIZE_T __n);
>}
>#else
          void _FAR * _RTLENTRY _EXPFUNC32 memchr(const void _FAR *__s, int __c, _SIZE_T __n);
          void      * _RTLENTRY _EXPFUNC32 _wmemchr(const void *__s, int __c, _SIZE_T __n);
#endif



#define movmem(src,dest,length) (void)memmove(dest,src,length)
#define setmem(dest,length,value) (void)memset(dest,value,length)

#if !defined(__STDC__) /* NON_ANSI  */
#define _fmemccpy memccpy
#define _fmemchr  memchr
#define _fmemcmp  memcmp
#define _fmemcpy  memcpy
#define _fmemicmp memicmp
#define _fmemmove memmove
#define _fmemset  memset
#define _fmovmem  movmem
#define _fsetmem  setmem
#endif /* __STDC__  */

#ifdef __cplusplus
>} // std
>} // extern "C"
>#endif

#if !defined(RC_INVOKED)

#if defined(__STDC__)
>#pragma warn .nak
>#endif

#endif  /* !RC_INVOKED */


#endif  /* __MEM_H */

#if defined(__cplusplus) && !defined(__USING_CNAME__) && !defined(__MEM_H_USING_LIST)
>#define __MEM_H_USING_LIST
>   using std::_wmemchr;
>   using std::_wmemcpy;
>   using std::_wmemset;
>   using std::memccpy;
>   using std::memicmp;
>   using std::memmove;
>
>/*
>   Handle intrinsics specially.  If intrinsics are on, the compiler creates
>   a macro of the normal function mapping to the __ intrinsic version, ie:
>     #define strcpy __strcpy__
>   Thus, we can test the normal name as a macro to see if it's defined, and
>   only preform a using statement if it's not an intrinsic
>*/
>
>#  ifndef memchr
>>>     using std::memchr;
>>>#  endif // ifndef memchr
>#  ifndef memcmp
>>>     using std::memcmp;
>>>#  endif // ifndef memcmp
>#  ifndef memcpy
>>>     using std::memcpy;
>>>#  endif // ifndef memcpy
>#  ifndef memset
>>>     using std::memset;
>>>#  endif // ifndef memset
>
>#endif /* __USING_CNAME__ */
//EOF "mem.h"
#line 35 "g:\program files\borland\cbuilder4\include\string.h"

#if defined(__STDC__)
>#pragma warn -nak
>#endif

#endif  /* !RC_INVOKED */

#ifdef __cplusplus
>extern "C" {
>#endif

#ifdef __cplusplus
>namespace std {
>#endif /* __cplusplus */

#define wcscmpi(s1,s2)      _wcsicmp(s1,s2)
#define _wcscmpi(s1,s2)     _wcsicmp(s1,s2)
#define wcsncmpi(s1,s2,n)   _wcsnicmp(s1,s2,n)
#define _wcsncmpi(s1,s2,n)  _wcsnicmp(s1,s2,n)

_SIZE_T          _RTLENTRY  _EXPFUNC wcslen(const wchar_t *__s);
wchar_t *       _RTLENTRY  _EXPFUNC wcscpy(wchar_t *__dst, const wchar_t *__src);
wchar_t *       _RTLENTRY  _EXPFUNC wcscat(wchar_t *__dest, const wchar_t *__src);
wchar_t *       _RTLENTRY  _EXPFUNC wcschr(const wchar_t *__s, int __c);
int             _RTLENTRY  _EXPFUNC wcscmp(const wchar_t *__s1, const wchar_t *__s2);
int             _RTLENTRY  _EXPFUNC wcscoll(const wchar_t * __s1, const wchar_t * __s2);
_SIZE_T          _RTLENTRY  _EXPFUNC wcscspn(const wchar_t *__s1, const wchar_t *__s2);
wchar_t *       _RTLENTRY  _EXPFUNC _wcsdup(const wchar_t *__s);
int             _RTLENTRY  _EXPFUNC wcsncmp(const wchar_t *__s1, const wchar_t *__s2, _SIZE_T __maxlen);
wchar_t *       _RTLENTRY  _EXPFUNC wcsncpy(wchar_t *__dest, const wchar_t *__src, _SIZE_T __maxlen);
wchar_t *       _RTLENTRY  _EXPFUNC _wcsnset(wchar_t *__s, wchar_t __ch, _SIZE_T __n);
wchar_t *       _RTLENTRY  _EXPFUNC wcspbrk(const wchar_t *__s1, const wchar_t *__s2);
wchar_t *       _RTLENTRY  _EXPFUNC wcsrchr(const wchar_t *__s, wchar_t __c);
wchar_t *       _RTLENTRY  _EXPFUNC _wcsrev(wchar_t *__s);
wchar_t *       _RTLENTRY  _EXPFUNC _wcsset(wchar_t*__s, wchar_t __ch);
_SIZE_T          _RTLENTRY  _EXPFUNC wcsspn(const wchar_t *__s1, const wchar_t *__s2);
wchar_t *       _RTLENTRY  _EXPFUNC wcsstr(const wchar_t *__s1, const wchar_t *__s2);
wchar_t *       _RTLENTRY  _EXPFUNC wcstok(wchar_t *__s1, const wchar_t *__s2);
wchar_t *       _RTLENTRY  _EXPFUNC wcsncat(wchar_t *__dest, const wchar_t *__src, _SIZE_T __maxlen);
wchar_t *       _RTLENTRY  _EXPFUNC wcspcpy(wchar_t *__dest, const wchar_t *__src);
wchar_t *       _RTLENTRY  _EXPFUNC _wcspcpy(wchar_t *__dest, const wchar_t *__src);
int             _RTLENTRY  _EXPFUNC _wcsicmp(const wchar_t *__s1, const wchar_t *__s2);
int             _RTLENTRY  _EXPFUNC _wcsnicmp(const wchar_t *__s1, const wchar_t *__s2, _SIZE_T __maxlen);
wchar_t *       _RTLENTRYF _EXPFUNC _wcslwr(wchar_t *__s);
wchar_t *       _RTLENTRYF _EXPFUNC _wcsupr(wchar_t *__s);
wchar_t *       _RTLENTRYF _EXPFUNC _lwcslwr(wchar_t *__s);
wchar_t *       _RTLENTRYF _EXPFUNC _lwcsupr(wchar_t *__s);

char _FAR * _RTLENTRYF _EXPFUNC strcat(char _FAR *__dest, const char _FAR *__src);
int         _RTLENTRYF _EXPFUNC strcmp(const char _FAR *__s1, const char _FAR *__s2);
char _FAR * _RTLENTRYF _EXPFUNC strcpy(char _FAR *__dest, const char _FAR *__src);
_SIZE_T      _RTLENTRY  _EXPFUNC strcspn(const char _FAR *__s1, const char _FAR *__s2);
char _FAR * _RTLENTRY  _EXPFUNC strerror(int __errnum);
_SIZE_T      _RTLENTRYF _EXPFUNC strlen(const char _FAR *__s);
char _FAR * _RTLENTRYF _EXPFUNC strncat(char _FAR *__dest, const char _FAR *__src,
                                        _SIZE_T __maxlen);
int         _RTLENTRYF _EXPFUNC strncmp(const char _FAR *__s1, const char _FAR *__s2,
                                        _SIZE_T __maxlen);
char _FAR * _RTLENTRYF _EXPFUNC strncpy(char _FAR *__dest, const char _FAR *__src,
                                        _SIZE_T __maxlen);
_SIZE_T      _RTLENTRY  _EXPFUNC strspn(const char _FAR *__s1, const char _FAR *__s2);
char _FAR * _RTLENTRYF _EXPFUNC strtok(char _FAR *__s1, const char _FAR *__s2);
char _FAR * _RTLENTRY  _EXPFUNC _strerror(const char _FAR *__s);


#if !defined(__STDC__)
/* compatibility with other compilers */
#define strcmpi(s1,s2)      stricmp(s1,s2)
#define strncmpi(s1,s2,n)   strnicmp(s1,s2,n)

char _FAR * _RTLENTRYF _EXPFUNC   _lstrlwr(char _FAR *__s);
char _FAR * _RTLENTRYF _EXPFUNC   _lstrupr(char _FAR *__s);
char _FAR * _RTLENTRYF _EXPFUNC32 stpcpy(char _FAR *__dest, const char _FAR *__src);
char _FAR * _RTLENTRY  _EXPFUNC32 _stpcpy(char _FAR *__dest, const char _FAR *__src);
char _FAR * _RTLENTRY  _EXPFUNC   strdup(const char _FAR *__s);
int         _RTLENTRYF _EXPFUNC   stricmp(const char _FAR *__s1, const char _FAR *__s2);
char _FAR * _RTLENTRYF _EXPFUNC   strlwr(char _FAR *__s);
int         _RTLENTRYF _EXPFUNC   strnicmp(const char _FAR *__s1, const char _FAR *__s2,
                                           _SIZE_T __maxlen);
char _FAR * _RTLENTRY  _EXPFUNC   strnset(char _FAR *__s, int __ch, _SIZE_T __n);
char _FAR * _RTLENTRY  _EXPFUNC   strrev(char _FAR *__s);
char _FAR * _RTLENTRY  _EXPFUNC   strset(char _FAR *__s, int __ch);
char _FAR * _RTLENTRYF _EXPFUNC   strupr(char _FAR *__s);
#endif  /* !__STDC__ */


#if defined(__cplusplus)
>extern "C++"
>{
>          char _FAR * _RTLENTRYF _EXPFUNC   strchr(char _FAR * __s, int __c);
>    const char _FAR * _RTLENTRYF _EXPFUNC   strchr(const char _FAR * __s, int __c);
>          char _FAR * _RTLENTRYF _EXPFUNC   strrchr(char _FAR *__s, int __c);
>    const char _FAR * _RTLENTRYF _EXPFUNC   strrchr(const char _FAR *__s, int __c);
>          char _FAR * _RTLENTRYF _EXPFUNC   strpbrk(char _FAR *__s1, const char _FAR *__s2);
>    const char _FAR * _RTLENTRYF _EXPFUNC   strpbrk(const char _FAR *__s1, const char _FAR *__s2);
>          char _FAR * _RTLENTRY  _EXPFUNC   strstr(char _FAR *__s1, const char _FAR *__s2);
>    const char _FAR * _RTLENTRY  _EXPFUNC   strstr(const char _FAR *__s1, const char _FAR *__s2);
>}
>#else
          char _FAR * _RTLENTRYF _EXPFUNC   strchr(const char _FAR * __s, int __c);
          char _FAR * _RTLENTRYF _EXPFUNC   strrchr(const char _FAR *__s, int __c);
          char _FAR * _RTLENTRYF _EXPFUNC   strpbrk(const char _FAR *__s1, const char _FAR *__s2);
          char _FAR * _RTLENTRY  _EXPFUNC   strstr(const char _FAR *__s1, const char _FAR *__s2);
#endif


/* Intrinsic functions */

/* Intrinsics must be prototyped outside of any namespace */
#ifdef __cplusplus
>} // std
>#endif /* __cplusplus */

char _FAR * _RTLENTRY             __stpcpy__(char _FAR *__dest, const char _FAR *__src);
char _FAR * _RTLENTRYF _EXPFUNC16 __strcat__(char _FAR *__dest, const char _FAR *__src);
char _FAR * _RTLENTRY  _EXPFUNC16 __strchr__(const char _FAR *__s, int __c);
int         _RTLENTRYF _EXPFUNC16 __strcmp__(const char _FAR *__s1, const char _FAR *__s2);
char _FAR * _RTLENTRYF _EXPFUNC16 __strcpy__(char _FAR *__dest, const char _FAR *__src);
_SIZE_T     _RTLENTRYF _EXPFUNC16 __strlen__(const char _FAR *__s);
char _FAR * _RTLENTRY  _EXPFUNC16 __strncat__(char _FAR *__dest, const char _FAR *__src,
                                              _SIZE_T __maxlen);
int         _RTLENTRY  _EXPFUNC16 __strncmp__(const char _FAR *__s1, const char _FAR *__s2,
                                              _SIZE_T __maxlen);
char _FAR * _RTLENTRYF _EXPFUNC16 __strncpy__(char _FAR *__dest, const char _FAR *__src,
                                              _SIZE_T __maxlen);
char _FAR * _RTLENTRY  _EXPFUNC16 __strnset__(char _FAR *__s, int __ch, _SIZE_T __n);
char _FAR * _RTLENTRYF _EXPFUNC16 __strrchr__(const char _FAR *__s, int __c);
char _FAR * _RTLENTRY  _EXPFUNC16 __strset__(char _FAR *__s, int __ch);

/* Now that the intrinsics are finished, turn the namespace back on */
#ifdef __cplusplus
>namespace std {
>#endif /* __cplusplus */


#if defined(__MSC) && !defined(__MFC_COMPAT__)
>#define _stricmp(s1,s2) stricmp(s1,s2)
>#define _strdup(s1)     strdup(s1)
>#define _strupr(s1)     strupr(s1)
>#define _strlwr(s1)     strlwr(s1)
>#define _strrev(s1)     strrev(s1)
>#endif  /* __MSC */

#if defined(__MFC_COMPAT__)
>inline char _FAR * _RTLENTRY  _strrev(char _FAR *__s) { return strrev(__s); }
>
>inline char _FAR * _RTLENTRY  _strset(char _FAR *__s, int __ch)
>                              { return strset(__s, __ch); }
>inline char _FAR * _RTLENTRY  _strnset(char _FAR *__s, int __ch, _SIZE_T __n)
>                              { return strnset(__s, __ch, __n); }
>inline char _FAR * _RTLENTRYF _strupr(char _FAR *__s) { return strupr(__s); }
>
>inline char _FAR * _RTLENTRYF _strlwr(char _FAR *__s) { return strlwr(__s); }
>
>inline char _FAR * _RTLENTRY  _strdup(const char _FAR *__s)
>                              { return strdup(__s); }
>inline int         _RTLENTRYF _strcmpi(const char _FAR *__s1, const char _FAR *__s2)
>                              { return stricmp (__s1, __s2); }
>inline int         _RTLENTRYF _stricmp(const char _FAR *__s1, const char _FAR *__s2)
>                              { return stricmp (__s1, __s2); }
>inline int         _RTLENTRYF _strcmp(const char _FAR *__s1, const char _FAR *__s2)
>                              { return strcmp (__s1, __s2); }
>inline int         _RTLENTRYF _strnicmp(const char _FAR *__s1, const char _FAR *__s2, _SIZE_T __maxlen)
>                              { return strnicmp (__s1, __s2, __maxlen); }
>#endif

int    _RTLENTRY  _EXPFUNC _lstrcoll(const char * __s1, const char * __s2);
int    _RTLENTRY  _EXPFUNC _lstricoll(const char * __s1, const char * __s2);
int    _RTLENTRY  _EXPFUNC _lstrncoll(const char * __s1, const char * __s2, const int __len);
int    _RTLENTRY  _EXPFUNC _lstrnicoll(const char * __s1, const char * __s2, int __len);
_SIZE_T _RTLENTRY  _EXPFUNC _lstrxfrm(char * __s1, const char * __s2,_SIZE_T __n );
int    _RTLENTRY  _EXPFUNC strcoll(const char * __s1, const char * __s2);
int    _RTLENTRY  _EXPFUNC _stricoll(const char * __s1, const char * __s2);
int    _RTLENTRY  _EXPFUNC _strncoll(const char * __s1, const char * __s2, _SIZE_T __n);
int    _RTLENTRY  _EXPFUNC _strnicoll(const char * __s1, const char * __s2, int __len);
_SIZE_T _RTLENTRY  _EXPFUNC strxfrm(char * __s1, const char * __s2,_SIZE_T __n );

int    _RTLENTRY  _EXPFUNC _lwcscoll(const wchar_t * __s1, const wchar_t * __s2);
int    _RTLENTRY  _EXPFUNC _lwcsicoll(const wchar_t * __s1, const wchar_t * __s2);
int    _RTLENTRY  _EXPFUNC _lwcsncoll(const wchar_t * __s1, const wchar_t * __s2, const int __len);
int    _RTLENTRY  _EXPFUNC _lwcsnicoll(const wchar_t * __s1, const wchar_t * __s2, int __len);
_SIZE_T _RTLENTRY  _EXPFUNC _lwcsxfrm(wchar_t * __s1, const wchar_t * __s2,_SIZE_T __n );
int    _RTLENTRY  _EXPFUNC wcscoll(const wchar_t * __s1, const wchar_t * __s2);
int    _RTLENTRY  _EXPFUNC _wcsicoll(const wchar_t * __s1, const wchar_t * __s2);
int    _RTLENTRY  _EXPFUNC _wcsncoll(const wchar_t * __s1, const wchar_t * __s2, _SIZE_T __n);
int    _RTLENTRY  _EXPFUNC _wcsnicoll(const wchar_t * __s1, const wchar_t * __s2, int __len);
_SIZE_T _RTLENTRY  _EXPFUNC wcsxfrm(wchar_t * __s1, const wchar_t * __s2, _SIZE_T __n );


#if !defined(__STDC__) /* NON_ANSI  */
#define _fstrcat   strcat
#define _fstrchr   strchr
#define _fstrcmp   strcmp
#define _fstrcpy   strcpy
#define _fstrcspn  strcspn
#define _fstrdup   strdup
#define _fstricmp  stricmp
#define _fstrlen   strlen
#define _fstrlwr   strlwr
#define _fstrncat  strncat
#define _fstrncmp  strncmp
#define _fstrncpy  strncpy
#define _fstrnicmp strnicmp
#define _fstrnset  strnset
#define _fstrpbrk  strpbrk
#define _fstrrchr  strrchr
#define _fstrrev   strrev
#define _fstrset   strset
#define _fstrspn   strspn
#define _fstrstr   strstr
#define _fstrtok   strtok
#define _fstrupr   strupr
#endif /* __STDC__  */

#if defined(__USELOCALES__)
>#define  strupr     _lstrupr
>#define  strlwr     _lstrlwr
>#define  strcoll    _lstrcoll
>#define  stricoll   _lstricoll
>#define  strncoll   _lstrncoll
>#define  strnicoll  _lstrnicoll
>#define  strxfrm    _lstrxfrm
>#endif  /* __USELOCALES__ */

#if !defined(RC_INVOKED)

#if defined(__STDC__)
>#pragma warn .nak
>#endif

#endif  /* !RC_INVOKED */

#ifdef __cplusplus
>} // std
>#endif /* __cplusplus */

#ifdef __cplusplus
>}
>#endif

#endif  /* __STRING_H */

#if defined(__cplusplus) && !defined(__USING_CNAME__) && !defined(__STRING_H_USING_LIST)
>#define __STRING_H_USING_LIST
>#if !defined(__STDC__)
>>>     using std::_lstrlwr;
>>>     using std::_lstrupr;
>>>     using std::_stpcpy;
>>>     using std::strdup;
>>>     using std::stricmp;
>>>     using std::strlwr;
>>>     using std::strnicmp;
>>>     using std::strrev;
>>>     using std::strupr;
>>>#endif
>#if defined(__MFC_COMPAT__)
>>>
>>>     using std::_strrev;
>>>     using std::_strset;
>>>     using std::_strnset;
>>>     using std::_strupr;
>>>     using std::_strdup;
>>>     using std::_strlwr;
>>>     using std::_strcmpi;
>>>     using std::_stricmp;
>>>     using std::_strcmp;
>>>     using std::_strnicmp;
>>>#endif
>     using std::_lstrcoll;
>     using std::_lstricoll;
>     using std::_lstrncoll;
>     using std::_lstrnicoll;
>     using std::_lstrxfrm;
>     using std::_lwcscoll;
>     using std::_lwcsicoll;
>     using std::_lwcslwr;
>     using std::_lwcsncoll;
>     using std::_lwcsnicoll;
>     using std::_lwcsupr;
>     using std::_lwcsxfrm;
>     using std::_strerror;
>     using std::_stricoll;
>     using std::_strncoll;
>     using std::_strnicoll;
>     using std::_wcsdup;
>     using std::_wcsicmp;
>     using std::_wcsicoll;
>     using std::_wcslwr;
>     using std::_wcsncoll;
>     using std::_wcsnicmp;
>     using std::_wcsnicoll;
>     using std::_wcsnset;
>     using std::_wcspcpy;
>     using std::_wcsrev;
>     using std::_wcsset;
>     using std::_wcsupr;
>
>/*
>   Handle intrinsics specially.  If intrinsics are on, the compiler creates
>   a macro of the normal function mapping to the __ intrinsic version, ie:
>     #define strcpy __strcpy__
>   Thus, we can test the normal name as a macro to see if it's defined, and
>   only preform a using statement if it's not an intrinsic
>*/
>
>#if !defined(__STDC__)
>>>#    ifndef strnset
>>>>>    using std::strnset;
>>>>>#    endif // ifndef strnset
>>>#    ifndef stpcpy
>>>>>    using std::stpcpy;
>>>>>#    endif // ifndef stpcpy
>>>#    ifndef strset
>>>>>    using std::strset;
>>>>>#    endif // ifndef strset
>>>#endif // __STDC__
>
>#    ifndef strcat
>>>    using std::strcat;
>>>#    endif // ifndef strcat
>#    ifndef strchr
>>>    using std::strchr;
>>>#    endif // ifndef strchr
>#    ifndef strcmp
>>>    using std::strcmp;
>>>#    endif // ifndef strcmp
>#    ifndef strcpy
>>>    using std::strcpy;
>>>#    endif // ifndef strcpy
>#    ifndef strlen
>>>    using std::strlen;
>>>#    endif // ifndef strlen
>#    ifndef strncat
>>>    using std::strncat;
>>>#    endif // ifndef strncat
>#    ifndef strncmp
>>>    using std::strncmp;
>>>#    endif // ifndef strncmp
>#    ifndef strncpy
>>>    using std::strncpy;
>>>#    endif // ifndef strncpy
>#    ifndef strrchr
>>>    using std::strrchr;
>>>#    endif // ifndef strrchr
>
>     using std::strcspn;
>     using std::strerror;
>     using std::strpbrk;
>     using std::strspn;
>     using std::strstr;
>     using std::strtok;
>     using std::strxfrm;
>     using std::strcoll;
>
>     using std::wcscat;
>     using std::wcschr;
>     using std::wcscmp;
>     using std::wcscoll;
>     using std::wcscpy;
>     using std::wcscspn;
>     using std::wcslen;
>     using std::wcsncat;
>     using std::wcsncmp;
>     using std::wcsncpy;
>     using std::wcspbrk;
>     using std::wcspcpy;
>     using std::wcsrchr;
>     using std::wcsspn;
>     using std::wcsstr;
>     using std::wcstok;
>     using std::wcsxfrm;
>#endif /* __USING_CNAME__ */

#if defined(__USING_STD_NAMES__) && !defined(__STD_STRING)
>#  include <string.stl>
>#endif  /* __USING_STD_NAMES__ */
//EOF "string.h"
#line 82 "f:\dodi.cj\archivers\arc-5.21e\arc.c"
#if	!__STDC__
char		*calloc(), *malloc(), *realloc();
#endif

VOID		addarc(), delarc(), extarc(), lstarc(), tstarc(), cvtarc(), runarc();
VOID		arcdie();
static	VOID	expandlst();
#if	_MTS
>VOID		etoa();
>#endif
#if	GEMDOS
>long		_stksize = 30720;
>#endif
char		*makefnam();	/* filename fixup routine */

static char   **lst;		/* files list */
static int	lnum;		/* length of files list */

main(num, arg)			/* system entry point */

	int		num;	/* number of arguments */
	char	       *arg[];	/* pointers to arguments */
{
	char		opt = 0;/* selected action */
	char	       *a;	/* option pointer */
	VOID		upper();/* case conversion routine */
	char	       *index();/* string index utility */
	char	       *envfind();	/* environment searcher */
	int		n;	/* index */
	char	       *arctemp2, *mktemp();
#if	GEMDOS
>	VOID		exitpause();
>	int		append;
>#endif
#if	_MTS
>	fortran VOID	guinfo();
>	char		gotinf[4];
>#endif
#if	UNIX
>	struct	stat	sbuf;
>#endif

	if (num < 3) {
		printf("ARC - Archive utility, Version 5.21e, created on 10/30/91 at 14:30:21\n");
/*		printf("(C) COPYRIGHT 1985,86,87 by System Enhancement Associates;");
		printf(" ALL RIGHTS RESERVED\n\n");
		printf("Please refer all inquiries to:\n\n");
		printf("       System Enhancement Associates\n");
		printf("       21 New Street, Wayne NJ 07470\n\n");
		printf("You may copy and distribute this program freely,");
		printf(" provided that:\n");
		printf("    1)	 No fee is charged for such copying and");
		printf(" distribution, and\n");
		printf("    2)	 It is distributed ONLY in its original,");
		printf(" unmodified state.\n\n");
		printf("If you like this program, and find it of use, then your");
		printf(" contribution will\n");
		printf("be appreciated.	 You may not use this product in a");
		printf(" commercial environment\n");
		printf("or a governmental organization without paying a license");
		printf(" fee of $35.  Site\n");
		printf("licenses and commercial distribution licenses are");
		printf(" available.  A program\n");
		printf("disk and printed documentation are available for $50.\n");
		printf("\nIf you fail to abide by the terms of this license, ");
		printf(" then your conscience\n");
		printf("will haunt you for the rest of your life.\n\n"); */
#if	MSDOS
>		printf("Usage: ARC {amufdxerplvtc}[bswnoq][g<password>]");
>#endif
#if	GEMDOS
>		printf("Usage: ARC {amufdxerplvtc}[bhswnoq][g<password>]");
>#endif
#if	UNIX
>		printf("Usage: arc {amufdxerplvtc}[biswnoq][g<password>]");
>#endif
#if	_MTS
>		printf("Parameters: {amufdxeplvtc}[biswnoq][g<password>]");
>#endif
		printf(" <archive> [<filename> . . .]\n");
		printf("Where:	 a   = add files to archive\n");
		printf("	 m   = move files to archive\n");
		printf("	 u   = update files in archive\n");
		printf("	 f   = freshen files in archive\n");
		printf("	 d   = delete files from archive\n");
		printf("	 x,e = extract files from archive\n");
#if	!_MTS
		printf("	 r   = run files from archive\n");
#endif
		printf("	 p   = copy files from archive to");
		printf(" standard output\n");
		printf("	 l   = list files in archive\n");
		printf("	 v   = verbose listing of files in archive\n");
		printf("	 t   = test archive integrity\n");
		printf("	 c   = convert entry to new packing method\n");
		printf("	 b   = retain backup copy of archive\n");
#if	GEMDOS
>		printf("	 h   = hold screen after finishing\n");
>#endif
#if	_MTS
>		printf("	 i   = suppress ASCII/EBCDIC translation\n");
>#endif
#if	UNIX
>		printf("	 i   = suppress image mode (translate EOL)\n");
>#endif
		printf("	 s   = suppress compression (store only)\n");
		printf("	 w   = suppress warning messages\n");
		printf("	 n   = suppress notes and comments\n");
		printf("	 o   = overwrite existing files when");
		printf(" extracting\n");
		printf("	 q   = squash instead of crunching\n");
		printf("	 g   = Encrypt/decrypt archive entry\n");
		printf("\nAdapted from MSDOS by Howard Chu\n");
		/*
		 * printf("\nPlease refer to the program documentation for");
		 * printf(" complete instructions.\n"); 
		 */
#if	GEMDOS
>		exitpause();
>#endif
		return 1;
	}
	/* see where temp files go */
#if	!_MTS
	arctemp = calloc(1, STRLEN);
	if (!(arctemp2 = envfind("ARCTEMP")))
		arctemp2 = envfind("TMPDIR");
	if (arctemp2) {
		strcpy(arctemp, arctemp2);
		n = strlen(arctemp);
		if (arctemp[n - 1] != CUTOFF)
			arctemp[n] = CUTOFF;
	}
#if	UNIX
>	else	strcpy(arctemp, "/tmp/");
>#endif
#if	!MSDOS
	{
		static char tempname[] = "AXXXXXX";
		strcat(arctemp, mktemp(tempname));
	}
#else
>>	strcat(arctemp, "$ARCTEMP");
>>#endif
#else
>>	guinfo("SHFSEP	", gotinf);
>>	sepchr[0] = gotinf[0];
>>	guinfo("SCRFCHAR", gotinf);
>>	tmpchr[0] = gotinf[0];
>>	arctemp = "-$$$";
>>	arctemp[0] = tmpchr[0];
>>#endif
	arctemp2 = NULL;

#if	!UNIX
	/* avoid any case problems with arguments */

	for (n = 1; n < num; n++)	/* for each argument */
		upper(arg[n]);	/* convert it to uppercase */
#else
>>	/* avoid case problems with command options */
>>	upper(arg[1]);		/* convert to uppercase */
>>#endif

	/* create archive names, supplying defaults */
#if	UNIX
>	if (!stat(arg[2],&sbuf)) {
>		if ((sbuf.st_mode & S_IFMT) == S_IFDIR)
>			makefnam(arg[2],".arc",arcname);
>		else
>			strcpy(arcname,arg[2]);
>	} else
>		makefnam(arg[2],".arc",arcname);
>#else
	makefnam(arg[2], ".ARC", arcname);
#endif
	/* makefnam(".$$$",arcname,newname); */
	sprintf(newname, "%s.arc", arctemp);
	makefnam(".BAK", arcname, bakname);

	/* now scan the command and see what we are to do */

	for (a = arg[1]; *a; a++) {	/* scan the option flags */
#if	!_MTS
		if (index("AMUFDXEPLVTCR", *a)) {	/* if a known command */
#else
>>		if (index("AMUFDXEPLVTC", *a)) {
>>#endif
			if (opt)/* do we have one yet? */
				arcdie("Cannot mix %c and %c", opt, *a);
			opt = *a;	/* else remember it */
		} else if (*a == 'B')	/* retain backup copy */
			keepbak = 1;

		else if (*a == 'W')	/* suppress warnings */
			warn = 0;
#if	!DOS
		else if (*a == 'I')	/* image mode, no ASCII/EBCDIC x-late */
			image = !image;
#endif
#if	GEMDOS
>		else if (*a == 'H')	/* pause before exit */
>			hold = 1;
>#endif

		else if (*a == 'N')	/* suppress notes and comments */
			note = 0;

		else if (*a == 'O')	/* overwrite file on extract */
			overlay = 1;

		else if (*a == 'G') {	/* garble */
			password = a + 1;
			while (*a)
				a++;
			a--;
#if	_MTS
>			etoa(password, strlen(password));
>#endif
		} else if (*a == 'S')	/* storage kludge */
			nocomp = 1;

		else if (*a == 'K')	/* special kludge */
			kludge = 1;

		else if (*a == 'Q')	/* use squashing */
			dosquash = 1;

		else if (*a == '-' || *a == '/')	/* UNIX and PC-DOS
							 * option markers */
			;

		else
			arcdie("%c is an unknown command", *a);
	}

	if (!opt)
		arcdie("I have nothing to do!");

	/* get the files list set up */

	lnum = num - 3;		/* initial length of list */
	lst = (char **) calloc((lnum==0) ? 1:lnum,
				 sizeof(char *));	/* initial list */
	for (n = 3; n < num; n++)
		lst[n - 3] = arg[n];

	for (n = 0; n < lnum;) {/* expand indirect references */
		if (*lst[n] == '@')
			expandlst(n);
#if	GEMDOS		/* redirect stdout from the desktop...*/
>		else if (*lst[n] == '>') {
>			arctemp2 = (++lst[n]);
>			lst[n] = lst[--lnum];	/* delete this entry */
>			if (arctemp2[0] == '>') {
>				append = 1;
>				arctemp2++;
>			}
>			else	append = 0;
>		}
>#endif
		else
			n++;
	}
#if	GEMDOS
>	if (arctemp2)
>		freopen(arctemp2,append ? "a" : "w",stdout);
>#endif

	/* act on whatever action command was given */

	switch (opt) {		/* action depends on command */
	case 'A':		/* Add */
	case 'M':		/* Move */
	case 'U':		/* Update */
	case 'F':		/* Freshen */
		addarc(lnum, lst, (opt == 'M'), (opt == 'U'), (opt == 'F'));
		break;

	case 'D':		/* Delete */
		delarc(lnum, lst);
		break;

	case 'E':		/* Extract */
	case 'X':		/* eXtract */
	case 'P':		/* Print */
		extarc(lnum, lst, (opt == 'P'));
		break;

	case 'V':		/* Verbose list */
		bose = 1;
	case 'L':		/* List */
		lstarc(lnum, lst);
		break;

	case 'T':		/* Test */
		tstarc();
		break;

	case 'C':		/* Convert */
		cvtarc(lnum, lst);
		break;
#if	!_MTS
	case 'R':		/* Run */
		runarc(lnum, lst);
		break;
#endif
	default:
		arcdie("I don't know how to do %c yet!", opt);
	}
#if	GEMDOS
>	if (hold)
>		exitpause();
>#endif
	return nerrs;
}
static	VOID
expandlst(n)			/* expand an indirect reference */
	int		n;	/* number of entry to expand */
{
	FILE	       *lf, *fopen();	/* list file, opener */
	char		buf[100];	/* input buffer */
	int		x;	/* index */
	char	       *p = lst[n] + 1; /* filename pointer */

	if (*p) {		/* use name if one was given */
		makefnam(p, ".CMD", buf);
		if (!(lf = fopen(buf, "r")))
			arcdie("Cannot read list of files in %s", buf);
	} else
		lf = stdin;	/* else use standard input */

	for (x = n + 1; x < lnum; x++)	/* drop reference from the list */
		lst[x - 1] = lst[x];
	lnum--;

	while (fscanf(lf, "%99s", buf) > 0) {	/* read in the list */
		if (!(lst =(char **)realloc(lst, (lnum + 1) * sizeof(char *))))
			arcdie("too many file references");

		lst[lnum] = malloc(strlen(buf) + 1);
		strcpy(lst[lnum], buf); /* save the name */
		lnum++;
	}

	if (lf != stdin)	/* avoid closing standard input */
		fclose(lf);
}
//EOF "arc.c"
#line 9 "f:\dodi.d7\cscan\topas.06\parsetest.c"
//#pragma Module "test1.c"

//EOF "parsetest.c"
// EOF
