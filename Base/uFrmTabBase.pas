unit uFrmTabBase;

interface

uses
  Winapi.Windows, FMX.Platform.Win, System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, FMX.Ani, FMX.TabControl,
  System.Actions, FMX.ActnList;

type
  TFrmTabBase = class(TForm)
    tcPage: TTabControl;
    ActionList1: TActionList;
    actMainPage: TAction;
    actPriorPage: TAction;
    actNextPage: TAction;
    ActOpenPage: TAction;
    TabItem1: TTabItem;
    raImage: TRectangle;
    actGoBack: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure actPriorPageExecute(Sender: TObject);
    procedure actMainPageExecute(Sender: TObject);
    procedure actNextPageExecute(Sender: TObject);
    procedure ActOpenPageExecute(Sender: TObject);
    procedure actGoBackExecute(Sender: TObject);
    procedure raImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure raImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  private
    { Private declarations }
    FimgBackGround: string;
    FPageIndex: Integer;
    FID: Integer;      //��һ����������    1000000
    FGestureX: Single;
    /// <summary>
    /// �Ƿ�ʹ�����Ʒ�ҳ
    /// </summary>
    FUseGesture: Boolean;
    procedure InitFloatAnimate;
    procedure SetPageIndex(const Value: Integer); //���Ҵ�
    procedure InitEvent();
    procedure LoadImage();
    function GetID: Integer;
  protected
    procedure DoPriorPage; virtual;
    procedure DoNextPage; virtual;
    procedure DoMainPage; virtual;
    /// <summary>
    /// ����
    /// </summary>
    procedure DoGoBack; virtual;
    /// <summary>
    ///
    /// </summary>
    /// <param name="Sender"></param>
    procedure DoAfterPageChange; virtual;
  private
    procedure OnRaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure OnRaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  public
    { Public declarations }
    property PageIndex: Integer write SetPageIndex;
    property ID: Integer read GetID write FID;
    property UseGesture: Boolean read FUseGesture write FUseGesture default True;
  end;

var
  FrmTabBase: TFrmTabBase;

implementation

uses uFuns;

{$R *.fmx}

procedure TFrmTabBase.actGoBackExecute(Sender: TObject);
begin
  DoGoBack;
end;

procedure TFrmTabBase.actMainPageExecute(Sender: TObject);
begin
	DoMainPage;
end;

procedure TFrmTabBase.actNextPageExecute(Sender: TObject);
begin
	DoNextPage;
end;

procedure TFrmTabBase.ActOpenPageExecute(Sender: TObject);
var
  iPageIndex: Integer;
begin
  iPageIndex := TShape(Sender).Tag;
  if iPageIndex < 1000000 then Exit;
  //iPageIndex mod 1000000�󣬵õ�һ����ţ���Ӧ�����¼�ҳ��TabControl��TabIndexֵ
  uFuns.CreateForm(Self, Format('Tfrm%d', [10000 * (iPageIndex div 10000)]), iPageIndex);
end;

procedure TFrmTabBase.actPriorPageExecute(Sender: TObject);
begin
  DoPriorPage;
end;

procedure TFrmTabBase.DoAfterPageChange;
begin
  LoadImage;
end;

procedure TFrmTabBase.FormCreate(Sender: TObject);
begin
  {$IFNDEF DEBUG}
  tcPage.TabPosition := TTabPosition.None;
  raImage.Stroke.Kind := TBrushKind.None;
  {$ENDIF}
  InitEvent;
  InitFloatAnimate;
  FUseGesture := True;
end;

procedure TFrmTabBase.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
	//{$IFDEF DEBUG}
  if Key = 27 then
  begin
    Key := 0;
    Self.Close;
  end;
  //{$ENDIF}
end;

function TFrmTabBase.GetID: Integer;
begin
  Result := 100 * (FID div 100) + tcPage.TabIndex;
end;

procedure TFrmTabBase.DoGoBack;
begin
  Self.Close;
end;

procedure TFrmTabBase.DoMainPage;
begin
  CloseOtherPages();
end;

