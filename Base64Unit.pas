(*
+------------------------------------------------------------------------------+
|                                ??????                                        |
|                 ??? base64 ??????????? ? ?????????????                       |
|           *************************************************                  |
|                                                                              |
| ???? base64-??????????? ??????????? ? ??????????? ?????? ? ????? ?? ???????? |
|  3 ? 4.  ?.?. ??? 8-?? ?????? ????? (?????? 0-255) ?????????????? ? ??????   |
|  ???????, ??? ??????? ???????? 6 ?????? (?????? 0-63). ??????? base64        |
|  ??????? ?? 64 ????????:                                                     |
|       ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/       |
|  ??? ?????? A ????? ??? 0, ? ?????? / ????? ??? 63.                          |
|                                                                              |
| ??????. ????? ??? ????? 103, 193, 58. ?? ???? ???????????? ? base64 ??????.  |
| 1. ????? ?????? 6 ?????? ??????? ????? (103) ? ?????????? ?? ? ????? base64  |
|    6-?? ?????? ???. ???????? ????? 25.                                       |
| 2. ????? ?????????? 2 ????? ??????? ????? (103) ? ?????? 4 ????? ???????     |
|    ????? (193). ?????????? ?? ?? ?????? base64 6-?? ?????? ???. ????????     |
|    ????? 60.                                                                 |
| 3. ????? ?????????? 4 ????? ??????? ????? (193) ? 2 ?????? ????? ????????    |
|    ????? (58). ?????????? ?? ? ?????? base64 6-?? ?????? ???. ????????       |
|    ????? 4.                                                                  |
| 4. ????? ????????? 6 ?????? ???????? ????? (58) ? ?????????? ?? ? ?????????  |
|    base64 6-?? ?????? ???. ???????? ????? 58.                                |
| 5. ?????????? ? base64 ????????:                                             |
|        ????? ??????? ??????? ? ??????? ???????? = base64-??? + 1             |
|                                                                              |
|                 ?????????? ?????:    103       193       58                  |
|                   ???????? ?????: 01100111  11000001  00111010               |
|    ???????? 6-?? ???. base64-???: 011001 111100 000100 111010                |
|       ?????????? ??? base64-????:   25     60     4      58                  |
|                    base64 ??????:   Z      8      E      6                   |
|                                                                              |
|  ??? ??????, ???? ??? ?????? ????????? ?????? ?? ????? ????? ???? ?????????? |
|   ????? ????? ? ???? ?????? ???? ????????? ???:                              |
|   1. ???? ????????? ???? ????, ?? ? ????? base64 ???????? ???????????? ???   |
|   ??????? = (?????):                                                         |
|                       Ew==                                                   |
|   2. ???? ??????????? ??? ????, ?? ???????????? ???? ?????? ?????:           |
|                       Ew6=                                                   |
|   3. ???? ??????????? ??? ???????, ?? ?????? ?? ????????????:                |
|                      Ew6y                                                    |
|                                                                              |
|    Base64 ????? ??????????:                                                  |
|  - ????? base64 ???????????? ?????? ?????? ?????????? ?? ????? 72 ????????.  |
|                                                                              |
|                             ??? ???????????? ??????.                         |
|                                                                              |
|1. ?????????? ?????? Base64Unit ? ?????? ???????                              |
|                                                                              |
|2. ???????????                                                                |
|2.1 ????????? ?????????? ???? TBase64.ByteArr ??????? ??????? ? ?????????     |
|    ? TBase64.ByteCount ?????????? ???? ? ???????????                         |
|2.2 ???????? ??????? CodeBase64(TBase64), ? ?????????? ???????? String        |
|    ?????????????? ? ??????? base64                                           |
|2.3 ??? ????????? ????????????? base64 ??????? ?? ????????, ??? ??? ??????    |
|    ?????? ?????????? 72 ???????.                                             |
|                                                                              |
|3. ?????????????                                                              |
|3.1 ???????? ??????? DecodeBase64, ? ???????? ????????? ???????? ??????       |
|    ??????? base64 ???????????? ??????, ? ?????????? ???????? ???????????-    |
|    ??? ????? ? ??????? TBase64.ByteArr ? ?? ?????????? ? TBase64.ByteCount   |
|                                                                              |
| (c) 2002 ??????? ?.?.                                                        |
|   http://www.inta.portal.ru/dark/index.html                                  |
|   mailto:dark@online.ru                                                      |
|                                                                              |
|
|       ***************************************************************        |
|  ?? ?????? ???????????? ???? ?????? ?? ?????? ??????????, ??? ???????        |
|                ?????????? ???? ???????????? ????????.                        |
|                                                                              |
+------------------------------------------------------------------------------+
*)

unit Base64Unit;

interface
Const
//base64 ???????
base64ABC='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

Type
TBase64 = Record //????????? ??? ?????? ? base64
ByteArr  : Array [0..2] Of Byte;//?????? ?? ???? ??????
ByteCount:Byte;                 //?????????? ????????? ????
End;

//???????? base64
Function CodeBase64(Base64:TBase64):String;
//?????????? base64
Function DecodeBase64(StringValue:String):TBase64;

