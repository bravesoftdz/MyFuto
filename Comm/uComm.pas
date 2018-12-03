unit uComm;

interface

uses
   Winapi.Windows, FMX.Forms, System.Classes, System.SysUtils, FMX.Dialogs;


/// <summary>
/// ��ӡ������Ϣ
/// </summary>
/// <param name="AClassName"></param>
function DebugInf(const Format: string; const Args: array of const): Boolean;

implementation

function DebugInf(const Format: string; const Args: array of const): Boolean;
//{$IFDEF DEBUG}
var
  sInfo: string;
//{$ENDIF}
begin
  Result := False;
  //{$IFDEF DEBUG}
  sInfo := System.SysUtils.Format(Format, Args, FormatSettings);
  OutputDebugString(PWideChar(sInfo));
  //{$ENDIF}
  Result := True;
end;
end.