procedure TFrmTabBase.DoNextPage;
begin
  try
    if tcPage.TabIndex >= tcPage.TabCount - 1 then
      PageIndex := 0
    else
      PageIndex := tcPage.TabIndex + 1;
  except
  end;
end;

procedure TFrmTabBase.DoPriorPage;
begin
  try
    if tcPage.TabIndex <= 0 then
      PageIndex := tcPage.TabCount - 1
    else
      PageIndex := tcPage.TabIndex - 1;
  except
  end;
end;

procedure TFrmTabBase.InitEvent;
var
	I: Integer;
begin
	//
  for I := 0 to Self.ComponentCount - 1 do
  begin
    if (Self.Components[I] is TImage) then
    begin
      if Self.Components[i].Name = 'imgPriorPage' then
      begin
        TImage(Self.Components[I]).OnClick := actPriorPageExecute;
        TImage(Self.Components[I]).Cursor := crHandPoint;

        TImage(Self.Components[I]).OnMouseDown := OnRaMouseDown;
        TImage(Self.Components[I]).OnMouseUp := OnRaMouseUp;
      end;

       //��һҳ
      if Self.Components[i].Name = 'imgNextPage' then
      begin
        TImage(Self.Components[I]).OnClick := actNextPageExecute;
        TImage(Self.Components[I]).Cursor := crHandPoint;

        TImage(Self.Components[I]).OnMouseDown := OnRaMouseDown;
        TImage(Self.Components[I]).OnMouseUp := OnRaMouseUp;
      end;

      //����
      if Self.Components[i].Name = 'imgGoBack' then
      begin
        TImage(Self.Components[I]).OnClick := actGoBackExecute;
        TImage(Self.Components[I]).Cursor := crHandPoint;

        TImage(Self.Components[I]).OnMouseDown := OnRaMouseDown;
        TImage(Self.Components[I]).OnMouseUp := OnRaMouseUp;
      end;

    end;

    if (Self.Components[I] is TRectangle) or (Self.Components[I] is TRoundRect) then
    begin
    	{$IFNDEF DEBUG}
      TShape(Self.Components[I]).Stroke.Kind := TBrushKind.None;
      {$ENDIF}

//      //��һҳ
//      if Self.Components[i].Name = 'raPriorPage' then
//      begin
//        TRectangle(Self.Components[I]).OnClick := actPriorPageExecute;
//        TShape(Self.Components[I]).Cursor := crHandPoint;
//
//        TRectangle(Self.Components[I]).OnMouseDown := OnRaMouseDown;
//        TRectangle(Self.Components[I]).OnMouseUp := OnRaMouseUp;
//      end;
//
//      //��һҳ
//      if Self.Components[i].Name = 'raNextPage' then
//      begin
//        TRectangle(Self.Components[I]).OnClick := actNextPageExecute;
//        TShape(Self.Components[I]).Cursor := crHandPoint;
//
//        TRectangle(Self.Components[I]).OnMouseDown := OnRaMouseDown;
//        TRectangle(Self.Components[I]).OnMouseUp := OnRaMouseUp;
//      end;

      //��ҳ
      if Self.Components[i].Name = 'raMainPage' then
      begin
        TRectangle(Self.Components[I]).OnClick := actMainPageExecute;
        TShape(Self.Components[I]).Cursor := crHandPoint;

        TRectangle(Self.Components[I]).OnMouseDown := OnRaMouseDown;
        TRectangle(Self.Components[I]).OnMouseUp := OnRaMouseUp;
      end;

//      //����
//      if Self.Components[i].Name = 'raGoBack' then
//      begin
//        TRectangle(Self.Components[I]).OnClick := actGoBackExecute;
//        TShape(Self.Components[I]).Cursor := crHandPoint;
//
//        TRectangle(Self.Components[I]).OnMouseDown := OnRaMouseDown;
//        TRectangle(Self.Components[I]).OnMouseUp := OnRaMouseUp;
//      end;

      //��һ����ҳ��
      if Self.Components[I].Tag >= 1000000 then
      begin
        TShape(Self.Components[I]).OnClick := ActOpenPageExecute;
        TShape(Self.Components[I]).Cursor := crHandPoint;
      end;

    end;
  	OutputDebugString(PWideChar(Format('MS - %s', [Self.Components[I].Name])));
  end;
