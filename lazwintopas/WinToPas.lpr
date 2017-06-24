program WinToPas;

{$MODE Delphi}

uses
  Forms, Interfaces,
  fScanLog in 'fScanLog.pas' {ScanLog},
  fTypes in 'fTypes.pas' {TypeDefList},
  fScopeView in 'fScopeView.pas' {ScopeView},
  fConfiguration in 'fConfiguration.pas' {ConfigViewer},
  fSymView in 'fSymView.pas' {SymView},
  fMacros in 'fMacros.pas' {MacroChecker};

{$R *.res}

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
