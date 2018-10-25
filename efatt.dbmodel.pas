unit efatt.dbmodel;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, mssqlconn, sqlite3conn, sqldb, FileUtil;


type

   { TdmMain }

   TdmMain = class(TDataModule)
      cnSqlLite3: TSQLite3Connection;
      tbMeta: TSQLQuery;
      SQLTransaction1: TSQLTransaction;
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleDestroy(Sender: TObject);
   private
      FLog: TStringList;
      procedure SaveLog;
   public
      function ConnectDatabase: boolean;
      procedure CheckDbSchema;


   end;

var
   dmMain: TdmMain;

implementation

{$R *.lfm}

{ TdmMain }

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
   FLog:=TStringList.Create;
end;

procedure TdmMain.DataModuleDestroy(Sender: TObject);
begin
   SaveLog;
   FLog.Free;
end;

procedure TdmMain.SaveLog;
begin
   FLog.SaveToFile( 'eFatt_dbmodel.log' );
end;

function TdmMain.ConnectDatabase: boolean;
begin
   result:=False;
   FLog.Add('ConnectDatabase: connecting...');
   try
     cnSqlLite3.Open;
     result:=True;
     FLog.Add('ConnectDatabase: connected');
   except
      on e: exception do begin
        FLog.Add('ConnectDatabase: *** ERROR ***');
        FLog.Add(e.Message);
      end;
   end;
   SaveLog;
end;

procedure TdmMain.CheckDbSchema;
var sSql: string;
begin
   tbMeta.Close;

   sSql:='SELECT count(*) FROM sqlite_master WHERE type=''table''';
   FLog.Add('CheckDbSchema: SQL : ' + sSql);
   tbMeta.SQL.Add(sSql);
   tbMeta.Open;
   tbMeta.Last; tbMeta.First;
   FLog.Add('CheckDbSchema: Table count = ' + IntToStr(tbMeta.RecordCount));

   // log tables
   if tbMeta.RecordCount > 0 then
       while not tbMeta.EOF do begin
          FLog.Add(Format('%10.10s %50.50s', [ tbMeta.FieldByName('type').AsString,
                                               tbMeta.FieldByName('name').AsString]));
          tbMeta.Next;
       end;
   SaveLog;

   // create

end;

end.

