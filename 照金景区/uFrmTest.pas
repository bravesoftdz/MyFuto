unit uFrmTest;

interface

uses
  Winapi.Windows, FMX.Platform.Win, System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, FMX.Layouts, FMX.Ani,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFrmTest = class(TForm)
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
    Rectangle6: TRectangle;
    Rectangle7: TRectangle;
    Rectangle8: TRectangle;
    Rectangle1: TRectangle;
    Rectangle9: TRectangle;
    Rectangle10: TRectangle;
    Rectangle11: TRectangle;
    Rectangle12: TRectangle;
    Rectangle13: TRectangle;
    Layout1: TLayout;
    Rectangle14: TRectangle;
    Rectangle15: TRectangle;
    Rectangle16: TRectangle;
    Rectangle17: TRectangle;
    Rectangle18: TRectangle;
    Rectangle19: TRectangle;
    Layout2: TLayout;
    Rectangle20: TRectangle;
    Rectangle21: TRectangle;
    Rectangle22: TRectangle;
    Rectangle23: TRectangle;
    Rectangle24: TRectangle;
    Rectangle25: TRectangle;
    FloatAnimation1: TFloatAnimation;
    Button1: TButton;
    ��ȡ����: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure ��ȡ����Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTest: TFrmTest;

implementation

uses uGlobal, uPageParse;

{$R *.fmx}

procedure TFrmTest.Button1Click(Sender: TObject);
var
	vInterpolationType: TInterpolationType;
  iIndex, iStartValue: Integer;
begin
	Randomize;
	iIndex := Random(10);
  vInterpolationType := TInterpolationType(iIndex);
  FloatAnimation1.Enabled := True;
  FloatAnimation1.Loop := False;
  FloatAnimation1.Interpolation := vInterpolationType;
  FloatAnimation1.Duration := 1.0;  //һ���������ڵĳ���(��)
  iStartValue := Random(360);
  if iStartValue > 320 then iStartValue := iStartValue - 50;
  FloatAnimation1.StartValue := Random(360);  //���Ƕ�
  FloatAnimation1.StopValue := 360; //�յ�Ƕ�
end;

procedure TFrmTest.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
	if Key = 27 then
  begin
    Key := 0;
    Self.Close;
  end;
end;

procedure TFrmTest.��ȡ����Click(Sender: TObject);
var
	vLst: TStrings;
  vPageItem: TPageItem;
begin
	if not FileExists(uGlobal.GConfigFile) then
  begin
		ShowMessage('���ò�����');
    Exit;
  end;
  vLst := TStringList.Create;
  try
    vLst.LoadFromFile(uGlobal.GConfigFile);
    if vLst.Count <= 0 then
    begin
    	ShowMessage('��������Ϊ��');
    	Exit;
    end;
  	if not TSerizalizes.AsType<TAppConfig>(vLst.Text, GAppConfig) then
    begin
    	ShowMessage('���л��������ݳ���');
    	Exit;
    end;
    for vPageItem in GAppConfig.LastPages do
    begin
      Caption := IntToStr(vPageItem.ID) + ' ' + vPageItem.Desc;
      Application.ProcessMessages;
      Sleep(100);
    end;
      
  finally
    FreeAndNil(vLst);
  end;
end;

end.
