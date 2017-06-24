unit uTablesC;
(* all tables for C parser:
  - symbols
  - typedefs
  - names (vars, members...)

ToDo:
- add (public) symbol objects to preprocessor/scanner table.
  (requires symID passed to symbol constructor)
  (handle constants etc. created from macros?)
+ added scope to type (static only, for now)
- problem: define unique (internal) sized types!
  int#_t is typedef'd! -> restore __int8 etc. type names?
~ mark constants from enum members as synthetic!
  (flag and don't save)
  Workaround: Check sym.Def for 'E' or '"E:...'
*)

(* typedef grammar overview
(...) sequence
[...] optional [0..1]
{...} repetition [0..n]
| alternative

Type = Qualified | Array | Pointer | ProcType | Struct_Union | Enum | Typename | Basetype.
Qualified = ( "#" | "V" ) Type.
  /* #=const (locked) V=volatile */
Array = "[" [dim] "]" Type.
Pointer = "*" Type. //add: "&" reference
ProcType = "(" { Param "," } [ ":~," ] ")" CallConv Type.
  /* ":~," stands for a "..." variable argument list */
  Param = [ name ] ":" [PMod] [Type]. /* either name or Type must be specified */
    PMod = "r"|"v"|"c"|"o"|"?" /* Ref=Var/Val/Const=In/Out/unknown */
  CallConv = ["I"] ["F" | "C"]. /* Inline, Fastcall, Cdecl (default Stdcall) */
/* final types */
Struct_Union = ( "S" | "U" ) ( "#" num | ":" tagname | "{" { Field "," }"}" ).
  Field = [ name ] ":" BitType. /* only here a Bitfield type is allowed */
    BitType = [ "<" bitsize ";>" ] Basetype.
Enum = "E" ( "#" num | ":" tagname | "{" { name ["=" Value]} "," } "}".
Typename = '"' name '"'. /* in double quotes */
/* basic types are: unsigned, signed, void, char, short, int, long, "long long", float, double, "long double", "..." */
Basetype = [ ("+"|"-") [size] ] ( "v"|"c"|"s"|"u"|"i"|"l"|"L"|"f"|"d"|"D"|"~" ).
    /* a "signed" ("-") prefix may be used for char types */
Value = (name | num";" | ["L"]("string"|'char')";"). /* also expression? */
*)
(* Problems:
  Distinguish proc/func? -> first args optional: this, result
  Distinguish Struct/Union/Enum from other types?
  Char types?
  Modifiers? (scope, callconv, param, bitfields, strings)
a   sym:argument
b
C class, pmod:cdecl
c char, pmod:constructor, sym:const
D long double (extended)
d double, pmod:destructor
E enum
e   sym:enum-member
F pmod:fastcall
f float, sym:field
g
h
I interface [amod:const/in, pmod:inline]
i int
j
k
L int64, [#mod:Unicode]
l long
M   sym:macro
m   sym:method
n
o amod:out, pmod:operator
P   sym:proc
p pmod:procedure
q
R amod:Result
r amod:ref
S struct
s short
T amod:this,  sym: template
t   sym: type
U union
u unsigned (int) = cardinal
V amod:value, vmod:volatile
v void, sym:var
w
x
y
z
--------
set?
string?
*)
(* Updates:
  Change S/U/E into ("S"|"U"|"E") ("#"(num|tagname) | "{" Fields "}").
  Remove Scope from Type.
*)

(* Meta Files
ToDo:
- don't break strings with embedded ','
- add Scope - for now: static only
- change Proc from Typedef into SymVar
VarConst = name [":" Scope Type] [ = value ]
Typedef = name "=" Type
oldProc = name "=" Type
Proc = name ":" Scope ProcType [ "=" "{" code "}" ]
Scope = [ "!" | "?" ] /* "!"=static (module level), "?"=local, else global/public(?) */
Macro = "#define" name ["(" { param "," } ")" ] [ "\" body ]
  /* body are all continuation lines (ending with '\') */
  /* alternative: procedure: [ "{" body ] ? */
*)
(* Updates:
Symbol identifier:
A ?Alias (type)?
a Argument (proc/func/macro)
C Class (to come)
c Const (untyped?)
d Define (simple expression, untyped?)
E Enum
e EnumMember - C:global (untyped) const
F FuncType
f Function
I Interface
L Literal (Unicode) [u?]
l Literal (Ansi)
M Macro (complex definition, must expand)
m Member (struct/union)
o Operator?
P ProcType
p Proc
r Result
S Struct (also: C class)
s ?Set?
T Type
t this
t Template
U Union
[u ?Unicode literal?]
v Var
---
#define -> c?dMt
Type -> CEFIPSsTU
Var -> amvtr
Const -> ceLl
Proc -> pfo
*)

interface

{$I config.pas}

uses
  Classes,  //TStream
  uFiles, //include handler
  uTablesPrep, //macro handler
  uXStrings,
  uMacros, uScanC, uTokenC;

var
  fAutoConst: boolean = True; //convert macros into constants?


type
  eKey = eLangKeys;

  eSymType = (
  //not yet typed
    stUnknown,
  //preprocessor symbols???
    stMacro,  //to be expanded
    stInline, //treat as procedure, don't expand
  //both preprocessor and parser???
    stConst, stEnumMember,  //const variable, enum member, #define???
      //subtypes: int, str, expr?
  //parser created
    //stField,  //local in scope (proc, struct...)
    stVar,
    stProc,
    stTypedef //stay last
  );
const
  InitableSyms = [stConst, stVar];
  DefaultStorage = Kauto;

type
  TTypeDef = class;

  TDefinition = TScanTokens;

  TSymbolC = class(TSymMacro)
  protected
    function  GetCaption: string; override;
  public
    kind: eSymType;
    DupeCount:  byte;
      //intended purpose: substitution of conflicting names
    Def:  string;
    BaseType: TTypeDef; //TSymbolC;
      //intended purpose: dummy typedefs for anonymous complex types.
  //values, depending on kind:
    IntVal: integer;
    StrVal: string;
  {$IFDEF ParseTree}
    Definition: TDefinition;
  {$ENDIF}
    function  GetTokens: TTokenArray; override; //-> nil
    function  SetID(nameID: integer): integer;
    function  toString: string; override;  //full (meta) string
    function  TypedName: string;  //-> name[:type]
    function  UniqueName: string;
  end;

  TTypeDef = class(TSymbolC)
  protected
    function  GetCaption: string; override;
  public
    constructor Create(const AName: string; AKey: integer = 0); override;
    //property  Ref: string read GetName; //quote???
    function  Ref: string;
    //property  Def: string read StrVal write StrVal;
    //property  toString: string read GetCaption;
  end;
  TSymType = TTypeDef;  //alias for use in parsetrees

//also used for parameter lists?
  TSymListC = class(TXStringList)
  public
    function  getSym(index: integer): TSymbolC;
  end;


//C: all types are globally visible
  TTypeList = class(TSymListC)
  public
    //constructor Create(const AName: string; AKey: integer = 0); override;
    //procedure SaveToStream(Stream: TStream); override;
    function  defType(const AName, ADef: string): TTypeDef;
    function  findType(const AName: string): TTypeDef;
    function  getType(index: integer): TTypeDef;
  end;

  TSymVar = class(TSymbolC)
  protected
    function  GetCaption: string; override;
  public
  end;

  TVarList = class(TSymListC)
  public
    function  getVar(index: integer): TSymVar;
    //function  defVar(const AName, ADef: string; v: integer = 0): TSymbolC;
    function  defVar(const AName, ADef, AVal: string): TSymVar;
  //const shortcuts
    //function  defInt(const AName: string; AVal: integer): TSymbolC;
    function  defInt(const AName, AVal: string): TSymVar;
    //function  getVal(index: integer): integer;
    function  getVal(index: integer): string;
  end;

  TSymProc = TSymVar;
  TProcList = TVarList;

  TTypeDefs = class(TXStringList)
  public
    //Structs, Unions, Enums,
    Types: TTypeList; //inherit!
    Procs: TProcList;
    Consts: TVarList;
    Vars: TVarList;
    DefFile:  string;
    //Scopes? Other than for proc/type: units???
    //DefPos: integer; - not for text files :-(
    constructor Create(const AName: string; AKey: integer = 0); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromFile(const fn: string); override;
{$IFDEF PreInclude}
    procedure HandleDefFiles(f: TFile);
{$ENDIF}
    function  MacroFilter(id: integer; newkind: eSymbolKind): eSymbolKind;
    //function  assumeType(t: eToken; const AName: string): TTypeDef;
    function  isType(const AName: string): integer;
      //>= 0 (type index) if typename
    function  defType(const AName, ADef: string): TTypeDef;
    function  defConst(const AName, ADef, AVal: string): TSymbolC;
    function  defEnumMember(const AName, ADef, AVal: string): TSymbolC;
    function  defProc(const AName, ADef: string): TSymbolC;
    function  defVar(const AName, ADef, AVal: string): TSymbolC;
  //added
    function  getSym(const AName: string): TSymbolC; overload;
    //function  getSym(index: integer): TSymbolC; overload;
  end;

  TScope = TTypeDefs;
  TGlobalScope = class(TScope)
  public
    constructor Create(const AName: string; AKey: integer = 0); override;
  end;

// --- a helper object, used while parsing declarations ---

  eSized = (szNone, szShort, szLong, szLongLong);

  TDeclAttrs = set of Kconst..Kvolatile;
  //eCallConv = Kcdecl..Kstdcall;

  RType = object
  protected
    procedure handleStorage;
    procedure type_specifier(i_ttyp: eToken);
    function  todo: boolean;
  public
  //declaration specifiers
    fPublic:  boolean;  //file level scope - become nesting level (int counter)?
    storage: eStorageClass; //eToken;
    signed: eToken;
    sized: eSized;
    specToken: eToken;  //finish spec, handle implied 'int'
    attrs: TDeclAttrs;  //spec only?
    call: eToken; //TCallConv;
    _inline:  boolean;
    basetype: TTypeDef; //complex type, tagged -> S:<name>, U:<name>, E:<name>
  //declarator, based on common declaration specifiers
    spec, pre, post: string;
    name: string;
    nameID:  integer; //scanner symbol ID
    declSym: TSymbolC;
    procedure Init;   //~constructor
    procedure Reset;  //init declarator, keep specification
      procedure startDecl;  //same!
    procedure makeTagRef(sue: eKey; const tag: string);
    procedure makeTypeRef(const tn: string);
    //procedure makeEnumMember(const n, t: string; v: integer);
    procedure makeEnumMember(const n, t, v: string);
    //procedure makeStructMember(t: RType; bitsize: integer = -1);
    procedure makeStructMember(t: RType; const bitsize: string);
    procedure finishComplex;
    procedure makePointer;
    procedure makeDim(const dim: string);
    function  makeParam(const Aname, Adef: string): string;
    function  makeVarargs: string;
    procedure makeParams(const params: string);
    function  qualify(t: eKey; fSpec: boolean): boolean; //const or volatile
    procedure endDecl;  //(fPublic: boolean);
      //arg to become scope object?
      procedure finishDeclaration;
    function  getDef: string;
  end;

function  quoteName(const Aname: string): string;
function  quoteType(const Aname: string): string;

procedure InitAlias;

// --- parsing without token stream ---
function  nextToken: eToken;
function  skip(t: eToken): boolean;
function  expect(t: eToken; const msg: string): boolean;

var
  Globals:  TGlobalScope;

//config

const
//distinguish type names from var names
  typeQuote = '"';  // '''';
  nameQuote = ''''; //'"';
  HexPrefix = '0x'; //meta format

  //LocalScope = '?';
  StaticScope = '!';
  //PublicScope = 'p';
var
  TypePrefix: string; //= 'T';

implementation

uses
  SysUtils,
  uDirectives,  //pragma handlers
  uParseC, uUI;


function quoteName(const Aname: string): string;
begin
  if Aname = '' then
    Result := ''
  else
    Result := nameQuote + Aname + nameQuote;
end;

function quoteType(const Aname: string): string;
begin
  if Aname = '' then
    Result := ''
  else
    Result := typeQuote + Aname + typeQuote;
end;


(* Calling conventions
MSC:  __cdecl, __stdcall, __fastcall
Delphi: cdecl, stdcall, register, pascal, safecall
__fastcall has no equivalent in Delphi?
Type markers:
F __fastcall
C __cdecl
I __inline
*)

(* InitAlias - init predefined types and keyword alias.
  Some compiler specific keywords and types deserve special handling.
  Here we define all these "__..." symbols.
*)
procedure InitAlias;
begin
{$IFDEF PreInclude}
//include handler
  uFiles.PreInclude := AllTypes.HandleDefFiles;
{$ENDIF}
//keyword alias
  Symbols.addKey('__const', Kconst);
//"inline" may not be known to all compilers?
  Symbols.addKey('inline', Kinline);
//predefined types
  Globals.defType('__int8',  '-1');
  Globals.defType('__int16', '-2');
  Globals.defType('__int32', '-4');
  Globals.defType('__int64', '-8');
end;

{ TTypeDefs }

constructor TTypeDefs.Create(const AName: string; AKey: integer);
begin
  inherited;
  if self.FOwner <> nil then
    Types := TTypeDefs(FOwner).Types; //C: inherit common type list
  Consts := TVarList.CreateIn(self, 'const');
  Vars := TVarList.CreateIn(self, 'var');
  Procs := TProcList.CreateIn(self, 'proc');
end;

function  TTypeDefs.defConst(const AName, ADef, AVal: string): TSymbolC;
begin
  Result := Consts.defVar(AName, ADef, AVal);
  Result.kind := stConst;
end;

function TTypeDefs.defEnumMember(const AName, ADef, AVal: string): TSymbolC;
begin
  Result := self.defConst(AName, ADef, AVal);
  Result.kind := stEnumMember;
end;

function TTypeDefs.defProc(const AName, ADef: string): TSymbolC;
begin
  Result := self.Procs.defVar(AName, ADef, '');
  Result.kind := stProc;
end;

function TTypeDefs.defType(const AName, ADef: string): TTypeDef;
begin
  Result := self.Types.defType(AName, ADef);
end;

function TTypeDefs.defVar(const AName, ADef, AVal: string): TSymbolC;
begin
  Result := Vars.defVar(AName, ADef, AVal);
end;

function TTypeDefs.getSym(const AName: string): TSymbolC;
var
  i: integer;
begin
  i := self.Types.IndexOf(AName);
  if i >= 0 then begin
    Result := Types.getType(i);
    exit;
  end;
  i := self.Procs.IndexOf(AName);
  if i >= 0 then begin
    Result := Procs.getSym(i);
    exit;
  end;
  i := self.Consts.IndexOf(AName);
  if i >= 0 then begin
    Result := Consts.getSym(i);
    exit;
  end;
  i := self.Vars.IndexOf(AName);
  if i >= 0 then begin
    Result := Vars.getSym(i);
    exit;
  end;
  Result := nil;
end;

{$IFDEF PreInclude}

(* HandleDefFiles - process definition files
*)
procedure TTypeDefs.HandleDefFiles(f: TFile);
var
  s, n, v:  string;
  r:  TextFile;
  i, id:  integer;
  symC: TSymbolC;
  //symP: TSymPrep;
begin
  s := f.dir + f.name + '.defs';
  if not FileExists(s) then
      exit;
  AssignFile(r, s);
  Reset(r);
  while not EOF(r) do begin
    ReadLn(r, s);
    i := Pos('=', s);
    if i > 1 then begin
      n := Copy(s, 1, i-1);
      v := Copy(s, i+2, Length(s));
      id := Symbols.Add(n);
      case s[i+1] of
      'c':  //constant
        if not fAutoConst then begin
          //if v = '' then v := '#i';  //default: integer const?
          symC := self.defConst(n, v, '');
          Symbols.defMacro(id, skConst);
        end;
{$IFDEF MakeProcedures}
//to be debugged!
      'p':  //procedure
        begin
          //symC := self.Procs.defType..Types.defType(n, v);
          symC := self.defProc(n, v);
          Symbols.defMacro(id, skProc);
        end;
{$ELSE}
{$ENDIF}
      't':  //typedef
        begin
          symC := self.defType(n, v);
          Symbols.defMacro(id, skType);
        end;
      end;
    end;
  end;
  CloseFile(r);
end;

{$ELSE}
  //no *.defs handler
{$ENDIF}

function TTypeDefs.isType(const AName: string): integer;
begin
  Result := Types.IndexOf(AName);
end;

procedure TTypeDefs.LoadFromFile(const fn: string);
var
  f: TextFile;
  ln, s: string;
  n, t, v: string;
  typ: TTypeDef;
  sym: TSymbolC;
  cv: TSymVar absolute sym;
  i: integer;

  function  ReadLine: boolean;
  begin
    ReadLn(f, ln);
    while ln[Length(ln)] = ',' do begin
    //merge continued line
      ReadLn(f, s);
      assert(s[1] = #9, 'expected <tab>');
      ln := ln + Copy(s, 2, Length(s));
    end;
    Result := ln[1] <> '-';
  end;

  procedure SkipSection;
  begin
    while not EOF(f) do begin
      if not ReadLine then
        break;
    end;
  end;

  function  ReadTP: boolean;
  begin
    Result := ReadLine;
    if not Result then
      exit;
    i := Pos('=', ln);
    n := Copy(ln, 1, i-2);
    t := Copy(ln, i+2, Length(ln));
  end;

  procedure LoadTypes;
  begin
    while ReadTP do begin
      typ := Globals.Types.defType(n, t);
    end;
  end;
{
type
  eCVF = (
    cvfConst, cvfVar, cvfProc
  );
}
  //function  ReadCV(fConst: boolean): boolean;
  //function  ReadCVP(cvf: eCVF): boolean;
  function  ReadCVP: boolean;
  begin // <name>: <type> [= <val>]
    Result := ReadLine;
    if not Result then
      exit;
    i := Pos(':', ln);
    n := Copy(ln, 1, i-1);
    t := Copy(ln, i+2, Length(ln));
    i := Pos('=', t);
    if i > 0 then begin
      v := Copy(t, i+2, Length(t));
      SetLength(t, i - 2);
    end else
      v := '';
  // RP added test for empty
    typ := nil;
    if (t <> '') and (t[1] = typeQuote) then begin
      s := Copy(t, 2, Length(t) - 2);
      i := Globals.isType(s);
      if i >= 0 then
        //cv.BaseType := Globals.Types.getType(i);
        typ := Globals.Types.getType(i);
    end;
{
    case cvf of
    cvfConst: sym := Globals.defConst(n, t, v);
      //further distinguish enum members???
    cvfVar:   sym := Globals.defVar(n, t, v);
    cvfProc:
      //sym := AllTypes.defVar(n, t, i);
}
  end;

  procedure LoadVars;
  begin
    //SkipSection;  //for now
    //while ReadCV(False) do
    while ReadCVP do
      sym := Globals.defVar(n, t, v);
      if typ <> nil then sym.BaseType := typ;
  end;

  procedure LoadConsts;
  begin
    //SkipSection;  //for now
    //while ReadCV(True) do
    while ReadCVP do begin
      sym := Globals.defConst(n, t, v);
      if typ <> nil then sym.BaseType := typ;
    end;
  end;

  procedure LoadProcs;
  begin
    //while ReadTP do begin
    while ReadCVP do begin
      sym := Globals.defProc(n, t);
    end;
  end;

  function  LoadMacros: boolean;
  begin //macros have special file format
  //skip, for now
    Result := False;
    //DefPos := FilePos(f);
{
    while not EOF(f) do begin
      ReadLn(f, ln);
    end;
}
  end;

begin
  DefFile := fn;
  AssignFile(f, fn);
  Reset(f);
  ReadLn(f, ln);
  assert(Copy(ln, 1, 4) = '--- ', 'bad file format');
  while not EOF(f) do begin
    case ln[5] of //expected in this order
    't':  LoadTypes;
    'v':  LoadVars;
    'c':  LoadConsts;
    'p':  LoadProcs;
    'm':  if not LoadMacros then break;
    else  assert(false, 'bad file format');
    end;
  end;
  CloseFile(f);
end;

(* MacroFilter - classify macros after #define
  Returns the kind of the macro:
  skSym:    delete the macro, treat as symbol.
  skMacro:  install as macro (expand...)

Current implementation:
  If fAutoConst is True, convert all macros with a single numeric token
  into named constants.

ToDo:
  Better recognition of multi-token constants, i.e. (value) etc.
*)
function TTypeDefs.MacroFilter(id: integer;
  newkind: eSymbolKind): eSymbolKind;
var
  sym:  TXStrings;  //TSymPrep;
  mac:  TMacro absolute sym;
  t:    PPreToken;
  iBody:  integer;
  CSym: TSymbolC;

  (* getToken - filter "white" tokens.
  *)
  function  getToken: PPreToken;
  begin
    repeat
      Result := mac.peekBody(iBody);  inc(iBody);
    until (Result = nil) or not (Result.kind in whiteTokens);
  end;

  function  checkToken: eToken;
  var
    t2:    PPreToken;
  begin
    t2 := getToken;
    if t2 = nil then
      Result := t_eof
    else
      Result := t2.kind;
  end;

begin
  Result := newkind;  //default
  if not fAutoConst then
    exit;
  sym := Symbols.Members[id];
  if (sym = nil) or (mac.ClassType <> TMacro) then
    exit; //only convert macros without arguments
  iBody := 0; //start iteration
  t := getToken;
  if (t <> nil) and (checkToken = t_eof) then begin
  //effective macro body is a single literal token
    Result := skConst;  //assume literal
    CSym := nil;
  //??? are untyped constants '#' okay???
    case t.kind of
    //t_str:  self.defConst(mac.name, '#', '''' + StringTable[t.strID] + '''');
    //t_car:  self.defConst(mac.name, '#', '''' + t.chars + '''');
    t_str, t_car:  CSym := self.defConst(mac.name, '#', '''' + TokenText(t^) + '''');
    t_int, t_Lint:
      begin //preserve format information
      //t.lval also is okay for t_int
{
        if taUnsigned in t.attrs then begin
          lval := t.uval;
          def := '#+i';
        end else begin
          lval := t.ival;
          def := '#i';
        end;
}
        if iaBase16 in t.attrs then begin
        //hex number
          CSym := self.defConst(mac.name, '#', HexPrefix + IntToHex(t.lval, 0));
        end else begin
        //decimal or octal constant
        //todo: write octal C format (0...)
          CSym := self.defConst(mac.name, '#', IntToStr(t.lval));
        end;
      end;
    t_flt:  CSym := self.defConst(mac.name, '#', FloatToStr(t.d));
    else
      Result := newkind;
    end;
    if CSym <> nil then
      CSym.SetID(mac.symID);  //nameID
  end;
end;

procedure TTypeDefs.SaveToStream(Stream: TStream);

  procedure WriteLn(const s: string; fSplit: boolean);
  var
    s2: string;
  begin
    if fSplit and (Length(s) > 80) then begin
    //stupid IDE truncates long lines!
    //todo: this may split strings with embedded ','!!!
      s2 := StringReplace(s, ',', ',' + EOLstr + #9, [rfReplaceAll]);
      Stream.Write(s2[1], Length(s2));
    end else
      Stream.Write(s[1], Length(s));
    Stream.Write(EOLstr, Length(EOLstr));
  end;

  procedure SaveDefines;
  var
    i: integer;
    sym:  PSymPrep;
  begin
    for i := 0 to Symbols.Count - 1 do begin
      sym := Symbols.getSymbol(i);
      if (sym.mackind = skMacro)  //suppress constants etc!
      and (sym.FMember <> nil) then begin
        WriteLn('#define'#9 + TMacro(sym.FMember).toString, False);
      end;
    end;
  end;

  procedure SaveSymbols(lst: TXStrings);
  var
    i: integer;
  begin
    for i := 0 to lst.Count - 1 do begin
      WriteLn(lst.Members[i].Caption, True);
    end;
  end;

begin
//types
  WriteLn('--- typedefs ---', False);
  SaveSymbols(self.Types);
//vars
  WriteLn('--- variables ---', False);
  SaveSymbols(self.Vars);
//constants
  WriteLn('--- constants ---', False);
  SaveSymbols(self.Consts);
//procedures?
  WriteLn('--- procedures ---', False);
  SaveSymbols(self.Procs);
//macros?
  WriteLn('--- macros ---', False);
  SaveDefines;
end;

{ TGlobalScope }

constructor TGlobalScope.Create(const AName: string; AKey: integer);
begin
  inherited;
  Types := TTypeList.CreateIn(self, 'typedef');
  uTablesPrep.MacroFilter := self.MacroFilter;
end;

{ TTypeList }

function TTypeList.defType(const AName, ADef: string): TTypeDef;
var
  i: integer;
begin
  i := IndexOf(AName);
  if i >= 0 then
    TXStrings(Result) := Members[i]
  else
    Result := nil;
  if Result = nil then
    Result := TTypeDef.CreateIn(self, AName); //, Count);
//check for redefinition
  if Result.Def = '' then
    Result.Def := ADef
  else if (ADef <> '') and (ADef <> Result.Def) then begin
    Log('redef ' + AName + '=' + Result.Def);
    Log('as ' + ADef, lkWarn);
  end;  //else stays undefined
end;

function TTypeList.findType(const AName: string): TTypeDef;
var
  i: integer;
begin
  i := self.FindFirst[AName];
  if i < 0 then
    Result := nil
  else
    TObject(Result) := self.Members[i];
end;

function TTypeList.getType(index: integer): TTypeDef;
begin
  TObject(Result) := Members[index];
end;

{ RType }

procedure RType.handleStorage;
begin
  self.storage := i_ttyp;
  nextToken;
end;

//constructor RType.Init;
procedure RType.Init;
begin
  self.Reset;
  self.spec := '';
  self.storage := DefaultStorage; // Kauto; //t_empty;
  self.signed := t_empty;
  self.sized := szNone;
  self.specToken := t_empty;
  self.attrs := [];
  self.basetype := nil;
  self.call := t_empty;
  self._inline := False;
end;

(* restart declarator parsing
*)
procedure RType.Reset;
begin
(* in Init:
    storage: eToken;
    signed: eToken;
    sized: eSized;
    attrs: ...
    name: string;
    basetype: TTypeDef;
  //self.attrs := [];
  //self.spec := ''; - remains defined
*)
  self.name := '';
  self.nameID := 0; //or -1?
  self.pre := '';
  self.post := '';
  self.declSym := nil;
end;

procedure RType.type_specifier(i_ttyp: eToken);
var
  s_typ0: string;
const
  SizedInt: array[eSized] of char = 'islL';
  aSized: array[Kint8_t..Kuint64_t] of string = (
    '-1', '-2', '-4', '-8',
    '+1', '+2', '+4', '+8'
  );
begin
//check spec already finished?
  if self.specToken <> t_empty then begin
    //assert(specToken = i_ttyp, 'redef base type');
    if specToken = i_ttyp then
      exit;
    Log('redef base type', lkErr);
    //continue to debug
  end;
//make base type
  case i_ttyp of
  Kvoid:  s_typ0 := 'v';
  Kchar:
    case signed of
    Ksigned:    s_typ0 := '-c';
    Kunsigned:  s_typ0 := '+c';
    else        s_typ0 := 'c';
    end;
  t_sym,  //possibly modified typename?
  Kint:
    begin
      if i_ttyp = t_sym then begin
      //base type: typename (ref) or typedef of typename?
        s_typ0 := quoteType(ScanText); //getType(...).Def; ?
        case sized of
        szNone: ;
        szShort:  s_typ0 := 's' + s_typ0;
        szLong:   s_typ0 := 'l' + s_typ0;
        else
          Log('questionable typename modifier', lkDiag);
        end;
      end else
        s_typ0 := SizedInt[sized];
      case signed of
      Kunsigned: s_typ0 := '+' + s_typ0;
      //Ksigned: ignore
      end;
    end;
  Kfloat: s_typ0 := 'f';
  Kdouble:
    case sized of
    szLong, szLongLong: s_typ0 := 'D';
    else s_typ0 := 'd';
    end;
  Kint8_t..Kint64_t:
    begin
      if signed = Kunsigned then
        inc(i_ttyp, ord(Kuint8_t) - ord(Kint8_t));
      s_typ0 := aSized[i_ttyp];
    end;
  Kuint8_t..Kuint64_t:
    s_typ0 := aSized[i_ttyp];
  else
    assert(False, 'unknown simple type');
    s_typ0 := '?';
  end;
  spec := spec + s_typ0;  //other attributes: const, volatile?
  self.specToken := i_ttyp; //flag finished
end;

function RType.todo: boolean;
begin
  Result := false;
end;

//procedure RType.makeEnumMember(const n, t: string; v: integer);
procedure RType.makeEnumMember(const n, t, v: string);
begin
  if v = '' then
    self.post := post + n + ','
  else
    self.post := post + n + '=' + v + ',';
  Globals.defEnumMember(n, t, v); //for lookup in further definitions!
end;

(* finishComplex - compile specification
  The member declarations, stored in .post, become part of the base type.
  For anonymous types the declaration is stored in .spec,
  for tagged types the declaration is stored in the explicit type (.basetype)
    and .spec becomes a reference to this type.
*)
procedure RType.finishComplex;
begin
(* struct/union/enum becomes spec!
  either t:{fields} //anonymous
  or "t:tag"  //tagged
*)
  post := '{' + post + '}';
  if self.basetype <> nil then begin
  //define already created (tagged) type
    basetype.Def := post;
    spec := quoteType(basetype.Name);
  end else begin
  //anonymous?
    spec := spec + post;
  end;
  post := '';
end;

(* makeTagRef - remember basetype
  Format: <t> [":"<name>] ["{"<def>"}"]
*)
procedure RType.makeTagRef(sue: eKey; const tag: string);
begin
  case sue of
  Kenum:    spec := 'E';
  Kstruct:  spec := 'S';
  Kunion:   spec := 'U';
  else
    assert(False, 'bad basetype');
  end;
  if tag <> '' then begin
    spec := spec + ':' + tag;
    basetype := Globals.defType(spec, ''); //typename without quotes
    spec := quoteType(spec);  //for further refs: quoted
  end else
    basetype := nil;  //missing???
  self.specToken := sue;
end;

//procedure RType.makeStructMember(t: RType; bitsize: integer);
procedure RType.makeStructMember(t: RType; const bitsize: string);
var
  mbr: string;
begin
  mbr := t.getDef + ',';
  if bitsize <> '' then
    mbr := '<' + bitsize + '>' + mbr;
  mbr := ':' + mbr; //separate name and type
  if t.name <> '' then
    mbr := t.name + mbr;
  post := post + mbr;
end;

procedure RType.makeTypeRef(const tn: string);
begin
  if spec = '' then
  //assume typeref
    self.basetype := Globals.defType(tn, '')
  else if Globals.isType(tn) >= 0 then
  //modification of previously defined type!
    self.basetype := Globals.defType(tn, '');
  spec := spec + quoteType(tn);
  self.specToken := t_sym;
end;

procedure RType.makePointer;
begin
  pre := '*' + pre;
end;

(* qualify - remember const/volatile and function qualifiers
  Const and volatile qualifiers are added in front of previous description strings.
  Specifier attributes are added to .spec,
  declarator attributes are added to .pre.

Calling conventions (and more?) can occur both inside an specifier
  or an (possibly nested!) declarator.
  At the end of an nested declarator all components must be copied
  into the outer declaration, and processed there again. This means,
  in the case of calling conventions, that the spec string must be updated.
It seems as if calling conventions can be overriden in VC.
*)
function  RType.qualify(t: eKey; fSpec: boolean): boolean;
begin
(* position dependence of "const":
  const [int] c = val //constant var
  const char  * p  //ptr to const string
  char const  * p  //ptr to const (same)
  char  * const p  //const ptr to string - applies to declarator, not spec!
    (the string can be modified, but not the pointer)
  const char  * const p  //const ptr to const string
*)
  Result := True;
  if t in calling_conventionS then begin
    if call = t then
      exit; //already done
    Result := self.call = t_empty;
    if Result then
      call := t  //no checks, no string modifications
    else
      Log('different calling conventions', lkErr);
  end else if fSpec then begin //assume spec!
    if t in attrs then
      exit; //prevent multiple insertion into the spec string.
    include(attrs, t);
    case t of
    Kconst:     spec := '#' + spec;
    Kvolatile:  spec := 'V' + spec;
    end;
  end else begin
    //include(declattrs, t);  //not correct, as long as only 1 set of attrs
    case t of
    Kconst: pre := '#' + pre;
    Kvolatile: pre := 'V' + pre;
    else  //what other qualifiers can occur?
      Log('unexpected declarator qualifier', lkErr);
      Result := False;
    end;
  end;
end;

procedure RType.startDecl;
begin
  pre := '';
  post := '';
  name := '';
  nameID := 0;
  declSym := nil;
end;

(* finishDeclaration - consistency check
Called by init_declarator_list() for every finished init_declarator.
*)
procedure RType.finishDeclaration;
begin
  Log(self.name + ':' + self.getDef, lkDiag);
  if self.declSym = nil then begin
  //in case of: typedef struct <ident>;
    Log('no symbol created', lkErr);
  end;
end;

(* endDecl - end declarator, before initializer list!
Create named object (type, proc, const, var) in the current scope.
Called at end of declarator(), before optional initializers.

For now only public and non-public scopes are distinguished.
  Objects only are created in public scope.
A full blown parser (for compound statements)
  also should create objects in the local (block) scope,
  and also should distinguish "external" from "static" scope.
In C++ a visibility attribute may be used for private, protected and public
  visibility of the created objects.
*)
procedure RType.endDecl;
begin
//check name
  if fPublic and (name = '') then begin
  //anonymous declaration!?
    Log('missing declarator name', lkErr);
  end else begin
  //add/enter symbol or member?
    if self.storage = Ktypedef then begin
    //in C all typedefs in a single global scope?
      declSym := Globals.defType(name, getDef);
    end else if fPublic then begin
    //distinguish proc, var, const (and initialized var?) - how???
      if (post <> '') and (post[1] = '(') then begin
      //is proc: (post) cc *pre v/t spec
        declSym := Globals.defProc(name, getDef);
      end else if Kconst in attrs then begin
      //declaration of const and initialized var finished only after initializer!
        declSym := Globals.defConst(name, getDef, '');  //value yet unknown
      end else begin
        declSym := Globals.defVar(name, getDef, '');
      end;
    end;
  //ToDo: fPublic is inappropriate to distinguish public/static symbols?
    if declSym <> nil then begin
    //handle nameID
      if self.storage <> Kstatic then begin
        if self.nameID > 0 then
          declSym.SetID(nameID);
      end;  //else handle static symbol?
    end;
  end;
end;

procedure RType.makeDim(const dim: string);
begin
//what about expressions with named constants?
  post := post + '[' + dim + ']';
end;

(* makeParams - finish parameter list declaration
Should flag the declaration as procedure declaration!
But also should distinguish procedures from procedure pointers!

Since calling conventions can be overridden in VC, they are finished here!
__inline can be combined with other calling conventions!
*)
procedure RType.makeParams(const params: string);
begin
  post := post + '(' + params + ')';
//handle final calling convention (more?)
  //if self.storage = Kinline then
  if self._inline then
    post := post + 'I'; //hint (only)
  if self.call <> t_empty then begin
    case call of  //attach to spec or post???
    Kcdecl:     post := post + 'C';
    Kfastcall:  post := post + 'F';
    //Kinline:    post := post + 'I'; //treat as storage class!
    //Kstdcall: - not flagged
    end;
  end;
//definitely flag declarator as proc/func/pointer?
end;

function RType.makeParam(const Aname, Adef: string): string;
begin
(* Is quoting the name really required?
  Parameter lists always are parsed from first to last parameter!?
  Syntax: (<name>:<type>, <name>:<type>, ...)
*)
  Result := ':' + Adef + ',';
  if Aname <> '' then
    //Result := quoteName(Aname) + Result;
    Result := Aname + Result;
end;

function RType.makeVarargs: string;
begin
  Result := makeParam('', '~');
end;


function RType.getDef: string;
begin
  if self.specToken = t_empty then
    type_specifier(Kint); //make int type by default
  Result := self.post + self.pre + self.spec;
  if self.storage = Kstatic then
    Result := StaticScope + Result;
end;

{ TTypeDef }

constructor TTypeDef.Create(const AName: string; AKey: integer);
begin
  inherited;
  self.kind := stTypedef;
end;

function TTypeDef.GetCaption: string;
begin
  Result := self.Name + ' = ' + self.Def;
end;

function TTypeDef.Ref: string;
begin
  Result := GetName;
  if Result[2] = ':' then begin
  //anonymous SUE type? or what?
    Result := QuoteType(Result);
  end;
end;

{ TVarList }

function TVarList.defInt(const AName, AVal: string): TSymVar;
begin
  Result := defVar(AName, 'i', AVal);
  Result.kind := stConst;
end;

function TVarList.defVar(const AName, ADef, AVal: string): TSymVar;
var
  i: integer;
begin
  i := IndexOf(AName);
  if i < 0 then begin
    Result := TSymVar.CreateIn(self, AName, 0);
  end else begin
    TXStrings(Result) := Members[i];
    //assert(Result.IntVal = v, 'redef. const');
  end;
  Result.kind := stVar;
  Result.Def := ADef;
  //Result.IntVal := v;
  Result.StrVal := AVal;
end;

function TVarList.getVar(index: integer): TSymVar;
begin
  TObject(Result) := Members[index];
end;

//function TVarList.getVal(index: integer): integer;
function TVarList.getVal(index: integer): string;
var
  sym: TSymbolC;
begin
  sym := getVar(index);
  if sym <> nil then
    //Result := sym.IntVal
    Result := sym.StrVal
  else
    Result := '';  //or what?
end;

{ TSymbolC }

function TSymbolC.GetCaption: string;
begin
  Result := name;
  if self.StrVal <> '' then
    Result := Result + ' = ' + StrVal;
{
  if self.StrVal <> '' then begin
    if self.IntVal <> 0 then
      Result := Result + ' = ' + IntToStr(IntVal);
    Result := Result + ' = ' + StrVal;
  end else
    Result := Result + ' = ' + IntToStr(IntVal);
}
end;

function TSymbolC.GetTokens: TTokenArray;
begin
{$IFDEF ParseTree}
  Result := Definition;
{$ELSE}
  Result := nil;
{$ENDIF}
end;

(* SetID - remember scanner/preprocessor symID
This is an approach to create a common public STB.
Every C symbol object is added to the symbol list,
  provided that no macro of the same name exists.
*)
function TSymbolC.SetID(nameID: integer): integer;
begin
  self.nameID := nameID;
//todo: check for public/private symbol?
//assume: nameID > 0 means public symbol?
  if nameID > 0 then begin
    if Symbols.getSymbol(nameID).FMember = nil then begin
      Symbols.Objects[nameID] := self;
    end;
  end;
  Result := nameID;
end;

function TSymbolC.toString: string;
begin
  Result := BodyString;
  if Result = '' then begin
  //ToDo: BodyString should be overridden!
    if (self.Def = '') and (self.StrVal = '') then begin
      Result := name + ' = what?';  //should be overridden in derived class!
    end else begin
      //Result := name + ':' + Def + ' = ' + StrVal;  //default
      Result := name;
      if Def <> '' then
        Result := Result + ':' + Def;
       if StrVal <> '' then
         Result := Result + ' = ' + StrVal;  //default
    end;
  end else
    Result := name + Result;
end;

function TSymbolC.TypedName: string;
begin
  Result := name;
  if (Def <> '') {and (Def <> '#')} then
    Result := Result + ': ' + Def
  else if BaseType <> nil then
    Result := Result + ': ' + BaseType.Ref;
end;

(* UniqueName - add dupe count postfix
Other possible purposes:
  prefix/postfix identifiers for type/const/var/proc, depending on .kind.
  (Must be synchronized with the determination of DupeCount!)
*)
function TSymbolC.UniqueName: string;
begin
  Result := Name;
  if self.DupeCount > 0 then
    Result := Result + '_' + IntToStr(DupeCount);
  if (TypePrefix <> '') and (kind = stTypedef) then
    Result := TypePrefix + Result;
end;

{ TSymVar }

function TSymVar.GetCaption: string;
begin
  Result := self.TypedName;
  if self.StrVal <> '' then
    Result := Result + ' = ' + StrVal
  else if (IntVal <> 0) or (self.kind = stConst) then
    Result := Result + ' = ' + IntToStr(IntVal);
end;

{ TSymListC }

function TSymListC.getSym(index: integer): TSymbolC;
begin
  TObject(Result) := Members[index];
end;

// --------- not using token stream --------------

(* nextToken - token filter for parser
*)
function  nextToken: eToken;
begin
  repeat  //suppress unwanted tokens
    Result := nextTokenC;
  //map keywords
    if Result = t_symNX then
      Result := t_sym;  //should be suppressed in nextTokenC?
    if (Result = t_sym) and (ScanSym.mackind = skCKey) then
      Result := ScanSym.appkind;
  until not (Result in WhiteTokens);
  i_ttyp := Result;
end;

function  skip(t: eToken): boolean;
begin
  Result := i_TTYP = t;
  if Result then
    nextToken();
end;

function  expect(t: eToken; const msg: string): boolean;
begin
  Result := i_TTYP = t;
  if Result then
    nextToken()
  else
    Log(msg, lkDiag);
end;

initialization
  Globals := TGlobalScope.Create('identifiers');
finalization
  Globals.Free;
end.
