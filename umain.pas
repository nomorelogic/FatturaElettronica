unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mssqlconn, sqldb, db, FileUtil, SynEdit, SynHighlighterSQL,
  Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Buttons, DBGrids, MaskEdit, Menus, DbCtrls, ActnList
  , uefattura
  ;


type


  { TfmMain }

  TfmMain = class(TForm)
    acFatt_RemoveGeneration: TAction;
    acFatt_CheckXml: TAction;
    acFatt_Preview_Ministeriale: TAction;
    acFatt_Preview_4M: TAction;
    acFatt_Preview_Zucchetti: TAction;
    acCtrl_Preferences: TAction;
    acCtrl_Refresh: TAction;
    acCtrl_Execute: TAction;
    acFatt_Regenerate: TAction;
    acEdit_Cliente: TAction;
    acEdit_Doc_Mast: TAction;
    ActionList1: TActionList;
    Button3: TButton;
    ColorDialog1: TColorDialog;
    DataSource1: TDataSource;
    dsPagamenti: TDataSource;
    dsModPagamento: TDataSource;
    dsVociIva: TDataSource;
    dseFattAzi: TDataSource;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    Label20: TLabel;
    XmlResult: TSynEdit;
    miImposta_DatiDocumento: TMenuItem;
    miImposta_Cliente: TMenuItem;
    miImposta: TMenuItem;
    miRigenera: TMenuItem;
    miAnteprima_LayZuc: TMenuItem;
    miVerifica: TMenuItem;
    miAnteprima_LayMin: TMenuItem;
    miAnteprima_Lay4M: TMenuItem;
    miAnnullaGen: TMenuItem;
    miAnteprima: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    pnDoc_Body: TPanel;
    pnDoc_Top1: TPanel;
    pmDoc: TPopupMenu;
    SaveDialog1: TSaveDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SynSQLSyn1: TSynSQLSyn;
    tsDocumenti: TTabSheet;
    procedure Button3Click(Sender: TObject);
  private
    { private declarations }

    procedure TestDemo;

  public
    { public declarations }

  end;

var
  fmMain: TfmMain;

implementation

{$R *.lfm}

uses dateutils
     , efatt.xmlwriter
     ;

{ TfmMain }

procedure TfmMain.Button3Click(Sender: TObject);
begin
  TestDemo;
end;

procedure TfmMain.TestDemo;
var xmlf: TEFattXmlWriter;
    eFatt: TEFattura;
    eFattBody: TEFatturaBody;
    doa:TEFatturaBody_DatiGenerali_DatiOrdineAcquisto;
    linea: TEFatturaBody_DatiBeniServizi_DettaglioLinee;
    riepiva: TEFatturaBody_DatiBeniServizi_DatiRiepilogo;
    pag: TEFatturaBody_DatiPagamento;
    pagdett: TEFatturaBody_DatiPagamento_DettaglioPagamento;
