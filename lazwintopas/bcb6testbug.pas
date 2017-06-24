unit bcb6testbug;

interface

const
	__lib = 'bcb6testbug.dll';

function tolower(__ch_1: Integer): Integer; cdecl {inline};
function toupper(__ch_1: Integer): Integer; cdecl {inline};
function towlower(__ch_1: wint_t): wint_t; cdecl {inline};
function towupper(__ch_1: wint_t): wint_t; cdecl {inline};

implementation

function tolower(__ch_1: Integer): Integer; cdecl {inline};
begin
	begin Result := _ltolower(__ch_1); exit; end;
end;
function toupper(__ch_1: Integer): Integer; cdecl {inline};
begin
	begin Result := _ltoupper(__ch_1); exit; end;
end;
function towlower(__ch_1: wint_t): wint_t; cdecl {inline};
begin
	begin Result := _ltowlower(__ch_1); exit; end;
end;
function towupper(__ch_1: wint_t): wint_t; cdecl {inline};
begin
	begin Result := _ltowupper(__ch_1); exit; end;
end;
end.
