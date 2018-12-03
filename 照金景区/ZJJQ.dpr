program ZJJQ;

{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}

uses
  System.StartUpCopy,
  FMX.Forms,
  uFrmMainPage in 'uFrmMainPage.pas' {FrmMainPage},
  uFrmTest in 'uFrmTest.pas' {FrmTest},
  uFrmBase in 'uFrmBase.pas' {FrmBase},
  uFrmSecondaryPages in '����ҳ��\uFrmSecondaryPages.pas' {FrmSecondaryPages},
  uGlobal in 'Comm\uGlobal.pas',
  uFuns in 'Comm\uFuns.pas',
  uFrm30000 in '����ҳ��\uFrm30000.pas' {Frm30000},
  uFrm40000 in '����ҳ��\uFrm40000.pas' {Frm40000},
  uFrmLastPage in 'ĩ��ҳ��\uFrmLastPage.pas' {FrmLastPage},
  SuperObject in 'Comm\SuperObject.pas',
  uPageParse in 'uPageParse.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMainPage, FrmMainPage);
  Application.Run;
end.