begin
   eFatt:=TEFattura.Create;

   // --------------------------------------------
   // popola con dati demo
   // --------------------------------------------

   // - - - header - - -
   with eFatt.FatturaElettronicaHeader do begin
       DatiTrasmissione.IdTrasmittente.IdPaese:='IT';
       DatiTrasmissione.IdTrasmittente.IdCodice:='01234567890';
       DatiTrasmissione.ProgressivoInvio:='00001';
       DatiTrasmissione.FormatoTrasmissione:='FPR12';
       DatiTrasmissione.CodiceDestinatario:='ABC1234';
       DatiTrasmissione.ContattiTrasmittente.email:='';

       CedentePrestatore.DatiAnagrafici.IdFiscaleIVA.IdPaese:='IT';
       CedentePrestatore.DatiAnagrafici.IdFiscaleIVA.IdCodice:='01234567890';
       CedentePrestatore.DatiAnagrafici.Anagrafica.Denominazione:='SOCIETA'' ALPHA SRL';
       CedentePrestatore.DatiAnagrafici.RegimeFiscale:='RF01';
       CedentePrestatore.Sede.Indirizzo:='VIALE ROMA 543';
       CedentePrestatore.Sede.CAP:='07100';
       CedentePrestatore.Sede.Comune:='SASSARI';
       CedentePrestatore.Sede.Provincia:='SS';
       CedentePrestatore.Sede.Nazione:='IT';
       CedentePrestatore.IscrizioneREA.Ufficio:='MC';
       CedentePrestatore.IscrizioneREA.NumeroREA:='0123456';
       CedentePrestatore.IscrizioneREA.CapitaleSociale:='28000000.00';
       CedentePrestatore.IscrizioneREA.SocioUnico:='SU';
       CedentePrestatore.IscrizioneREA.StatoLiquidazione:='LN';

       CessionarioCommittente.DatiAnagrafici.CodiceFiscale:='09876543210';
       CessionarioCommittente.DatiAnagrafici.Anagrafica.Denominazione:='BETA GAMMA';
       CessionarioCommittente.Sede.Indirizzo:='VIA TORINO 38-B';
       CessionarioCommittente.Sede.CAP:='00145';
       CessionarioCommittente.Sede.Comune:='ROMA';
       CessionarioCommittente.Sede.Provincia:='RM';
       CessionarioCommittente.Sede.Nazione:='IT';
   end;

   // - - - body 1 - - -
   eFattBody:=TEFatturaBody.Create;
   eFatt.FatturaElettronicaBody_Lista.Add(eFattBody);
   with eFattBody do begin
       DatiGenerali.DatiGeneraliDocumento.TipoDocumento:='TD01';
       DatiGenerali.DatiGeneraliDocumento.Divisa:='EUR';
       DatiGenerali.DatiGeneraliDocumento.Data:=EncodeDate(2014,12,18);
       DatiGenerali.DatiGeneraliDocumento.Numero:='123';
       DatiGenerali.DatiGeneraliDocumento.ImportoTotaleDocumento:=1230.00;
       DatiGenerali.DatiGeneraliDocumento.Causale.Add('LA FATTURA FA RIFERIMENTO AD UNA OPERAZIONE AAAA BBBBBBBBBBBBBBBBBB CCC...');
       DatiGenerali.DatiGeneraliDocumento.Causale.Add('SEGUE DESCRIZIONE CAUSALE NEL CASO IN CUI NON SIANO STATI SUFFICIENTI 200 CARATTERI AAAAAAAAAAA BBBBBBBBBBBBBBBBB');

       // loop DatiOrdineAcquisto
       doa:=TEFatturaBody_DatiGenerali_DatiOrdineAcquisto.Create;
       doa.RiferimentoNumeroLinea.Add('1');
       doa.IdDocumento:='66685';
       doa.NumItem:='1';
       DatiGenerali.DatiOrdineAcquisto_Lista.Add(doa);

       DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.IdFiscaleIVA.IdPaese:='IT';
       DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.IdFiscaleIVA.IdCodice:='24681012141';
       DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.Anagrafica.Denominazione:='Trasporto spa';
       DatiGenerali.DatiTrasporto.DataOraConsegna:=EncodeDateTime(2012,10,22,16,46,12,000);

       // loop DettaglioLinee
       linea:=TEFatturaBody_DatiBeniServizi_DettaglioLinee.Create;
       linea.NumeroLinea:=1;
       linea.Descrizione:='LA DESCRIZIONE DELLA FORNITURA PUO'' SUPERARE I CENTO CARATTERI CHE RAPPRESENTAVANO IL PRECEDENTE LIMITE DIMENSIONALE. TALE LIMITE NELLA NUOVA VERSIONE E'' STATO PORTATO A MILLE CARATTERI';
       linea.Quantita:=5.00;
       linea.PrezzoUnitario:=1.00;
       linea.PrezzoTotale:=5.00;
       linea.AliquotaIVA:=22.00;
       DatiBeniServizi.DettaglioLinee.Add(linea);

       linea:=TEFatturaBody_DatiBeniServizi_DettaglioLinee.Create;
       linea.NumeroLinea:=2;
       linea.Descrizione:='FORNITURE VARIE PER UFFICIO';
       linea.Quantita:=10.00;
       linea.PrezzoUnitario:=2.00;
       linea.PrezzoTotale:=20.00;
       linea.AliquotaIVA:=22.00;
       DatiBeniServizi.DettaglioLinee.Add(linea);

       // loop DatiRiepilogo
       riepiva:=TEFatturaBody_DatiBeniServizi_DatiRiepilogo.Create;
       riepiva.AliquotaIVA:=22.00;
       riepiva.ImponibileImporto:=27.00;
       riepiva.Imposta:=5.95;
       riepiva.EsigibilitaIVA:='I';
       DatiBeniServizi.DatiRiepilogo.Add(riepiva);

       // loop DatiPagamento
       pag:=TEFatturaBody_DatiPagamento.Create;
       pag.CondizioniPagamento:='TP01';
       Datipagamento.Add(pag);
         // loop DatiPagamento.DettaglioPagamento
         pagdett:=TEFatturaBody_DatiPagamento_DettaglioPagamento.Create;
         pagdett.ModalitaPagamento:='MP01';
         pagdett.DataScadenzaPagamento:=EncodeDate(2015,01,30);
         pagdett.ImportoPagamento:=32.95;
         pag.DettaglioPagamento_Lista.Add(pagdett);
   end;
   // - - - body 2 - - -
   eFattBody:=TEFatturaBody.Create;
   eFatt.FatturaElettronicaBody_Lista.Add(eFattBody);
   with eFattBody do begin
       DatiGenerali.DatiGeneraliDocumento.TipoDocumento:='TD01';
       DatiGenerali.DatiGeneraliDocumento.Divisa:='EUR';
       DatiGenerali.DatiGeneraliDocumento.Data:=EncodeDate(2014,12,20);
       DatiGenerali.DatiGeneraliDocumento.Numero:='456';
       DatiGenerali.DatiGeneraliDocumento.ImportoTotaleDocumento:=1230.00;
       DatiGenerali.DatiGeneraliDocumento.Causale.Add('LA FATTURA FA RIFERIMENTO AD UNA OPERAZIONE AAAA BBBBBBBBBBBBBBBBBB CCC DDDDDDDDDDDDDDD E FFFFFFFFFFFFFFFFFFFF GGGGGGGGGG HHHHHHH II LLLLLLLLLLLLLLLLL MMM NNNNN OO PPPPPPPPPPP QQQQ RRRR SSSSSSSSSSSSSS');
       DatiGenerali.DatiGeneraliDocumento.Causale.Add('SEGUE DESCRIZIONE CAUSALE NEL CASO IN CUI NON SIANO STATI SUFFICIENTI 200 CARATTERI AAAAAAAAAAA BBBBBBBBBBBBBBBBB');

       // loop DatiOrdineAcquisto
       doa:=TEFatturaBody_DatiGenerali_DatiOrdineAcquisto.Create;
       doa.RiferimentoNumeroLinea.Add('1');
       doa.IdDocumento:='66685';
       doa.NumItem:='1';
       DatiGenerali.DatiOrdineAcquisto_Lista.Add(doa);

       // loop DettaglioLinee
       linea:=TEFatturaBody_DatiBeniServizi_DettaglioLinee.Create;
       linea.NumeroLinea:=1;
       linea.Descrizione:='PRESTAZIONE DEL SEGUENTE SERVIZIO PROFESSIONALE: LA DESCRIZIONE DELLA PRESTAZIONE PUO'' SUPERARE I CENTO CARATTERI CHE RAPPRESENTAVANO IL PRECEDENTE LIMITE DIMENSIONALE. TALE LIMITE NELLA NUOVA VERSIONE E'' STATO PORTATO A MILLE CARATTERI';
       linea.PrezzoUnitario:=2000.00;
       linea.PrezzoTotale:=2000.00;
       linea.AliquotaIVA:=22.00;
       DatiBeniServizi.DettaglioLinee.Add(linea);

       // loop DatiRiepilogo
       riepiva:=TEFatturaBody_DatiBeniServizi_DatiRiepilogo.Create;
       riepiva.AliquotaIVA:=22.00;
       riepiva.ImponibileImporto:=2000.00;
       riepiva.Imposta:=440.00;
       riepiva.EsigibilitaIVA:='I';
       DatiBeniServizi.DatiRiepilogo.Add(riepiva);

       // loop DatiPagamento
       pag:=TEFatturaBody_DatiPagamento.Create;
       pag.CondizioniPagamento:='TP01';
       Datipagamento.Add(pag);
         // loop DatiPagamento.DettaglioPagamento
         pagdett:=TEFatturaBody_DatiPagamento_DettaglioPagamento.Create;
         pagdett.ModalitaPagamento:='MP19';
         pagdett.DataScadenzaPagamento:=EncodeDate(2015,01,28);
         pagdett.ImportoPagamento:=2440.00;
         pag.DettaglioPagamento_Lista.Add(pagdett);
   end;

   // genera file
   xmlf:=TEFattXmlWriter.Create(eFatt);
   try
      XmlResult.Lines.LoadFromFile( xmlf.SaveToXml('XmlDocument') );
      ShowMessage('Fattura elettronica generata');
   finally
      FreeAndNil(eFatt);
      FreeAndNil(xmlf);
   end;
end;


end.

