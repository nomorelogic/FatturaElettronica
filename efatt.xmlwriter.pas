unit efatt.xmlwriter;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils
   , uefattura
   , DOM, XMLWrite
   ;

type

  { TEFattXmlWriter }

  TEFattXmlWriter = class(TObject)
  private
     FeFattura: TEFattura;
     FFormatSettings: TFormatSettings;
     function GetXmlFileName: string;
  public
    constructor Create(AeFattura: TEFattura);
    destructor Destroy; override;

    function getDocument: TXMLDocument;
    function SaveToXml(const AXmlRepository: string; const AFileNameXml: string=''): string;

    property eFattura: TEFattura read FeFattura write FeFattura;
    property XmlFileName: string read GetXmlFileName;
  end;


implementation

{ TEFattXmlWriter }

function TEFattXmlWriter.GetXmlFileName: string;
begin
  result:=Format('%2.2s%s_%5.5s.xml',
                 [  Trim(eFattura.FatturaElettronicaHeader.DatiTrasmissione.IdTrasmittente.IdPaese),
                    Trim(eFattura.FatturaElettronicaHeader.DatiTrasmissione.IdTrasmittente.IdCodice),
                    Trim(eFattura.FatturaElettronicaHeader.DatiTrasmissione.ProgressivoInvio)
                 ]);
end;

constructor TEFattXmlWriter.Create(AeFattura: TEFattura);
begin
   FeFattura:=AeFattura;
   FFormatSettings.DecimalSeparator:='.';
   FFormatSettings.ThousandSeparator:=',';
end;

destructor TEFattXmlWriter.Destroy;
begin
   inherited Destroy;
end;