implementation
//==============================CodeBase64======================================
//???????? base64
Function CodeBase64(Base64:TBase64):String;
Var
N,M:Byte;
Dest,        //????????? - 6-?? ?????? ????? ? base64-?????
Sour:Byte;   //???????? 8-?? ?????? ?????
NextNum:Byte;// ????-??????? ??? ?????? ?????? ?? ????????? 6-?? ?????? ??????
Temp:Byte;   //??????????????? ?????????? ???????????? ??? ???????? ???????? ?????
             //8-?? ??????? ????????? ?????
Begin {CodeBase64}
//???????? ?????????
Result:='';
//?????????????? ???? - "???????? 6-?? ?????? ?????"
NextNum:=1;
//???????? 6-?? ?????? ?????????
Dest:=0;
//????? ???????? ? ???????? ?? ???? ??????
For N:=0 To 2 Do
Begin {For N}
//????? ????????? ????-????????
Sour:=Base64.ByteArr[N];
//????????? ?? ???? 8-?? ????? ????? ?????????
For M:=0 To 7 Do
Begin {For M}
//????? ???????? ?? ? ????? ?????? ??????????, ? ? ??? ??????
Temp:=Sour;
//?????? ???????? ????? ????? ??? ?????-????????? ? ?????-?????????
Temp:=Temp SHL M;
Dest:=Dest SHL 1;
//???? ??????? ??? ?????-????????? ????? 1
If (Temp And 128) = 128 Then
//? ????? ????????? ????????????? ??????? ??? ? 1
Dest:=Dest Or 1;
//??????????? ??????? ???????? ? ?????????? ?????-?????????
Inc(NextNum);
//???? ?????????? ??? 6 ????? ?????-?????????
If NextNum > 6 Then
Begin {If NextNum}
//????????? ????????? ???????, ???????? ? ???? ?????? ?? ?????? base64-????????
//? ????? ?? 1 ??????, ??? Dest (base64 ???? ?????????? ? 0, ? ??? ???????
//??????? ?????? base64-???????? 1).
Result:=Result+base64ABC[Dest+1];
//???????? ??????? ???????????? ??? 6-?? ??????? ?????-????????
NextNum:=1;
//???????? ?????-????????
Dest:=0;
End; {If NextNum}
End; {For M}
End;{For N}
//??????? ???????? ???? = (?????)
//???? ????, ???? ?????????????? ??? ????? ? ??? ?????, ???? ?????????????? 1 ????
//?? ????????, ??? ???????????? ?????? ??????? ?? 4 ????????
If Base64.ByteCount < 3 Then
For N:=0 To (2 - Base64.ByteCount) Do
Result[4-N]:='=';

End;  {CodeBase64}
//==============================CodeBase64======================================
//******************************************************************************
//================================DecodeBase64==================================
//?????????? base64
Function DecodeBase64(StringValue:String):TBase64;
Var
M,N:Integer;
Dest,           //6-?? ?????? ?????-????????
Sour:Byte;      //8-?? ?????? ????-????????
NextNum:Byte;   //????-??????? ???????? ? ?????????? 8-?? ??????? ?????
CurPos:Byte;    //??????? ??????? ? ??????? TBase64.ByteArr ???????????????
                 //8-?? ??????? ?????-?????????
Begin {DecodeBase64}
//???????? ??????? ???? ??????????
CurPos:=0;
Dest:=0;
NextNum:=1;
FillChar(Result,SizeOf(Result),#0);
//????? ???????????? ?????? ?? 4 ???????? base64-???????????? ??????
For N:=1 To 4 Do
Begin {For N}
//????? ???????????? ?????? ??? 6-?? ??????? ?????-?????????
For M:=0 To 5 Do
Begin {For M}
//???? ?????????????? ?????? "?????????? ??????", ???????? ?????-????????
If StringValue[N]='=' Then
Sour:=0
Else
//????? ? ????? ???????? ?????????? ??? ???????
Sour:=Pos(StringValue[N],base64ABC)-1;
//?????? ???????? ????? ????? ??? ????? ???????? ? ???????
Sour:=Sour SHL M;
Dest:=Dest SHL 1;
//??????? ??????? (??????) ??? 6-?? ??????? ?????-?????????
//???? ??? ??????????, ?? ????????????? ??????? ??? ?????-?????????
If (Sour And 32)=32 Then
Dest:=Dest Or 1;
//??????????? ??????? ???????? ????????? 8-?? ??????? ?????
Inc(NextNum);
//???? ?????????? ??? ?????? ???
If NextNum > 8 Then
Begin {If NextNum}
//???????? ????-???????
NextNum:=1;
//?????????? ? ?????? ?????????? ????
Result.ByteArr[CurPos]:=Dest;
//???? ????????????? ?????? "???? ?????????? ?????"
If StringValue[N]='=' Then
//??????? ?????????? ????
Result.ByteArr[CurPos]:=0
Else
//?????, ???????? ??????? ????????? ??????
Result.ByteCount:=CurPos+1;
//????? ???????????? ????????? ???? ? ??????? ?????? TBase64.ByteArr
Inc(CurPos);
Dest:=0;
End;   {If NextNum}
End;   {For M}
End;   {For N}
End;  {DecodeBase64}

end.
