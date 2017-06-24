
/*test some special cases
*/
#line 3 "f:\dodi.d7\cscan\topas.06\parsetest.c"
#line 11
(num, arg)/* system entry point */
#line 102 "f:\dodi.cj\archivers\arc-5.21e\arc.c"
 int num;/* number of arguments */
 char *arg[];/* pointers to arguments */
{
 char opt = 0;/* selected action */
 char *a;/* option pointer */
 int upper();/* case conversion routine */
 char *index();/* string index utility */
 char * getenv();/* environment searcher */
 int n;/* index */
 char *arctemp2, *mktemp();
#line 124
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
#line 161
  printf(" <archive> [<filename> . . .]\n");
  printf("Where:\t a   = add files to archive\n");
  printf("\t m   = move files to archive\n");
  printf("\t u   = update files in archive\n");
  printf("\t f   = freshen files in archive\n");
  printf("\t d   = delete files from archive\n");
  printf("\t x,e = extract files from archive\n");
#line 169
  printf("\t r   = run files from archive\n");
#line 171
  printf("\t p   = copy files from archive to");
  printf(" standard output\n");
  printf("\t l   = list files in archive\n");
  printf("\t v   = verbose listing of files in archive\n");
  printf("\t t   = test archive integrity\n");
  printf("\t c   = convert entry to new packing method\n");
  printf("\t b   = retain backup copy of archive\n");
#line 187
  printf("\t s   = suppress compression (store only)\n");
  printf("\t w   = suppress warning messages\n");
  printf("\t n   = suppress notes and comments\n");
  printf("\t o   = overwrite existing files when");
  printf(" extracting\n");
  printf("\t q   = squash instead of crunching\n");
  printf("\t g   = Encrypt/decrypt archive entry\n");
  printf("\nAdapted from MSDOS by Howard Chu\n");
  /*
		 * printf("\nPlease refer to the program documentation for");
		 * printf(" complete instructions.\n"); 
		 */
#line 202
  return 1;
 }
 /* see where temp files go */
#line 206
 arctemp = calloc(1, 100/* system standard string length */);
 if (!(arctemp2 = getenv("ARCTEMP")))
  arctemp2 = getenv("TMPDIR");
 if (arctemp2) {
  strcpy(arctemp, arctemp2);
  n = strlen(arctemp);
  if (arctemp[n - 1] != CUTOFF)
   arctemp[n] = CUTOFF;
 }
#line 219
 {
  static char tempname[] = "AXXXXXX";
  strcat(arctemp, mktemp(tempname));
 }
#line 234
 arctemp2 = ((void *)0);
#line 237
 /* avoid any case problems with arguments */
#line 239
 for (n = 1; n < num; n++)/* for each argument */
  upper(arg[n]);/* convert it to uppercase */
#line 246
 /* create archive names, supplying defaults */
#line 256
 makefnam(arg[2], ".ARC", arcname);
#line 258
 /* makefnam(".$$$",arcname,newname); */
 sprintf(newname, "%s.arc", arctemp);
 makefnam(".BAK", arcname, bakname);
#line 262
 /* now scan the command and see what we are to do */
#line 264
 for (a = arg[1]; *a; a++) {/* scan the option flags */
#line 266
  if (index("AMUFDXEPLVTCR", *a)) {/* if a known command */
#line 270
   if (opt)/* do we have one yet? */
    arcdie("Cannot mix %c and %c", opt, *a);
   opt = *a;/* else remember it */
  } else if (*a == 'B')/* retain backup copy */
   keepbak = 1;
#line 276
  else if (*a == 'W')/* suppress warnings */
   warn = 0;
#line 279
  else if (*a == 'I')/* image mode, no ASCII/EBCDIC x-late */
   image = !image;
#line 287
  else if (*a == 'N')/* suppress notes and comments */
   note = 0;
#line 290
  else if (*a == 'O')/* overwrite file on extract */
   overlay = 1;
#line 293
  else if (*a == 'G') {/* garble */
   password = a + 1;
   while (*a)
    a++;
   a--;
#line 301
  } else if (*a == 'S')/* storage kludge */
   nocomp = 1;
#line 304
  else if (*a == 'K')/* special kludge */
   kludge = 1;
#line 307
  else if (*a == 'Q')/* use squashing */
   dosquash = 1;
#line 310
  else if (*a == '-' || *a == '/')/* UNIX and PC-DOS
							 * option markers */
#line 312
   ;
#line 314
  else
   arcdie("%c is an unknown command", *a);
 }
#line 318
 if (!opt)
  arcdie("I have nothing to do!");
#line 321
 /* get the files list set up */
#line 323
 lnum = num - 3;/* initial length of list */
 lst = (char **) calloc((lnum==0) ? 1:lnum,
     sizeof(char *));/* initial list */
 for (n = 3; n < num; n++)
  lst[n - 3] = arg[n];
#line 329
 for (n = 0; n < lnum;) {/* expand indirect references */
  if (*lst[n] == '@')
   expandlst(n);
#line 343
  else
   n++;
 }
#line 351
 /* act on whatever action command was given */
#line 353
 switch (opt) {/* action depends on command */
 case 'A':/* Add */
 case 'M':/* Move */
 case 'U':/* Update */
 case 'F':/* Freshen */
  addarc(lnum, lst, (opt == 'M'), (opt == 'U'), (opt == 'F'));
  break;
#line 361
 case 'D':/* Delete */
  delarc(lnum, lst);
  break;
#line 365
 case 'E':/* Extract */
 case 'X':/* eXtract */
 case 'P':/* Print */
  extarc(lnum, lst, (opt == 'P'));
  break;
#line 371
 case 'V':/* Verbose list */
  bose = 1;
 case 'L':/* List */
  lstarc(lnum, lst);
  break;
#line 377
 case 'T':/* Test */
  tstarc();
  break;
#line 381
 case 'C':/* Convert */
  cvtarc(lnum, lst);
  break;
#line 385
 case 'R':/* Run */
  runarc(lnum, lst);
  break;
#line 389
 default:
  arcdie("I don't know how to do %c yet!", opt);
 }
#line 396
 return nerrs;
}
static int
expandlst(n)/* expand an indirect reference */
 int n;/* number of entry to expand */
{
 FILE *lf, *fopen();/* list file, opener */
 char buf[100];/* input buffer */
 int x;/* index */
 char *p = lst[n] + 1;/* filename pointer */
#line 407
 if (*p) {/* use name if one was given */
  makefnam(p, ".CMD", buf);
  if (!(lf = fopen(buf, "r")))
   arcdie("Cannot read list of files in %s", buf);
 } else
  lf = (&_streams[0]);/* else use standard input */
#line 414
 for (x = n + 1; x < lnum; x++)/* drop reference from the list */
  lst[x - 1] = lst[x];
 lnum--;
#line 418
 while (fscanf(lf, "%99s", buf) > 0) {/* read in the list */
  if (!(lst =(char **)realloc(lst, (lnum + 1) * sizeof(char *))))
   arcdie("too many file references");
#line 422
  lst[lnum] = malloc(strlen(buf) + 1);
  strcpy(lst[lnum], buf);/* save the name */
  lnum++;
 }
#line 427
 if (lf != (&_streams[0]))/* avoid closing standard input */
  fclose(lf);
}
#line 12 "f:\dodi.d7\cscan\topas.06\parsetest.c"
//#pragma Module "test1.c"
//EOF
