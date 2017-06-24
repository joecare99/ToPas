/*test some special cases
adfaaf
*/
//forward declarations?
struct fwstruct;
struct _tag {
  struct { int a, b, c; } ms;
  long l;
}; //svar;

typedef struct {
  union { int a, b, c:5; } ms;
  long l;
} s;

unsigned short _chartype[256];
int type;
typedef int FnCallback(long arg);
static
void private() { puts("static"); }

typedef enum {e1, e2} E1, *E2;

#define TEST
typedef unsigned long ULONG;
typedef ULONG *PULONG;

#pragma Define MAX_PATH const # = ##;
#define MAX_PATH  260
char path[MAX_PATH];

const char* ls = L"unicode";
const char* aChar = 'x';

void __fastcall Proc(int arg);
int i;
const c = 99;

#define macro(arg) puts("macro" ## arg);

int pubint;
static long lcllong;
volatile long long LongLong;

void public() { puts("global"); }

void test(v)
int v;
{ puts("test"); }

