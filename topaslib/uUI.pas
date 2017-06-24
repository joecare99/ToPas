unit uUI;
(* User interface, console or GUI.
*)

{$ifdef fpc}{$mode delphi}{$h+}{$endif}

interface

type
  eLogKind = (
    lkProgress, //file/line specific messages
    lkConfig,   //file not found, user abort...
    lkSynErr,   //lkDiag, //errors in processed source text
    lkWarning,  //questionable construct in source text
  //app specific:
    lkDebug,  //hooks for debugging...
    lkTrace,  //on demand: fTrace
    lkTodo, //lkWarn - possibly a bug, needs further investigations
    lkBug   //lkErr - bug in this code, not in processed source text!
  );

  eParserFlags = (
    pfNone,
    pfSynErr, //Log(?)
    pfNotConst, //non-const expression
    pfLclVar,   //using variables other than global or parameters
    pfCode,     //contains code, not only an expression
    pfBug,      //analysis unreliable, due to bug in parser...
    pfOther
  );
  sParserFlags = set of eParserFlags;
var
  ParserFlags: sParserFlags;
  fTrace: boolean = False;

const
  aParserFlags: array[eLogKind] of eParserFlags = (
    pfNone, //lkProgress, //file/line specific messages
    pfOther, //lkConfig,   //file not found...
    pfSynErr, //lkSynErr,   //lkDiag, //errors in processed source text
    pfOther, //lkWarning,  //questionable construct in source text
  //app specific:
    pfNone, //lkDebug,  //hooks for debugging...
    pfNone, //lkTrace,  //on demand: fTrace
    pfNone, //lkTodo, //lkWarn - possibly a bug, needs further investigations
    pfBug //lkBug   //lkErr - bug in this code, not in processed source text!
  );

var
  Log: procedure (const msg: AnsiString; kind: eLogKind = lkProgress);

const
  EOLstr : AnsiString = LineEnding;

const //not up-to-date!!!
  MsgPrompt: array[eLogKind] of AnsiString = (
    '', '>', 'Warning>', 'Error!!!>',
    'Debug>', 'Trace>', 'Todo>', 'Bug!!!>'
  );


implementation

procedure NoLog(const msg: AnsiString; kind: eLogKind );
begin
end;

initialization
  Log:=NoLog;

end.
