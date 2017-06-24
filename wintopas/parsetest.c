/*test some special cases
*/
#include "bcb4.def"
//#pragma Include "G:\Program Files\Borland\CBuilder4\Include\"

#define SevenZip

#if 0
#pragma Module "test1.c"
//#pragma Module "testmain.c"
//#pragma Module "..\snapshot.c"
#elif defined(SevenZip)
  #pragma Source "V:\Downloads\7zip\7zip\Archive\7z_C"
  #pragma Module "7zMain.c"
#else
  #define	_EXPFUNC extern
  #define __export extern
  #define __import extern
  //#define main int main

  #pragma Source "F:\DoDi.CJ\archivers\arc-5.21e\"
  #pragma Module "arc.c"
#endif