function TEFattXmlWriter.getDocument: TXMLDocument;
var Doc: TXMLDocument;
    RootNode, parentNode, childNode, currNode: TDOMNode;

    procedure _FatturaElettronicaHeader(ARootNode: TDOMNode);
    var FatturaElettronicaHeader: TDOMNode;
        wsapp: widestring;
    begin
       // FatturaElettronicaHeader
       FatturaElettronicaHeader := Doc.CreateElement(DOMEL_FatturaElettronicaHeader);
       ARootNode.Appendchild(FatturaElettronicaHeader);

       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       // FatturaElettronicaHeader / DatiTrasmissione
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       parentNode := Doc.CreateElement(DOMEL_DatiTrasmissione);
       FatturaElettronicaHeader.AppendChild(parentNode);

       // .. IdTrasmittente
       childNode := Doc.CreateElement(DOMEL_IdTrasmittente);
       parentNode.AppendChild(childNode);

       with childNode do begin
          AppendChild(Doc.CreateElement(DOMEL_IdPaese)).AppendChild(
             Doc.CreateTextNode( eFattura.FatturaElettronicaHeader.DatiTrasmissione.IdTrasmittente.IdPaese )
          );

          AppendChild(Doc.CreateElement(DOMEL_IdCodice)).AppendChild(
             Doc.CreateTextNode( eFattura.FatturaElettronicaHeader.DatiTrasmissione.IdTrasmittente.IdCodice )
          );
       end;

       // .. ProgressivoInvio
       parentNode.AppendChild(Doc.CreateElement(DOMEL_ProgressivoInvio)).AppendChild(
          Doc.CreateTextNode( eFattura.FatturaElettronicaHeader.DatiTrasmissione.ProgressivoInvio )
       );

       // .. FormatoTrasmissione
       parentNode.AppendChild(Doc.CreateElement(DOMEL_FormatoTrasmissione)).AppendChild(
          Doc.CreateTextNode( eFattura.FatturaElettronicaHeader.DatiTrasmissione.FormatoTrasmissione )
       );

       // .. CodiceDestinatario
       // non PA + vuole PEC ==> '0000000'
       // non PA + vuole ID ==> ID
       parentNode.AppendChild(Doc.CreateElement(DOMEL_CodiceDestinatario)).AppendChild(
          Doc.CreateTextNode( eFattura.FatturaElettronicaHeader.DatiTrasmissione.CodiceDestinatario )
       );


       // .. [ContattiTrasmittente]
       if eFattura.FatturaElettronicaHeader.DatiTrasmissione.ContattiTrasmittente.IsAssigned then begin
          currNode:=parentNode.AppendChild(Doc.CreateElement(DOMEL_ContattiTrasmittente));
          // Telefono
          if eFattura.FatturaElettronicaHeader.DatiTrasmissione.ContattiTrasmittente.Telefono<>'' then begin
             wsapp:=copy(eFattura.FatturaElettronicaHeader.DatiTrasmissione.ContattiTrasmittente.Telefono,1,12);
             currNode.AppendChild(Doc.CreateElement(DOMEL_Telefono)).AppendChild(Doc.CreateTextNode(wsapp));
          end;
          // Email
          if eFattura.FatturaElettronicaHeader.DatiTrasmissione.ContattiTrasmittente.email<>'' then begin
             wsapp:=copy(eFattura.FatturaElettronicaHeader.DatiTrasmissione.ContattiTrasmittente.email,1,256);
             currNode.AppendChild(Doc.CreateElement(DOMEL_Email)).AppendChild(Doc.CreateTextNode(wsapp));
          end;
          // Fax: sembra non ci sia....
       end;

       // .. [PECDestinatario]
       // parentNode
       //      .AppendChild(Doc.CreateElement('PECDestinatario'))
       //      .AppendChild(Doc.CreateTextNode('ABC1234'));
       wsapp := Trim(eFattura.FatturaElettronicaHeader.DatiTrasmissione.PecDestinatario);
       if wsapp <> '' then
          parentNode.AppendChild( Doc.CreateElement(DOMEL_PECDestinatario) )
                    .AppendChild( Doc.CreateTextNode( wsapp ) );

       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       // FatturaElettronicaHeader / CedentePrestatore
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       parentNode := Doc.CreateElement(DOMEL_CedentePrestatore);
       FatturaElettronicaHeader.AppendChild(parentNode);

       // ..
       // .. DatiAnagrafici
       // ..
       childNode := Doc.CreateElement(DOMEL_DatiAnagrafici);
       parentNode.AppendChild(childNode);
       with childNode do begin
          with AppendChild(Doc.CreateElement(DOMEL_IdFiscaleIVA)) do begin
               wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.IdFiscaleIVA.IdPaese;
               AppendChild(Doc.CreateElement(DOMEL_IdPaese)).AppendChild(Doc.CreateTextNode(wsapp));
               wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.IdFiscaleIVA.IdCodice;
               AppendChild(Doc.CreateElement(DOMEL_IdCodice)).AppendChild(Doc.CreateTextNode(wsapp));
          end;
       end;
       // [CodiceFiscale]
       with childNode do begin
          wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.CodiceFiscale;
          if wsapp <> '' then
             with AppendChild(Doc.CreateElement(DOMEL_CodiceFiscale)) do begin
                  AppendChild(Doc.CreateTextNode(wsapp));
             end;
       end;

       with childNode do begin
          with AppendChild(Doc.CreateElement(DOMEL_Anagrafica)) do begin
               wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.Anagrafica.Denominazione;
               if wsapp <> '' then
                  AppendChild(Doc.CreateElement(DOMEL_Denominazione)).AppendChild(Doc.CreateTextNode(wsapp));
               wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.Anagrafica.Nome;
               if wsapp <> '' then
                  AppendChild(Doc.CreateElement(DOMEL_Nome)).AppendChild(Doc.CreateTextNode(wsapp));
               wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.Anagrafica.Cognome;
               if wsapp <> '' then
                  AppendChild(Doc.CreateElement(DOMEL_Cognome)).AppendChild(Doc.CreateTextNode(wsapp));
          end;
       end;
       // [AlboProfessionale]
       // [ProvinciaAlbo]
       // [NumeroIscrizioneAlbo]
       // [DataIscrizioneAlbo]
       with childNode do begin
          with AppendChild(Doc.CreateElement(DOMEL_RegimeFiscale)) do begin
               wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.RegimeFiscale;
               if wsapp<>'' then
                  AppendChild(Doc.CreateTextNode(wsapp));
          end;
       end;

       // ..
       // .. Sede
       // ..
       childNode := Doc.CreateElement(DOMEL_Sede);
       parentNode.AppendChild(childNode);
       with childNode do begin
            wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.Sede.Indirizzo;
            if wsapp <> '' then
               AppendChild(Doc.CreateElement(DOMEL_Indirizzo)).AppendChild(Doc.CreateTextNode(wsapp));
            wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.Sede.CAP;
            if wsapp <> '' then
               AppendChild(Doc.CreateElement(DOMEL_CAP)).AppendChild(Doc.CreateTextNode(wsapp));
            wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.Sede.Comune;
            if wsapp <> '' then
               AppendChild(Doc.CreateElement(DOMEL_Comune)).AppendChild(Doc.CreateTextNode(wsapp));
            wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.Sede.Provincia;
            if wsapp <> '' then
               AppendChild(Doc.CreateElement(DOMEL_Provincia)).AppendChild(Doc.CreateTextNode(wsapp));
            wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.Sede.Nazione;
            if wsapp <> '' then
               AppendChild(Doc.CreateElement(DOMEL_Nazione)).AppendChild(Doc.CreateTextNode(wsapp));
       end;

       // ..
       // .. StabileOrganizzazione
       // ..


       // ..
       // .. IscrizioneREA
       // ..
       {$IFDEF NOT_EXCLUDE}
       wsapp:=Trim(eFattura.FatturaElettronicaHeader.CedentePrestatore.IscrizioneREA.NumeroREA);
       if wsapp <> '' then begin
          childNode := Doc.CreateElement(DOMEL_IscrizioneREA);
          parentNode.AppendChild(childNode);
          with childNode do begin
               wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.IscrizioneREA.Ufficio;
               if wsapp <> '' then
                  AppendChild(Doc.CreateElement(DOMEL_Ufficio)).AppendChild(Doc.CreateTextNode(wsapp));
               wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.IscrizioneREA.NumeroREA;
               if wsapp <> '' then
                  AppendChild(Doc.CreateElement(DOMEL_NumeroREA)).AppendChild(Doc.CreateTextNode(wsapp));
               wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.IscrizioneREA.CapitaleSociale;
               if wsapp <> '' then
                  AppendChild(Doc.CreateElement(DOMEL_CapitaleSociale)).AppendChild(Doc.CreateTextNode(wsapp));
               wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.IscrizioneREA.SocioUnico;
               if wsapp <> '' then
                  AppendChild(Doc.CreateElement(DOMEL_SocioUnico)).AppendChild(Doc.CreateTextNode(wsapp)); //  “SU”, nel caso di socio unico, oppure “SM” nel caso di società pluripersonale
               wsapp:=eFattura.FatturaElettronicaHeader.CedentePrestatore.IscrizioneREA.StatoLiquidazione;
               if wsapp <> '' then
                  AppendChild(Doc.CreateElement(DOMEL_StatoLiquidazione)).AppendChild(Doc.CreateTextNode(wsapp)); // “LS” per società in stato di liquidazione, oppure “LN” per società non in liquidazione

          end;
       end; // IscrizioneREA
       {$ENDIF}

       // ..


       // .. Contatti
       if eFattura.FatturaElettronicaHeader.CedentePrestatore.Contatti.IsAssigned then begin

          childNode := Doc.CreateElement(DOMEL_Contatti);
          parentNode.AppendChild(childNode);

          with childNode do begin

             wsapp:=Trim(eFattura.FatturaElettronicaHeader.CedentePrestatore.Contatti.Telefono);
             if wsapp <> '' then
                AppendChild(Doc.CreateElement(DOMEL_Telefono)).AppendChild(Doc.CreateTextNode(wsapp));
             wsapp:=Trim(eFattura.FatturaElettronicaHeader.CedentePrestatore.Contatti.Fax);
             if wsapp <> '' then
                AppendChild(Doc.CreateElement(DOMEL_Fax)).AppendChild(Doc.CreateTextNode(wsapp));
             wsapp:=Trim(eFattura.FatturaElettronicaHeader.CedentePrestatore.Contatti.email);
             if wsapp <> '' then
                AppendChild(Doc.CreateElement(DOMEL_Email)).AppendChild(Doc.CreateTextNode(wsapp));
          end;

       end;

       // .. RiferimentoAmministrazione
       // ..

       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       // FatturaElettronicaHeader / RappresentanteFiscale
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       // FatturaElettronicaHeader / CessionarioCommittente
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       parentNode := Doc.CreateElement(DOMEL_CessionarioCommittente);
       FatturaElettronicaHeader.AppendChild(parentNode);

       // ..
       // .. DatiAnagrafici
       // ..
       childNode := Doc.CreateElement(DOMEL_DatiAnagrafici);
       parentNode.AppendChild(childNode);

       if eFattura.FatturaElettronicaHeader.CessionarioCommittente.DatiAnagrafici.IdFiscaleIVA.IsAssigned then begin
          with childNode do begin
             with AppendChild(Doc.CreateElement(DOMEL_IdFiscaleIVA)) do begin
                  wsapp:=eFattura.FatturaElettronicaHeader.CessionarioCommittente.DatiAnagrafici.IdFiscaleIVA.IdPaese;
                  if wsapp <> '' then
                     AppendChild(Doc.CreateElement(DOMEL_IdPaese)).AppendChild(Doc.CreateTextNode(wsapp));
                  wsapp:=eFattura.FatturaElettronicaHeader.CessionarioCommittente.DatiAnagrafici.IdFiscaleIVA.IdCodice;
                  if wsapp <> '' then
                  AppendChild(Doc.CreateElement(DOMEL_IdCodice)).AppendChild(Doc.CreateTextNode(wsapp));
             end;
          end;
       end;

       wsapp:=eFattura.FatturaElettronicaHeader.CessionarioCommittente.DatiAnagrafici.CodiceFiscale;
       if wsapp <> '' then
          with childNode do begin
               AppendChild(Doc.CreateElement(DOMEL_CodiceFiscale)).AppendChild(Doc.CreateTextNode(wsapp));
          end;

       with childNode do begin
          with AppendChild(Doc.CreateElement(DOMEL_Anagrafica)) do begin
               wsapp:=eFattura.FatturaElettronicaHeader.CessionarioCommittente.DatiAnagrafici.Anagrafica.Denominazione;
               if wsapp <> '' then
                  AppendChild(Doc.CreateElement(DOMEL_Denominazione)).AppendChild(Doc.CreateTextNode(wsapp));
               wsapp:=eFattura.FatturaElettronicaHeader.CessionarioCommittente.DatiAnagrafici.Anagrafica.Nome;
               if wsapp <> '' then
                  AppendChild(Doc.CreateElement(DOMEL_Nome)).AppendChild(Doc.CreateTextNode(wsapp));
               wsapp:=eFattura.FatturaElettronicaHeader.CessionarioCommittente.DatiAnagrafici.Anagrafica.Cognome;
               if wsapp <> '' then
                  AppendChild(Doc.CreateElement(DOMEL_Cognome)).AppendChild(Doc.CreateTextNode(wsapp));
          end;
       end;
       // ..
       // .. Sede
       // ..
       childNode := Doc.CreateElement(DOMEL_Sede);
       parentNode.AppendChild(childNode);
       with childNode do begin
          wsapp:=eFattura.FatturaElettronicaHeader.CessionarioCommittente.Sede.Indirizzo;
          if wsapp <> '' then
               AppendChild(Doc.CreateElement(DOMEL_Indirizzo)).AppendChild(Doc.CreateTextNode(wsapp));
          wsapp:=eFattura.FatturaElettronicaHeader.CessionarioCommittente.Sede.CAP;
          if wsapp <> '' then
               AppendChild(Doc.CreateElement(DOMEL_CAP)).AppendChild(Doc.CreateTextNode(wsapp));
          wsapp:=eFattura.FatturaElettronicaHeader.CessionarioCommittente.Sede.Comune;
          if wsapp <> '' then
               AppendChild(Doc.CreateElement(DOMEL_Comune)).AppendChild(Doc.CreateTextNode(wsapp));
          wsapp:=eFattura.FatturaElettronicaHeader.CessionarioCommittente.Sede.Provincia;
          if wsapp <> '' then
               AppendChild(Doc.CreateElement(DOMEL_Provincia)).AppendChild(Doc.CreateTextNode(wsapp));
          wsapp:=eFattura.FatturaElettronicaHeader.CessionarioCommittente.Sede.Nazione;
          if wsapp <> '' then
               AppendChild(Doc.CreateElement(DOMEL_Nazione)).AppendChild(Doc.CreateTextNode(wsapp));
       end;


    end;  // _FatturaElettronicaHeader


    procedure _FatturaElettronicaBody(ARootNode: TDOMNode);
    var FatturaElettronicaBody: TDOMNode;
        s: string;
        wsapp: WideString;
        weapp: extended;
        iapp: integer;
        body: TEFatturaBody;
        doa:TEFatturaBody_DatiGenerali_DatiOrdineAcquisto;
        ddt:TEFatturaBody_DatiGenerali_DatiDDT;
        linea: TEFatturaBody_DatiBeniServizi_DettaglioLinee;
        riep: TEFatturaBody_DatiBeniServizi_DatiRiepilogo;
        adg: TEFatturaBody_DatiBeniServizi_DettaglioLinee_AltriDatiGestionali;
        pag: TEFatturaBody_DatiPagamento;
        scomag: TEFatturaBody_Generico_ScontoMaggiorazione;
    begin

       for body in eFattura.FatturaElettronicaBody_Lista do begin

          // FatturaElettronicaBody
          FatturaElettronicaBody := Doc.CreateElement(DOMEL_FatturaElettronicaBody);
          ARootNode.Appendchild(FatturaElettronicaBody);

          // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          // _FatturaElettronicaBody / DatiGenerali
          // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          parentNode := Doc.CreateElement(DOMEL_DatiGenerali);
          FatturaElettronicaBody.AppendChild(parentNode);

          // .. DatiGeneraliDocumento
          childNode := Doc.CreateElement(DOMEL_DatiGeneraliDocumento);
          parentNode.AppendChild(childNode);
          with childNode do begin
             wsapp:=body.DatiGenerali.DatiGeneraliDocumento.TipoDocumento;
             if wsapp<>'' then
                AppendChild(Doc.CreateElement(DOMEL_TipoDocumento)).AppendChild(Doc.CreateTextNode(wsapp)); // TD01..TD06
             wsapp:=body.DatiGenerali.DatiGeneraliDocumento.Divisa;
             if wsapp<>'' then
                AppendChild(Doc.CreateElement(DOMEL_Divisa)).AppendChild(Doc.CreateTextNode(wsapp)); // es.: EUR, USD, GBP, CZK
             wsapp:=WideString(FormatDateTime('yyyy-mm-dd', body.DatiGenerali.DatiGeneraliDocumento.Data));
             if wsapp<>'' then
                AppendChild(Doc.CreateElement(DOMEL_Data)).AppendChild(Doc.CreateTextNode(wsapp)); // YYYY-MM-DD
             wsapp:=body.DatiGenerali.DatiGeneraliDocumento.Numero;
             if wsapp<>'' then
                AppendChild(Doc.CreateElement(DOMEL_Numero)).AppendChild(Doc.CreateTextNode(wsapp)); // lunghezza massima di 20 caratteri
          end;

          // with childNode do begin
          //    AppendChild(Doc.CreateElement('DatiRitenuta')) do begin
          //       AppendChild(Doc.CreateElement('TipoRitenuta')).AppendChild(Doc.CreateTextNode(''));
          //       AppendChild(Doc.CreateElement('ImportoRitenuta')).AppendChild(Doc.CreateTextNode(''));
          //       AppendChild(Doc.CreateElement('AliquotaRitenuta')).AppendChild(Doc.CreateTextNode(''));
          //       AppendChild(Doc.CreateElement('CausalePagamento')).AppendChild(Doc.CreateTextNode(''));
          //    end;
          // end;

          // with childNode do begin
          //    AppendChild(Doc.CreateElement('DatiBollo')) do begin
          //       AppendChild(Doc.CreateElement('BolloVirtuale')).AppendChild(Doc.CreateTextNode('SI')); // 'SI'|''
          //       AppendChild(Doc.CreateElement('ImportoBollo')).AppendChild(Doc.CreateTextNode('25.00'));
          //    end;
          // end;

          // with childNode do begin
          //    AppendChild(Doc.CreateElement('DatiCassaPrevidenziale')) do begin
          //       AppendChild(Doc.CreateElement('TipoCassa')).AppendChild(Doc.CreateTextNode(''));
          //       AppendChild(Doc.CreateElement('AlCassa')).AppendChild(Doc.CreateTextNode(''));
          //       AppendChild(Doc.CreateElement('ImportoContributoCassa')).AppendChild(Doc.CreateTextNode(''));
          //       AppendChild(Doc.CreateElement('ImponibileCassa')).AppendChild(Doc.CreateTextNode(''));
          //       AppendChild(Doc.CreateElement('AliquotaIVA')).AppendChild(Doc.CreateTextNode(''));
          //       AppendChild(Doc.CreateElement('Ritenuta')).AppendChild(Doc.CreateTextNode(''));
          //       AppendChild(Doc.CreateElement('Natura')).AppendChild(Doc.CreateTextNode(''));
          //       AppendChild(Doc.CreateElement('RiferimentoAmministrazione')).AppendChild(Doc.CreateTextNode(''));
          //    end;
          // end;

          // with childNode do begin
          //    AppendChild(Doc.CreateElement('ScontoMaggiorazione')) do begin
          //       AppendChild(Doc.CreateElement('Tipo')).AppendChild(Doc.CreateTextNode('')); // SC sconto, MG maggiorazione
          //       // Percentuale XOR Importo
          //       AppendChild(Doc.CreateElement('Percentuale')).AppendChild(Doc.CreateTextNode('')); // es.: 5.00
          //       AppendChild(Doc.CreateElement('Importo')).AppendChild(Doc.CreateTextNode('')); // es.: 55.00
          //    end;
          // end;

          with childNode do begin
             if body.DatiGenerali.DatiGeneraliDocumento.ImportoTotaleDocumentoIsAssegned then begin;
                weapp:=body.DatiGenerali.DatiGeneraliDocumento.ImportoTotaleDocumento;
                wsapp:=WideString(FormatFloat('0.00', weapp, self.FFormatSettings));
                AppendChild(Doc.CreateElement(DOMEL_ImportoTotaleDocumento)).AppendChild(Doc.CreateTextNode(wsapp));
             end;

             weapp:=body.DatiGenerali.DatiGeneraliDocumento.Arrotondamento;
             if weapp<>0.0 then begin
                wsapp:=WideString(FormatFloat('#,##0.00', weapp));
                AppendChild(Doc.CreateElement(DOMEL_Arrotondamento)).AppendChild(Doc.CreateTextNode(wsapp));
             end;

             if body.DatiGenerali.DatiGeneraliDocumento.Causale.Count > 0 then
                for s in body.DatiGenerali.DatiGeneraliDocumento.Causale do begin
                    wsapp:=WideString(s);
                    AppendChild(Doc.CreateElement(DOMEL_Causale)).AppendChild(Doc.CreateTextNode(wsapp));
                end;

             wsapp:=body.DatiGenerali.DatiGeneraliDocumento.Art73;
             if wsapp <> '' then
                AppendChild(Doc.CreateElement(DOMEL_Art73)).AppendChild(Doc.CreateTextNode(wsapp)); // 'SI'|''
          end;

          // .. DatiOrdineAcquisto (opzionale, ripetuto)
          if body.DatiGenerali.DatiOrdineAcquisto_Lista.Count > 0 then begin;
             childNode := Doc.CreateElement(DOMEL_DatiOrdineAcquisto);
             parentNode.AppendChild(childNode);
             for doa in body.DatiGenerali.DatiOrdineAcquisto_Lista do begin
                 with childNode do begin
                      if doa.RiferimentoNumeroLinea.Count>0 then
                         for s in doa.RiferimentoNumeroLinea do begin
                             wsapp:=WideString(s);
                             AppendChild(Doc.CreateElement(DOMEL_RiferimentoNumeroLinea)).AppendChild(Doc.CreateTextNode(wsapp)); // [opz]
                         end;
                      wsapp:=doa.IdDocumento;
                      if wsapp<>'' then
                         AppendChild(Doc.CreateElement(DOMEL_IdDocumento)).AppendChild(Doc.CreateTextNode(wsapp));
                      if doa.Data <> 0 then begin
                         wsapp:=widestring(FormatDateTime('yyyy-mm-dd', doa.Data));
                         AppendChild(Doc.CreateElement(DOMEL_Data)).AppendChild(Doc.CreateTextNode(wsapp)); // [opz]
                      end;
                      wsapp:=doa.NumItem;
                      if wsapp<>'' then
                         AppendChild(Doc.CreateElement(DOMEL_NumItem)).AppendChild(Doc.CreateTextNode(wsapp)); // [opz]
                      wsapp:=doa.CodiceCommessaConvenzione;
                      if wsapp<>'' then
                         AppendChild(Doc.CreateElement(DOMEL_CodiceCommessaConvenzione)).AppendChild(Doc.CreateTextNode(wsapp)); // [opz]
                      wsapp:=doa.CodiceCUP;
                      if wsapp<>'' then
                         AppendChild(Doc.CreateElement(DOMEL_CodiceCUP)).AppendChild(Doc.CreateTextNode(wsapp)); // [opz]
                      wsapp:=doa.CodiceCIG;
                      if wsapp<>'' then
                         AppendChild(Doc.CreateElement(DOMEL_CodiceCIG)).AppendChild(Doc.CreateTextNode(wsapp)); // [opz]
                 end; // with childNode
             end; // for ..
          end; // .. DatiOrdineAcquisto

          // .. DatiContratto (opzionale, ripetuto)
          // .. DatiConvenzione (opzionale, ripetuto)
          // .. DatiRicezione (opzionale, ripetuto)
          // .. DatiFattureCollegate (opzionale, ripetuto)
          // .. DatiSAL (opzionale)

          // .. DatiDDT (opzionale, ripetuto)
          if body.DatiGenerali.DatiDDT_Lista.Count > 0 then begin
             for ddt in body.DatiGenerali.DatiDDT_Lista do begin
                childNode := Doc.CreateElement(DOMEL_DatiDDT);
                parentNode.AppendChild(childNode);
                with childNode do begin
                   if ddt.NumeroDDT <> '' then
                      AppendChild(Doc.CreateElement(DOMEL_NumeroDDT)).AppendChild(Doc.CreateTextNode(ddt.NumeroDDT));
                   if ddt.DataDDT <> 0 then begin
                      wsapp:=WideString(FormatDateTime('yyyy-mm-dd', ddt.DataDDT));
                      AppendChild(Doc.CreateElement(DOMEL_DataDDT)).AppendChild(Doc.CreateTextNode(wsapp));
                   end;
                   if ddt.RiferimentoNumeroLinea.Count>0 then begin
                      for s in ddt.RiferimentoNumeroLinea do begin
                          wsapp:=WideString(s);
                          AppendChild(Doc.CreateElement(DOMEL_RiferimentoNumeroLinea)).AppendChild(Doc.CreateTextNode(wsapp));
                      end;
                   end;
                end; // with childNode
             end; // for
          end; // if DatiDDT

          // .. DatiTrasporto (opzionale)
          if body.DatiGenerali.DatiTrasporto.IsAssigned then begin
             childNode := Doc.CreateElement(DOMEL_DatiTrasporto);
             parentNode.AppendChild(childNode);

             // ... DatiAnagraficiVettore
             if body.DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.IsAssigned then begin
                currNode:=childNode.AppendChild(Doc.CreateElement(DOMEL_DatiAnagraficiVettore));

                // .... IdFiscaleIVA
                if body.DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.IdFiscaleIVA.IsAssigned then begin
                   with currNode.AppendChild(Doc.CreateElement(DOMEL_IdFiscaleIVA)) do begin
                      wsapp:=body.DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.IdFiscaleIVA.IdPaese;
                      AppendChild(Doc.CreateElement(DOMEL_IdPaese)).AppendChild(Doc.CreateTextNode(wsapp));
                      wsapp:=body.DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.IdFiscaleIVA.IdCodice;
                      AppendChild(Doc.CreateElement(DOMEL_IdCodice)).AppendChild(Doc.CreateTextNode(wsapp));
                   end; // with
                end; //  if IdFiscaleIVA

                // .... CodiceFiscale
                wsapp:=body.DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.CodiceFiscale;
                if wsapp<>'' then begin
                   currNode.AppendChild(Doc.CreateElement(DOMEL_CodiceFiscale)).AppendChild(Doc.CreateTextNode(wsapp))
                end;

                // .... Anagrafica
                if body.DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.Anagrafica.IsAssigned then begin
                   with currNode.AppendChild(Doc.CreateElement(DOMEL_Anagrafica)) do begin
                      wsapp:=body.DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.Anagrafica.Denominazione;
                      if wsapp<>'' then
                         AppendChild(Doc.CreateElement(DOMEL_Denominazione)).AppendChild(Doc.CreateTextNode(wsapp));
                      wsapp:=body.DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.Anagrafica.Cognome;
                      if wsapp<>'' then
                         AppendChild(Doc.CreateElement(DOMEL_Cognome)).AppendChild(Doc.CreateTextNode(wsapp));
                      wsapp:=body.DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.Anagrafica.Nome;
                      if wsapp<>'' then
                         AppendChild(Doc.CreateElement(DOMEL_Nome)).AppendChild(Doc.CreateTextNode(wsapp));
                   end; // with
                end; //  if IdFiscaleIVA

             end; // if DatiAnagraficiVettore

             with childNode do begin
                  // ... MezzoTrasporto
                  wsapp:=body.DatiGenerali.DatiTrasporto.MezzoTrasporto;
                  if wsapp<>'' then
                     AppendChild(Doc.CreateElement(DOMEL_MezzoTrasporto)).AppendChild(Doc.CreateTextNode(wsapp));
                  // ... CausaleTrasporto
                  wsapp:=body.DatiGenerali.DatiTrasporto.CausaleTrasporto;
                  if wsapp<>'' then
                     AppendChild(Doc.CreateElement(DOMEL_CausaleTrasporto)).AppendChild(Doc.CreateTextNode(wsapp));
                  // ... NumeroColli
                  if body.DatiGenerali.DatiTrasporto.NumeroColli>0 then begin
                     wsapp:=Widestring(IntToStr(body.DatiGenerali.DatiTrasporto.NumeroColli));
                     AppendChild(Doc.CreateElement(DOMEL_NumeroColli)).AppendChild(Doc.CreateTextNode(wsapp));
                  end;
                  // ... Descrizione
                  wsapp:=body.DatiGenerali.DatiTrasporto.Descrizione;
                  if wsapp<>'' then
                     AppendChild(Doc.CreateElement(DOMEL_Descrizione)).AppendChild(Doc.CreateTextNode(wsapp));
                  // ... UnitaMisuraPeso
                  wsapp:=body.DatiGenerali.DatiTrasporto.UnitaMisuraPeso;
                  if wsapp<>'' then
                     AppendChild(Doc.CreateElement(DOMEL_UnitaMisuraPeso)).AppendChild(Doc.CreateTextNode(wsapp));
                  // ... PesoLordo
                  if body.DatiGenerali.DatiTrasporto.PesoLordo>0 then begin
                     wsapp:=Widestring(FormatFloat('0.00', body.DatiGenerali.DatiTrasporto.PesoLordo));
                     AppendChild(Doc.CreateElement(DOMEL_PesoLordo).AppendChild(Doc.CreateTextNode(wsapp)));
                  end;
                  // ... PesoNetto
                  if body.DatiGenerali.DatiTrasporto.PesoNetto>0 then begin
                     wsapp:=Widestring(FormatFloat('0.00', body.DatiGenerali.DatiTrasporto.PesoNetto));
                     AppendChild(Doc.CreateElement(DOMEL_PesoNetto)).AppendChild(Doc.CreateTextNode(wsapp));
                  end;
                  // ... DataOraRitiro
                  if body.DatiGenerali.DatiTrasporto.DataOraRitiro<>0 then begin
                     s:=FormatDateTime('yyyy-mm-ddThh:nn:ss.ccc', body.DatiGenerali.DatiTrasporto.DataOraRitiro);
                     wsapp:=Widestring(s)+'+02:00';
                     AppendChild(Doc.CreateElement(DOMEL_DataOraRitiro)).AppendChild(Doc.CreateTextNode(wsapp));
                  end;
                  // ... DataInizioTrasporto
                  if body.DatiGenerali.DatiTrasporto.DataInizioTrasporto<>0 then begin
                     s:=FormatDateTime('yyyy-mm-dd', body.DatiGenerali.DatiTrasporto.DataInizioTrasporto);
                     wsapp:=Widestring(s);
                     AppendChild(Doc.CreateElement(DOMEL_DataInizioTrasporto)).AppendChild(Doc.CreateTextNode(wsapp));
                  end;
                  // ... TipoResa
                  wsapp:=body.DatiGenerali.DatiTrasporto.TipoResa;
                  if wsapp<>'' then
                     AppendChild(Doc.CreateElement(DOMEL_TipoResa)).AppendChild(Doc.CreateTextNode(wsapp));
             end; // with childNode

             // ... IndirizzoResa
             if body.DatiGenerali.DatiTrasporto.IndirizzoResa.IsAssigned then begin
                currNode:=childNode.AppendChild(Doc.CreateElement(DOMEL_IndirizzoResa));
                // .... Indirizzo
                wsapp:=body.DatiGenerali.DatiTrasporto.IndirizzoResa.Indirizzo;
                if wsapp<>'' then
                   currNode.AppendChild(Doc.CreateElement(DOMEL_Indirizzo)).AppendChild(Doc.CreateTextNode(wsapp));
                // .... NumeroCivico
                wsapp:=body.DatiGenerali.DatiTrasporto.IndirizzoResa.NumeroCivico;
                if wsapp<>'' then
                   currNode.AppendChild(Doc.CreateElement(DOMEL_NumeroCivico)).AppendChild(Doc.CreateTextNode(wsapp));
                // .... CAP
                wsapp:=body.DatiGenerali.DatiTrasporto.IndirizzoResa.CAP;
                if wsapp<>'' then
                   currNode.AppendChild(Doc.CreateElement(DOMEL_CAP)).AppendChild(Doc.CreateTextNode(wsapp));
                // .... Comune
                wsapp:=body.DatiGenerali.DatiTrasporto.IndirizzoResa.Comune;
                if wsapp<>'' then
                   currNode.AppendChild(Doc.CreateElement(DOMEL_Comune)).AppendChild(Doc.CreateTextNode(wsapp));
                // .... Provincia
                wsapp:=body.DatiGenerali.DatiTrasporto.IndirizzoResa.Provincia;
                if wsapp<>'' then
                   currNode.AppendChild(Doc.CreateElement(DOMEL_Provincia)).AppendChild(Doc.CreateTextNode(wsapp));
                // .... Nazione
                wsapp:=body.DatiGenerali.DatiTrasporto.IndirizzoResa.Nazione;
                if wsapp<>'' then
                   currNode.AppendChild(Doc.CreateElement(DOMEL_Nazione)).AppendChild(Doc.CreateTextNode(wsapp));
             end;

             with childNode do begin
                  // ... DataOraConsegna
                  if body.DatiGenerali.DatiTrasporto.DataOraConsegna<>0 then begin
                     wsapp:=eFattura_FormatDateTime(body.DatiGenerali.DatiTrasporto.DataOraConsegna);
                     AppendChild(Doc.CreateElement(DOMEL_DataOraConsegna)).AppendChild(Doc.CreateTextNode(wsapp));
                  end;
             end; // with childNode


          end; // .. DatiTrasporto

          // .. FatturaPrincipale (opzionale)

          // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          // _FatturaElettronicaBody / DatiBeniServizi
          // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          parentNode := Doc.CreateElement(DOMEL_DatiBeniServizi);
          FatturaElettronicaBody.AppendChild(parentNode);

          // .. DettaglioLinee
          for linea in body.DatiBeniServizi.DettaglioLinee do begin;

             childNode := Doc.CreateElement(DOMEL_DettaglioLinee);
             parentNode.AppendChild(childNode);
             with childNode do begin
                // ... NumeroLinea
                wsapp:=WideString(IntToStr(linea.NumeroLinea));
                AppendChild(Doc.CreateElement(DOMEL_NumeroLinea)).AppendChild(Doc.CreateTextNode(wsapp));

                // ... TipoCessionePrestazione
                wsapp:=Trim(linea.TipoCessionePrestazione);
                if wsapp <> '' then
                   AppendChild(Doc.CreateElement(DOMEL_TipoCessionePrestazione)).AppendChild(Doc.CreateTextNode(wsapp));

                // ... Codice Articolo (ripetuto, opzionale)
                if linea.CodiceArticolo.Count > 0 then
                   for iapp := 0 to linea.CodiceArticolo.Count - 1 do begin
                      with AppendChild(Doc.CreateElement(DOMEL_CodiceArticolo)) do begin
                           wsapp:=linea.CodiceArticolo.Items[iapp].CodiceTipo;
                           AppendChild(Doc.CreateElement(DOMEL_CodiceTipo)).AppendChild(Doc.CreateTextNode(wsapp)); // es. 'EAN', 'SSC', 'TARIC', 'CPV', oppure 'Codice Art. fornitore', 'Codice Art. cliente' ...
                           wsapp:=linea.CodiceArticolo.Items[iapp].CodiceValore;
                           AppendChild(Doc.CreateElement(DOMEL_CodiceValore)).AppendChild(Doc.CreateTextNode(wsapp));
                      end;
                   end;

                wsapp:=linea.Descrizione;
                AppendChild(Doc.CreateElement(DOMEL_Descrizione)).AppendChild(Doc.CreateTextNode(wsapp));

                // ... Quantita
                if linea.Quantita<>0 then begin
                   wsapp:=eFattura_FormatQuantita(linea.Quantita);
                   AppendChild(Doc.CreateElement(DOMEL_Quantita)).AppendChild(Doc.CreateTextNode(wsapp)); // []

                   wsapp:=Trim(linea.UnitaMisura);
                   if wsapp <> '' then
                      AppendChild(Doc.CreateElement(DOMEL_UnitaMisura)).AppendChild(Doc.CreateTextNode(wsapp)); // []

                end;
                // AppendChild(Doc.CreateElement('DataInizioPeriodo')).AppendChild(Doc.CreateTextNode('')); // [YYYY-MM-DD]
                // AppendChild(Doc.CreateElement('DataFinePeriodo')).AppendChild(Doc.CreateTextNode('')); // [YYYY-MM-DD]

                // ... PrezzoUnitario
                if (linea.PrezzoUnitario<>0) or linea.LineaDescrittiva then begin
                   if linea.LineaDescrittiva then
                      wsapp:=eFattura_FormatPrezzoUnitario(0)
                   else
                      wsapp:=eFattura_FormatPrezzoUnitario(linea.PrezzoUnitario);
                   AppendChild(Doc.CreateElement(DOMEL_PrezzoUnitario)).AppendChild(Doc.CreateTextNode(wsapp)); // [-]N.DDdddddd
                end;

                // .. DettaglioLinee / ScontoMaggiorazione (opzionale, ripetuto)
                if linea.ScontoMaggiorazione.Count > 0 then begin
                   for scomag in linea.ScontoMaggiorazione do
                      with AppendChild(Doc.CreateElement(DOMEL_ScontoMaggiorazione)) do begin
                           AppendChild(Doc.CreateElement(DOMEL_Tipo)).AppendChild(Doc.CreateTextNode(scomag.Tipo)); // [SC=Sconto,MG=Maggiorazione]
                           if scomag.Percentuale <> 0 then begin
                              wsapp:=eFattura_FormatScontoMagg(scomag.Percentuale);
                              AppendChild(Doc.CreateElement(DOMEL_Percentuale)).AppendChild(Doc.CreateTextNode(wsapp));
                           end;
                           // Percentuale + Importo -> vince importo
                           if scomag.Importo <> 0 then begin
                              wsapp:=eFattura_FormatPrezzoUnitario(scomag.Importo);
                              AppendChild(Doc.CreateElement(DOMEL_Importo)).AppendChild(Doc.CreateTextNode(wsapp));
                           end;
                      end;
                end;

                // with AppendChild(Doc.CreateElement('ScontoMaggiorazione')) do begin
                //      AppendChild(Doc.CreateElement('Tipo')).AppendChild(Doc.CreateTextNode('SC')); // [SC=Sconto,MG=Maggiorazione]
                //      AppendChild(Doc.CreateElement('Percentuale')).AppendChild(Doc.CreateTextNode('5.00'));
                //      // Percentuale XOR Importo
                //      AppendChild(Doc.CreateElement('Importo')).AppendChild(Doc.CreateTextNode('55.00'));
                // end;

                // ... PrezzoTotale
                if (linea.PrezzoTotale<>0) or linea.LineaDescrittiva then begin
                   if linea.LineaDescrittiva then
                      wsapp:=eFattura_FormatPrezzoUnitario(0)
                   else
                      wsapp:=eFattura_FormatPrezzoUnitario(linea.PrezzoTotale);
                   AppendChild(Doc.CreateElement(DOMEL_PrezzoTotale)).AppendChild(Doc.CreateTextNode(wsapp)); // [-]N.DDdddddd
                end;

                // ... AliquotaIva
                if linea.AliquotaIva<>0 then begin
                   wsapp:=eFattura_FormatAliquota(linea.AliquotaIva);
                   AppendChild(Doc.CreateElement(DOMEL_AliquotaIVA)).AppendChild(Doc.CreateTextNode(wsapp)); // 0.00, N.DD
                end;

                // ... Ritenuta
                if linea.Ritenuta<>'' then begin
                   wsapp:=linea.Ritenuta;
                   AppendChild(Doc.CreateElement(DOMEL_Ritenuta)).AppendChild(Doc.CreateTextNode(wsapp)); // ['SI']
                end;

                // ... Natura
                if linea.Natura<>'' then begin
                   wsapp:=linea.Natura;
                   AppendChild(Doc.CreateElement(DOMEL_Natura)).AppendChild(Doc.CreateTextNode(wsapp)); // ['SI']
                end;
                       // N1=escluse ex art.15
                       // N2=non soggette
                       // N3=non imponibili
                       // N4=esenti
                       // N5=regime del margine / IVA non esposta in fattura
                       // N6=inversione contabile (per le operazioni in reverse charge
                       //    ovvero nei casi di autofatturazione per acquisti extra UE
                       //    di servizi ovvero per importazioni di beni nei soli casi
                       //    previsti)
                       // N7=IVA assolta in altro stato UE (vendite a distanza ex art.
                       //    40 commi 3 e 4 e art. 41 comma 1 lett. b, DL 331/93;
                       //    prestazione di servizi di telecomunicazioni, tele-
                       //    radiodiffusione ed elettronici ex art. 7-sexies lett. f, g,
                       //    DPR 633/72 e art. 74-sexies, DPR 633/72)

                // AppendChild(Doc.CreateElement('RiferimentoAmministrazione')).AppendChild(Doc.CreateTextNode('')); // [commessa?]

                // .. DettaglioLinee / AltriDatiGestionali (opzionale, ripetuto)
                if linea.AltriDatiGestionali.Count > 0 then
                   with AppendChild(Doc.CreateElement(DOMEL_AltriDatiGestionali)) do
                        for adg in linea.AltriDatiGestionali do begin
                           // .. / TipoDato
                           wsapp:=Trim(adg.TipoDato);
                           if wsapp <> '' then
                              AppendChild(Doc.CreateElement(DOMEL_TipoDato)).AppendChild(Doc.CreateTextNode(wsapp));
                           // .. / RiferimentoTesto
                           wsapp:=Trim(adg.RiferimentoTesto);
                           if wsapp <> '' then
                              AppendChild(Doc.CreateElement(DOMEL_RiferimentoTesto)).AppendChild(Doc.CreateTextNode(wsapp)); // []
                           // .. // RiferimentoNumero
                           wsapp:=widestring(IntToStr(adg.RiferimentoNumero));
                           if wsapp <> '0' then
                              AppendChild(Doc.CreateElement(DOMEL_RiferimentoNumero)).AppendChild(Doc.CreateTextNode(wsapp)); // []
                           // .. / RiferimentoData
                           if adg.RiferimentoData > EncodeDate(2018, 1, 1) then begin
                              wsapp:=eFattura_FormatDate(adg.RiferimentoData);
                              AppendChild(Doc.CreateElement(DOMEL_RiferimentoData)).AppendChild(Doc.CreateTextNode(wsapp)); // []
                           end;
                        end; // for

             end; // .. DettaglioLinee

          end; // loop DettaglioLinee

          // .. DatiRiepilogo
          for riep in body.DatiBeniServizi.DatiRiepilogo do begin;

             childNode := Doc.CreateElement(DOMEL_DatiRiepilogo);
             parentNode.AppendChild(childNode);
             with childNode do begin
                // ... AliquotaIVA
                wsapp:=eFattura_FormatAliquota(riep.AliquotaIVA);
                AppendChild(Doc.CreateElement(DOMEL_AliquotaIVA)).AppendChild(Doc.CreateTextNode(wsapp));
                // ... Natura
                wsapp:=riep.Natura;
                if wsapp<>'' then
                   AppendChild(Doc.CreateElement(DOMEL_Natura)).AppendChild(Doc.CreateTextNode(wsapp)); // [se dettaglio con "natura"]
                // ... SpeseAccessorie
                if riep.SpeseAccessorie <> 0 then begin
                   wsapp:=eFattura_FormatImporto(riep.SpeseAccessorie);
                   AppendChild(Doc.CreateElement(DOMEL_SpeseAccessorie)).AppendChild(Doc.CreateTextNode(wsapp)); // []
                end;
                // ... Arrotondamento
                if riep.Arrotondamento <> 0 then begin
                   wsapp:=eFattura_FormatImporto(riep.Arrotondamento);
                   AppendChild(Doc.CreateElement(DOMEL_Arrotondamento)).AppendChild(Doc.CreateTextNode(wsapp)); // []
                end;
                // ... ImponibileImporto
                wsapp:=eFattura_FormatImporto(riep.ImponibileImporto);
                AppendChild(Doc.CreateElement(DOMEL_ImponibileImporto)).AppendChild(Doc.CreateTextNode(wsapp));
                // ... Imposta
                wsapp:=eFattura_FormatImporto(riep.Imposta);
                AppendChild(Doc.CreateElement(DOMEL_Imposta)).AppendChild(Doc.CreateTextNode(wsapp));
                // ... EsigibilitaIVA
                wsapp:=Trim(riep.EsigibilitaIVA);
                if (wsapp='I') or (wsapp='D') or (wsapp='S') then begin
                AppendChild(Doc.CreateElement(DOMEL_EsigibilitaIVA)).AppendChild(Doc.CreateTextNode(wsapp)); // [vedi sotto]
                   // “I” per IVA ad esigibilità immediata
                   // “D” per IVA ad esigibilità differita
                   // “S” per scissione dei pagamenti. Se valorizzato con “S”, il campo Natura (2.2.2.2) non può valere “N6”.
                end;
                // ... RiferimentoNormativo
                wsapp:=riep.RiferimentoNormativo;
                if wsapp<>'' then begin
                   AppendChild(Doc.CreateElement(DOMEL_RiferimentoNormativo)).AppendChild(Doc.CreateTextNode(wsapp)); // []
                end;

             end;

          end; // for




          // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          // _FatturaElettronicaBody / DatiVeicoli (opzionale)
          // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          // parentNode := Doc.CreateElement('DatiVeicoli');
          // FatturaElettronicaBody.AppendChild(parentNode);

          // .. DatiVeicoli
          // childNode := Doc.CreateElement('DatiVeicoli');
          // parentNode.AppendChild(childNode);
          // with childNode do begin
          //    AppendChild(Doc.CreateElement('Data')).AppendChild(Doc.CreateTextNode(''));
          //    AppendChild(Doc.CreateElement('TotalePercorso')).AppendChild(Doc.CreateTextNode(''));
          // end; // .. DettaglioLinee

          // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          // _FatturaElettronicaBody / DatiPagamento (opzionale, ripetuto)
          // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          // .. DatiPagamento
          for pag in body.Datipagamento do begin

             parentNode := Doc.CreateElement(DOMEL_DatiPagamento);
             FatturaElettronicaBody.AppendChild(parentNode);

             with parentNode do begin
                // ... CondizioniPagamento
                wsapp:=pag.CondizioniPagamento;
                AppendChild(Doc.CreateElement(DOMEL_CondizioniPagamento)).AppendChild(Doc.CreateTextNode(wsapp)); // TP01=pagamento a rate,TP02=pagamento completo,TP03=anticipo

                // ... DettaglioPagamento (ripetuto)
                for iapp:=0 to pag.DettaglioPagamento_Lista.Count-1 do begin
                   with AppendChild(Doc.CreateElement(DOMEL_DettaglioPagamento)) do begin
                        // .... Beneficiario
                        wsapp:=pag.DettaglioPagamento_Lista[iapp].Beneficiario;
                        if wsapp<>'' then
                           AppendChild(Doc.CreateElement(DOMEL_Beneficiario)).AppendChild(Doc.CreateTextNode(wsapp)); // []
                        // .... ModalitaPagamento
                        wsapp:=pag.DettaglioPagamento_Lista[iapp].ModalitaPagamento;
                        AppendChild(Doc.CreateElement(DOMEL_ModalitaPagamento)).AppendChild(Doc.CreateTextNode(wsapp)); // vedi sotto
                               // MP01=contanti                   MP02=assegno                 MP03=assegno circolare
                               // MP04=contanti presso Tesoreria  MP05=bonifico                MP06=vaglia cambiario
                               // MP07=bollettino bancario        MP08=carta di pagamento      MP09=RID
                               // MP10=RID utenze                 MP11=RID veloce              MP12=Riba
                               // MP13=MAV                        MP14=quietanza erario stato  MP15=giroconto su conti di contabilità speciale
                               // MP16=domiciliazione bancaria    MP17=domiciliazione postale  MP18=bollettino di c/c postale
                               // MP19=SEPA Direct Debit          MP20=SEPA Direct Debit CORE  MP21=SEPA Direct Debit B2B
                               // MP22=Trattenuta su somme già riscosse

                        // AppendChild(Doc.CreateElement('DataRiferimentoTerminiPagamento')).AppendChild(Doc.CreateTextNode('')); // []
                        // AppendChild(Doc.CreateElement('GiorniTerminiPagamento')).AppendChild(Doc.CreateTextNode('')); // []

                        // .... DataScadenzaPagamento
                        if pag.DettaglioPagamento_Lista[iapp].DataScadenzaPagamento <> 0 then begin
                           wsapp:=eFattura_FormatDate(pag.DettaglioPagamento_Lista[iapp].DataScadenzaPagamento);
                           AppendChild(Doc.CreateElement(DOMEL_DataScadenzaPagamento)).AppendChild(Doc.CreateTextNode(wsapp));
                        end;
                        // .... ImportoPagamento
                        wsapp:=eFattura_FormatImporto(pag.DettaglioPagamento_Lista[iapp].ImportoPagamento);
                        AppendChild(Doc.CreateElement(DOMEL_ImportoPagamento)).AppendChild(Doc.CreateTextNode(wsapp));
                        // AppendChild(Doc.CreateElement('CodUfficioPostale')).AppendChild(Doc.CreateTextNode(''));
                        // AppendChild(Doc.CreateElement('CognomeQuietanzante')).AppendChild(Doc.CreateTextNode(''));
                        // AppendChild(Doc.CreateElement('NomeQuietanzante')).AppendChild(Doc.CreateTextNode(''));
                        // AppendChild(Doc.CreateElement('CFQuietanzante')).AppendChild(Doc.CreateTextNode(''));
                        // AppendChild(Doc.CreateElement('TitoloQuietanzante')).AppendChild(Doc.CreateTextNode(''));
                        // AppendChild(Doc.CreateElement('IstitutoFinanziario')).AppendChild(Doc.CreateTextNode(''));

                        wsapp:=Trim(pag.DettaglioPagamento_Lista[iapp].IBAN);
                        if wsapp <> '' then
                           AppendChild(Doc.CreateElement(DOMEL_IBAN)).AppendChild(Doc.CreateTextNode(wsapp));
                        wsapp:=Trim(pag.DettaglioPagamento_Lista[iapp].ABI);
                        if wsapp <> '' then
                           AppendChild(Doc.CreateElement(DOMEL_ABI)).AppendChild(Doc.CreateTextNode(wsapp));
                        wsapp:=Trim(pag.DettaglioPagamento_Lista[iapp].CAB);
                        if wsapp <> '' then
                           AppendChild(Doc.CreateElement(DOMEL_CAB)).AppendChild(Doc.CreateTextNode(wsapp));
                        wsapp:=Trim(pag.DettaglioPagamento_Lista[iapp].BIC);
                        if wsapp <> '' then
                           AppendChild(Doc.CreateElement(DOMEL_BIC)).AppendChild(Doc.CreateTextNode(wsapp));

                        weapp:=pag.DettaglioPagamento_Lista[iapp].ScontoPagamentoAnticipato;
                        // if weapp<>0 then
                        AppendChild(Doc.CreateElement(DOMEL_ScontoPagamentoAnticipato)).AppendChild(Doc.CreateTextNode( eFattura_FormatImporto(weapp) ));

                        weapp:=pag.DettaglioPagamento_Lista[iapp].PenalitaPagamentiRitardati;
                        // if weapp<>0 then
                        AppendChild(Doc.CreateElement(DOMEL_PenalitaPagamentiRitardati)).AppendChild(Doc.CreateTextNode( eFattura_FormatImporto(weapp) ));

                        // AppendChild(Doc.CreateElement('DataLimitePagamentoAnticipato')).AppendChild(Doc.CreateTextNode(''));
                        // AppendChild(Doc.CreateElement('DataDecorrenzaPenale')).AppendChild(Doc.CreateTextNode(''));
                        // AppendChild(Doc.CreateElement('CodicePagamento')).AppendChild(Doc.CreateTextNode(''));
                   end; // with

                end; // for dettaglio
             end; // with parentNode
          end; // .. DatiPagamento (for)

          // .. Allegati
          // childNode := Doc.CreateElement('Allegati');
          // parentNode.AppendChild(childNode);
          // with childNode do begin
          //    // AppendChild(Doc.CreateElement('NomeAttachment')).AppendChild(Doc.CreateTextNode(''));
          //    // AppendChild(Doc.CreateElement('AlgoritmoCompressione')).AppendChild(Doc.CreateTextNode('')); // []
          //    // AppendChild(Doc.CreateElement('FormatoAttachment')).AppendChild(Doc.CreateTextNode('')); // []
          //    // AppendChild(Doc.CreateElement('DescrizioneAttachment')).AppendChild(Doc.CreateTextNode('')); // []
          //    // AppendChild(Doc.CreateElement('Attachment')).AppendChild(Doc.CreateTextNode(''));
          // end; // .. Allegati

       end; // for body
    end; // _FatturaElettronicaBody


