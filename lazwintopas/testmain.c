static char   **lst;		/* files list */
static int	lnum;		/* length of files list */
extern void arcdie(char *s);
extern void puts(char *s);
extern void *realloc(void *p, int n);
//int
main(argc, argv)
int argc;
char* argv;
{
  if (!(lst =(char **)realloc(lst, (lnum + 1) * sizeof(char *))))
	arcdie("too many file references");
 puts("test");
}