end;

procedure TFrmTabBase.InitFloatAnimate;
var
	vInterpolationType: TInterpolationType;
  iIndex, iStartValue: Integer;
begin
//	Randomize;
//	iIndex := Random(10);
//  vInterpolationType := TInterpolationType(iIndex);
//  faBackground.Enabled := True;
//  faBackground.Loop := False;
//  faBackground.Interpolation := vInterpolationType;
//  faBackground.Duration := 1.0;  //һ���������ڵĳ���(��)
//  iStartValue := Random(360);
//  if iStartValue > 320 then iStartValue := iStartValue - 50;
//  faBackground.StartValue := Random(360);  //���Ƕ�
//  faBackground.StopValue := 360; //�յ�Ƕ�
end;

procedure TFrmTabBase.LoadImage;
var
	sImgFile: string;
begin
  try
    //tcPage.TabIndex := 0;    //��仰����ӣ���Ϊ�������������TabIndex
    sImgFile := Format('%s\Image\%d.jpg', [ExtractFilePath(ParamStr(0)), ID]);
    if not FileExists(sImgFile) then
    begin
      MessageBox(FormToHWND(Self), PWideChar(Format('ȱ��ͼƬ��'#13'%s', [sImgFile])), '��ʾ', MB_ICONWARNING);
      Exit;
    end;
    raImage.Parent := tcPage.Tabs[tcPage.TabIndex];
    raImage.SendToBack;
    raImage.Fill.Kind := TBrushKind.Bitmap;
    raImage.Fill.Bitmap.Bitmap.LoadFromFile(sImgFile);
  except on E: Exception do
    DebugInf('MS - [%s-LoadImage] fail [%s]', [Self.ClassName, E.Message]);
  end;
end;

procedure TFrmTabBase.OnRaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  sImgName: string;
begin
  try
    sImgName := TImage(Sender).Name;
    sImgName := Copy(sImgName, 4, Length(sImgName));
    sImgName := Format('%sImage\%s_Pushed.png', [ExtractFilePath(ParamStr(0)), sImgName]);
    TImage(Sender).Bitmap.LoadFromFile(sImgName);
  except on E: Exception do
    DebugInf('MS - [%s-OnRaMouseDown] fail [%s]', [Self.ClassName, E.Message]);
  end;
end;

procedure TFrmTabBase.OnRaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  sImgName: string;
begin
  try
    sImgName := TImage(Sender).Name;
    sImgName := Copy(sImgName, 4, Length(sImgName));
    sImgName := Format('%sImage\%s_Normal.png', [ExtractFilePath(ParamStr(0)), sImgName]);
    TImage(Sender).Bitmap.LoadFromFile(sImgName);
  except on E: Exception do
    DebugInf('MS - [%s-OnRaMouseUp] fail [%s]', [Self.ClassName, E.Message]);
  end;
end;

procedure TFrmTabBase.raImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  FGestureX := X;
end;

procedure TFrmTabBase.raImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  vTmp: Single;
begin
  if not UseGesture then Exit;
  vTmp := X - FGestureX;
  if Abs(vTmp) < 80 then Exit;
  if vTmp < 0 then
    actNextPage.Execute
  else
    actPriorPage.Execute;
end;

procedure TFrmTabBase.SetPageIndex(const Value: Integer);
var
  iPageIndex: Integer;
begin
  iPageIndex := Value;
  try
    if iPageIndex >= tcPage.TabCount - 1 then
    begin
      iPageIndex := tcPage.TabCount - 1;
    end;

    if iPageIndex < 0 then
    begin
      iPageIndex := 0;
    end;

    tcPage.TabIndex := iPageIndex;
    //--Tab��ǩ�ı������������,ִ��һЩ����, Ĭ�ϵ��Ǽ���ͼƬ
    DoAfterPageChange;
  except
  end;
end;

end.