begin
   Doc := TXMLDocument.Create;

   Doc.StylesheetType:='text/xsl';
   Doc.StylesheetHRef:='fatturapr_v1.2.xsl';

   // root node - p:FatturaElettronica
   RootNode := Doc.CreateElement('p:FatturaElettronica');
   TDOMElement(RootNode).SetAttribute('versione', self.eFattura.Versione); // 'FPR12'
   TDOMElement(RootNode).SetAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
   TDOMElement(RootNode).SetAttribute('xmlns:ds', 'http://www.w3.org/2000/09/xmldsig#');
   TDOMElement(RootNode).SetAttribute('xmlns:p', 'http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2');
   TDOMElement(RootNode).SetAttribute('xsi:schemaLocation', 'http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2 http://www.fatturapa.gov.it/export/fatturazione/sdi/fatturapa/v1.2/Schema_del_file_xml_FatturaPA_versione_1.2.xsd');
   Doc.Appendchild(RootNode);
   RootNode:= Doc.DocumentElement;

   _FatturaElettronicaHeader(RootNode);

   _FatturaElettronicaBody(RootNode);

   // -----------------------------------
   result:=Doc;
end;

function TEFattXmlWriter.SaveToXml(const AXmlRepository: string;
  const AFileNameXml: string): string;
var doc: TXMLDocument;
    sFile: string;
begin
  doc := getDocument;
  try
    if AFileNameXml = '' then
       sFile:=Format('%s\%s', [AXmlRepository, GetXmlFileName ])
    else
       sFile:=Format('%s\%s', [AXmlRepository, AFileNameXml ]);

    XMLWrite.writeXMLFile(doc, sFile);
  finally
    result:=sFile;
    FreeAndNil(doc);
  end;
end;

end.

