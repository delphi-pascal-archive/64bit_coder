unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Base64Unit;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
const
 Base64MaxLength=72;
var
 hFile: integer;
 base64String: string;
 base64File: textfile;
 Base64: TBase64;
 Buf: array[0..2] of Byte;
begin
 OpenDialog1.Title:='����� ����� ��� base64 �����������';
 if not OpenDialog1.Execute then Exit;
 Label1.Caption:='������� ����. �����...';
 Application.ProcessMessages;
 base64String:='';
 hFile:=FileOpen(OpenDialog1.FileName,fmOpenReadWrite);
 AssignFile(base64File,OpenDialog1.FileName+'.b64');
 Rewrite(base64File);
 FillChar(Buf,SizeOf(Buf),#0);
 repeat
  Base64.ByteCount:=FileRead(hFile,Buf,SizeOf(Buf));
  Move(Buf,Base64.ByteArr,SizeOf(Buf));
  base64String:=base64String+CodeBase64(Base64);
  if Length(base64String)=Base64MaxLength
  then
   begin
    Writeln(base64File,base64String);
    base64String:='';
   end;
 until Base64.ByteCount<3;
 Writeln(base64File,base64String);
 CloseFile(base64File);
 FileClose(hFile);
 Label1.Caption:='���� �����������!';
 ShowMessage('���� '+ExtractFileName(OpenDialog1.FileName)+' ������� ����������� base64!'+#13#10+
         '�������� ������������� ����� '+ExtractFileName(OpenDialog1.FileName)+'.b64');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 base64File: textfile;
 BufStr: string;
 base64String: string;
 Base64: TBase64;
 hFile: integer;
begin
 OpenDialog1.Title:='����� ����� ��� base64 �������������';
 SaveDialog1.Title:='������� ��� ��������������� �����';
 if not OpenDialog1.Execute then Exit;
 if not SaveDialog1.Execute then Exit;
 Label1.Caption:='��������� ����. �����...';
 Application.ProcessMessages;
 AssignFile(base64File,OpenDialog1.FileName);
 Reset(base64File);
 hFile:=FileCreate(SaveDialog1.FileName);
 while not EOF(base64File) do
  begin
   Readln(base64File,BufStr);
   while Length(BufStr)>0 do
    begin
     base64String:=Copy(BufStr,1,4);
     Delete(BufStr,1,4);
     Base64:=DecodeBase64(base64String);
     FileWrite(hFile,Base64.ByteArr,Base64.ByteCount);
    end;
  end;
 Label1.Caption:='���� �����������!';
 FileClose(hFile);
 CloseFile(base64File);
 ShowMessage('���� �����������!');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 OpenDialog1.InitialDir:=ExtractFilePath(Application.ExeName);
end;

end.
