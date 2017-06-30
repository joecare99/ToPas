program WinToPas;

uses
  Forms,
  fScanLog in '..\wintopas\fScanLog.pas' {ScanLog},
  fTypes in '..\wintopas\fTypes.pas' {TypeDefList},
  fScopeView in '..\wintopas\fScopeView.pas' {ScopeView},
  fConfiguration in '..\wintopas\fConfiguration.pas' {ConfigViewer},
  fSymView in '..\wintopas\fSymView.pas' {SymView},
  fMacros in '..\wintopas\fMacros.pas' {MacroChecker};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TScanLog, ScanLog);
  Application.CreateForm(TTypeDefList, TypeDefList);
  Application.CreateForm(TScopeView, ScopeView);
  Application.CreateForm(TConfigViewer, ConfigViewer);
  Application.CreateForm(TSymView, SymView);
  Application.CreateForm(TMacroChecker, MacroChecker);
  Application.Run;
end.
