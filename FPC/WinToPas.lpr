program WinToPas;

{$MODE Delphi}

uses
  Forms, Interfaces,
  fScanLog in '..\lazWinToPas\fScanLog.pas' {ScanLog},
  fTypes in '..\lazWinToPas\fTypes.pas' {TypeDefList},
  fScopeView in '..\lazWinToPas\fScopeView.pas' {ScopeView},
  fConfiguration in '..\lazWinToPas\fConfiguration.pas' {ConfigViewer},
  fSymView in '..\lazWinToPas\fSymView.pas' {SymView},
  fMacros in '..\lazWinToPas\fMacros.pas' {MacroChecker};

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
