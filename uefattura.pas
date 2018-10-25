unit uefattura;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils
   , fgl // used for generics
   ;

const
  DOMEL_FatturaElettronicaHeader = 'FatturaElettronicaHeader';
  DOMEL_DatiTrasmissione         = 'DatiTrasmissione';
  DOMEL_IdTrasmittente           = 'IdTrasmittente';
  DOMEL_IdPaese                  = 'IdPaese';
  DOMEL_IdCodice                 = 'IdCodice';
  DOMEL_ProgressivoInvio         = 'ProgressivoInvio';
  DOMEL_FormatoTrasmissione      = 'FormatoTrasmissione';
  DOMEL_CodiceDestinatario       = 'CodiceDestinatario';
  DOMEL_PECDestinatario          = 'PECDestinatario';
  DOMEL_ContattiTrasmittente     = 'ContattiTrasmittente';
  DOMEL_Contatti                 = 'Contatti';
  DOMEL_Telefono                 = 'Telefono';
  DOMEL_Fax                      = 'Fax';
  DOMEL_Email                    = 'Email';
  DOMEL_CedentePrestatore        = 'CedentePrestatore';
  DOMEL_DatiAnagrafici           = 'DatiAnagrafici';
  DOMEL_IdFiscaleIVA             = 'IdFiscaleIVA';
  DOMEL_CodiceFiscale            = 'CodiceFiscale';
  DOMEL_Anagrafica               = 'Anagrafica';
  DOMEL_Denominazione            = 'Denominazione';
  DOMEL_Nome                     = 'Nome';
  DOMEL_Cognome                  = 'Cognome';
  DOMEL_RegimeFiscale            = 'RegimeFiscale';
  DOMEL_Indirizzo                = 'Indirizzo';
  DOMEL_NumeroCivico             = 'NumeroCivico';
  DOMEL_CAP                      = 'CAP';
  DOMEL_Comune                   = 'Comune';
  DOMEL_Provincia                = 'Provincia';
  DOMEL_Nazione                  = 'Nazione';
  DOMEL_IscrizioneREA            = 'IscrizioneREA';
  DOMEL_Ufficio                  = 'Ufficio';
  DOMEL_NumeroREA                = 'NumeroREA';
  DOMEL_CapitaleSociale          = 'CapitaleSociale';
  DOMEL_SocioUnico               = 'SocioUnico';
  DOMEL_StatoLiquidazione        = 'StatoLiquidazione';
  DOMEL_CessionarioCommittente   = 'CessionarioCommittente';
  DOMEL_Sede                     = 'Sede';

  DOMEL_FatturaElettronicaBody   = 'FatturaElettronicaBody';
  DOMEL_DatiGenerali             = 'DatiGenerali';
  DOMEL_DatiGeneraliDocumento    = 'DatiGeneraliDocumento';
  DOMEL_TipoDocumento            = 'TipoDocumento';
  DOMEL_Divisa                   = 'Divisa';
  DOMEL_Data                     = 'Data';
  DOMEL_Numero                   = 'Numero';

  DOMEL_ImportoTotaleDocumento   = 'ImportoTotaleDocumento';
  DOMEL_Arrotondamento           = 'Arrotondamento';
  DOMEL_Causale                  = 'Causale';
  DOMEL_Art73                    = 'Art73';
  DOMEL_DatiOrdineAcquisto       = 'DatiOrdineAcquisto';
  DOMEL_RiferimentoNumeroLinea   = 'RiferimentoNumeroLinea';
  DOMEL_IdDocumento              = 'IdDocumento';
  DOMEL_NumItem                  = 'NumItem';
  DOMEL_CodiceCommessaConvenzione = 'CodiceCommessaConvenzione';
  DOMEL_CodiceCUP                = 'CodiceCUP';
  DOMEL_CodiceCIG                = 'CodiceCIG';
  DOMEL_DatiDDT                  = 'DatiDDT';
  DOMEL_NumeroDDT                = 'NumeroDDT';
  DOMEL_DataDDT                  = 'DataDDT';
  DOMEL_DatiTrasporto            = 'DatiTrasporto';
  DOMEL_DatiAnagraficiVettore    = 'DatiAnagraficiVettore';
  DOMEL_MezzoTrasporto           = 'MezzoTrasporto';
  DOMEL_CausaleTrasporto         = 'CausaleTrasporto';
  DOMEL_NumeroColli              = 'NumeroColli';
  DOMEL_Descrizione              = 'Descrizione';
  DOMEL_UnitaMisuraPeso          = 'UnitaMisuraPeso';
  DOMEL_PesoLordo                = 'PesoLordo';
  DOMEL_PesoNetto                = 'PesoNetto';
  DOMEL_DataOraRitiro            = 'DataOraRitiro';
  DOMEL_DataInizioTrasporto      = 'DataInizioTrasporto';
  DOMEL_TipoResa                 = 'TipoResa';
  DOMEL_IndirizzoResa            = 'IndirizzoResa';
  DOMEL_DataOraConsegna          = 'DataOraConsegna';
  DOMEL_DatiBeniServizi          = 'DatiBeniServizi';
  DOMEL_DettaglioLinee           = 'DettaglioLinee';
  DOMEL_NumeroLinea              = 'NumeroLinea';
  DOMEL_TipoCessionePrestazione  = 'TipoCessionePrestazione';
  DOMEL_CodiceArticolo           = 'CodiceArticolo';
  DOMEL_CodiceTipo               = 'CodiceTipo';
  DOMEL_CodiceValore             = 'CodiceValore';
  DOMEL_Quantita                 = 'Quantita';
  DOMEL_UnitaMisura              = 'UnitaMisura';
  DOMEL_PrezzoUnitario           = 'PrezzoUnitario';
  DOMEL_ScontoMaggiorazione      = 'ScontoMaggiorazione';
  DOMEL_Tipo                     = 'Tipo';
  DOMEL_Percentuale              = 'Percentuale';
  DOMEL_Importo                  = 'Importo';
  DOMEL_PrezzoTotale             = 'PrezzoTotale';
  DOMEL_AliquotaIVA              = 'AliquotaIVA';
  DOMEL_Ritenuta                 = 'Ritenuta';
  DOMEL_Natura                   = 'Natura';
  DOMEL_DatiRiepilogo            = 'DatiRiepilogo';
  DOMEL_SpeseAccessorie          = 'SpeseAccessorie';
  DOMEL_ImponibileImporto        = 'ImponibileImporto';
  DOMEL_Imposta                  = 'Imposta';
  DOMEL_EsigibilitaIVA           = 'EsigibilitaIVA';
  DOMEL_RiferimentoNormativo     = 'RiferimentoNormativo';

  DOMEL_AltriDatiGestionali      = 'AltriDatiGestionali';
  DOMEL_TipoDato                 = 'TipoDato';
  DOMEL_RiferimentoTesto         = 'RiferimentoTesto';
  DOMEL_RiferimentoNumero        = 'RiferimentoNumero';
  DOMEL_RiferimentoData          = 'RiferimentoData';


  DOMEL_DatiPagamento            = 'DatiPagamento';
  DOMEL_CondizioniPagamento      = 'CondizioniPagamento';
  DOMEL_DettaglioPagamento       = 'DettaglioPagamento';
  DOMEL_Beneficiario             = 'Beneficiario';
  DOMEL_ModalitaPagamento        = 'ModalitaPagamento';
  DOMEL_DataScadenzaPagamento    = 'DataScadenzaPagamento';
  DOMEL_ImportoPagamento         = 'ImportoPagamento';
  DOMEL_IBAN                     = 'IBAN';
  DOMEL_ABI                      = 'ABI';
  DOMEL_CAB                      = 'CAB';
  DOMEL_BIC                      = 'BIC';
  DOMEL_ScontoPagamentoAnticipato = 'ScontoPagamentoAnticipato';
  DOMEL_PenalitaPagamentiRitardati = 'PenalitaPagamentiRitardati';





type

   { TEFatturaHeader_Generico_Contatti }

   TEFatturaHeader_Generico_Contatti = class(TPersistent)
   private
      Femail: WideString;
      FFax: WideString;
      FTelefono: WideString;
      function GetAssigned: boolean;
   public
      property IsAssigned: boolean read GetAssigned;

   public
      constructor Create;

      property Telefono: WideString read FTelefono write FTelefono;
      property Fax: WideString read FFax write FFax;
      property email: WideString read Femail write Femail;
   end;

   { TEFatturaHeader_Generico_Anagrafica }

   TEFatturaHeader_Generico_Anagrafica = class(TPersistent)
   private
      FCodEORI: WideString;
      FCognome: WideString;
      FDenominazione: WideString;
      FNome: WideString;
      FTitolo: WideString;
      function GetIsAssigned: boolean;
   public
      property IsAssigned: boolean read GetIsAssigned;
   public
      constructor Create;
      // destructor Destroy; override;

      property Denominazione: WideString read FDenominazione write FDenominazione;
      property Nome: WideString read FNome write FNome;
      property Cognome: WideString read FCognome write FCognome;
      property Titolo: WideString read FTitolo write FTitolo;
      property CodEORI: WideString read FCodEORI write FCodEORI;
   end;

   { TEFatturaHeader_Generico_Sede }

   TEFatturaHeader_Generico_Sede = class(TPersistent)
   private
      FCAP: WideString;
      FComune: WideString;
      FIndirizzo: WideString;
      FNazione: WideString;
      FNumeroCivico: WideString;
      FProvincia: WideString;
      function GetIsAssigned: boolean;
   public
      property IsAssigned: boolean read GetIsAssigned;
   public
      constructor Create;
      // destructor Destroy; override;

      property Indirizzo: WideString read FIndirizzo write FIndirizzo;
      property NumeroCivico: WideString read FNumeroCivico write FNumeroCivico;
      property CAP: WideString read FCAP write FCAP;
      property Comune: WideString read FComune write FComune;
      property Provincia: WideString read FProvincia write FProvincia;
      property Nazione: WideString read FNazione write FNazione;
   end;

   { TEFatturaHeader_Generico_IdFiscaleIVA }

   TEFatturaHeader_Generico_IdFiscaleIVA = class(TPersistent)
   private
      FIdCodice: WideString;
      FIdPaese: WideString;
      function GetAssigned: boolean;
   public
      property IsAssigned: boolean read GetAssigned;
   public
      constructor Create;

      property IdPaese: WideString read FIdPaese write FIdPaese;
      property IdCodice: WideString read FIdCodice write FIdCodice;
   end;

   { TEFatturaBody_Generico_ScontoMaggiorazione }
   TEFatturaBody_Generico_ScontoMaggiorazione = class(TPersistent)
   private
      FImporto: extended;
      FPercentuale: extended;
      FTipo: WideString;
   public
      constructor Create;

      property Tipo: WideString read FTipo write FTipo;
      property Percentuale: extended read FPercentuale write FPercentuale;
      property Importo: extended read FImporto write FImporto;
   end;

   { TEFatturaBody_Generico_ScontoMaggiorazione_Lista }
   TEFatturaBody_Generico_ScontoMaggiorazione_Lista = specialize TFPGObjectList<TEFatturaBody_Generico_ScontoMaggiorazione>;

   // DatiTrasmissione

   { TEFatturaHeader_DatiTrasmissione }

   TEFatturaHeader_DatiTrasmissione = class(TPersistent)
   private
      FCodiceDestinatario: WideString;
      FContattiTrasmittente: TEFatturaHeader_Generico_Contatti;
      FFormatoTrasmissione: WideString;
      FIdTrasmittente: TEFatturaHeader_Generico_IdFiscaleIVA;
      FPecDestinatario: WideString;
      FProgressivoInvio: WideString;
   public
      constructor Create;
      destructor Destroy; override;

      property IdTrasmittente: TEFatturaHeader_Generico_IdFiscaleIVA read FIdTrasmittente write FIdTrasmittente;
      property ProgressivoInvio: WideString read FProgressivoInvio write FProgressivoInvio;
      property FormatoTrasmissione: WideString read FFormatoTrasmissione write FFormatoTrasmissione;
      property CodiceDestinatario: WideString read FCodiceDestinatario write FCodiceDestinatario;
      property ContattiTrasmittente: TEFatturaHeader_Generico_Contatti read FContattiTrasmittente write FContattiTrasmittente;
      property PecDestinatario: WideString read FPecDestinatario write FPecDestinatario;
   end;

   // CedentePrestatore

   { TEFatturaHeader_CedentePrestatore_DatiAnagrafici }

   TEFatturaHeader_CedentePrestatore_DatiAnagrafici = class(TPersistent)
   private
      FAnagrafica: TEFatturaHeader_Generico_Anagrafica;
      FCodiceFiscale: WideString;
      FIdFiscaleIVA: TEFatturaHeader_Generico_IdFiscaleIVA;
      FRegimeFiscale: WideString;
   public
      constructor Create;
      destructor Destroy; override;

      property IdFiscaleIVA: TEFatturaHeader_Generico_IdFiscaleIVA read FIdFiscaleIVA write FIdFiscaleIVA;
      property CodiceFiscale: WideString read FCodiceFiscale write FCodiceFiscale;
      property Anagrafica: TEFatturaHeader_Generico_Anagrafica read FAnagrafica write FAnagrafica;
      property RegimeFiscale: WideString read FRegimeFiscale write FRegimeFiscale;
   end;

   { TEFatturaHeader_CedentePrestatore_IscrizioneREA }

   TEFatturaHeader_CedentePrestatore_IscrizioneREA = class(TPersistent)
   private
      FCapitaleSociale: WideString;
      FNumeroREA: WideString;
      FSocioUnico: WideString;
      FStatoLiquidazione: WideString;
      FUfficio: WideString;
   public
      constructor Create;
      // destructor Destroy; override;

      property Ufficio: WideString read FUfficio write FUfficio;
      property NumeroREA: WideString read FNumeroREA write FNumeroREA;
      property CapitaleSociale: WideString read FCapitaleSociale write FCapitaleSociale;
      property SocioUnico: WideString read FSocioUnico write FSocioUnico;
      property StatoLiquidazione: WideString read FStatoLiquidazione write FStatoLiquidazione;
   end;

   TEFatturaHeader_CedentePrestatore = class(TPersistent)
   private
      FContatti: TEFatturaHeader_Generico_Contatti;
      FDatiAnagrafici: TEFatturaHeader_CedentePrestatore_DatiAnagrafici;
      FIscrizioneREA: TEFatturaHeader_CedentePrestatore_IscrizioneREA;
      FRiferimentoAmministrazione: WideString;
      FSede: TEFatturaHeader_Generico_Sede;
      FStabileOrganizzazione: TEFatturaHeader_Generico_Sede;
   public
      constructor Create;
      destructor Destroy; override;

      property RiferimentoAmministrazione: WideString read FRiferimentoAmministrazione write FRiferimentoAmministrazione;
      property DatiAnagrafici: TEFatturaHeader_CedentePrestatore_DatiAnagrafici read FDatiAnagrafici write FDatiAnagrafici;
      property Sede: TEFatturaHeader_Generico_Sede read FSede write FSede;
      property StabileOrganizzazione: TEFatturaHeader_Generico_Sede read FStabileOrganizzazione write FStabileOrganizzazione;
      property IscrizioneREA: TEFatturaHeader_CedentePrestatore_IscrizioneREA read FIscrizioneREA write FIscrizioneREA;
      property Contatti: TEFatturaHeader_Generico_Contatti read FContatti write FContatti;
   end;

   // RappresentanteFiscale

   { TEFatturaHeader_RappresentanteFiscale_DatiAnagrafici }

   TEFatturaHeader_RappresentanteFiscale_DatiAnagrafici = class(TPersistent)
   private
      FAnagrafica: TEFatturaHeader_Generico_Anagrafica;
      FCodiceFiscale: WideString;
      FIdFiscaleIVA: TEFatturaHeader_Generico_IdFiscaleIVA;
      FRegimeFiscale: WideString;
   public
      constructor Create;
      destructor Destroy; override;

      property RegimeFiscale: WideString read FRegimeFiscale write FRegimeFiscale;
      property CodiceFiscale: WideString read FCodiceFiscale write FCodiceFiscale;
      property IdFiscaleIVA: TEFatturaHeader_Generico_IdFiscaleIVA read FIdFiscaleIVA write FIdFiscaleIVA;
      property Anagrafica: TEFatturaHeader_Generico_Anagrafica read FAnagrafica write FAnagrafica;
   end;

   TEFatturaHeader_RappresentanteFiscale = class(TPersistent)
   private
      FDatiAnagrafici: TEFatturaHeader_RappresentanteFiscale_DatiAnagrafici;
   public
      constructor Create;
      destructor Destroy; override;

      property DatiAnagrafici: TEFatturaHeader_RappresentanteFiscale_DatiAnagrafici read FDatiAnagrafici write FDatiAnagrafici;
   end;

   // CessionarioCommittente

   { TEFatturaHeader_CessionarioCommittente_DatiAnagrafici }

   TEFatturaHeader_CessionarioCommittente_DatiAnagrafici = class(TPersistent)
   private
      FAnagrafica: TEFatturaHeader_Generico_Anagrafica;
      FCodiceFiscale: WideString;
      FIdFiscaleIVA: TEFatturaHeader_Generico_IdFiscaleIVA;
   public
      constructor Create;
      destructor Destroy; override;

      property IdFiscaleIVA: TEFatturaHeader_Generico_IdFiscaleIVA read FIdFiscaleIVA write FIdFiscaleIVA;
      property CodiceFiscale: WideString read FCodiceFiscale write FCodiceFiscale;
      property Anagrafica: TEFatturaHeader_Generico_Anagrafica read FAnagrafica write FAnagrafica;
   end;

   { TEFatturaHeader_CessionarioCommittente_RappresentanteFiscale }

   TEFatturaHeader_CessionarioCommittente_RappresentanteFiscale = class(TPersistent)
   private
      FCognome: WideString;
      FDenominazione: WideString;
      FIdFiscaleIVA: TEFatturaHeader_Generico_IdFiscaleIVA;
      FNome: WideString;
   public
      constructor Create;
      destructor Destroy; override;

      property IdFiscaleIVA: TEFatturaHeader_Generico_IdFiscaleIVA read FIdFiscaleIVA write FIdFiscaleIVA;
      property Denominazione: WideString read FDenominazione write FDenominazione;
      property Nome: WideString read FNome write FNome;
      property Cognome: WideString read FCognome write FCognome;
   end;

   TEFatturaHeader_CessionarioCommittente = class(TPersistent)
   private
      FDatiAnagrafici: TEFatturaHeader_CessionarioCommittente_DatiAnagrafici;
      FRappresentanteFiscale: TEFatturaHeader_CessionarioCommittente_RappresentanteFiscale;
      FSede: TEFatturaHeader_Generico_Sede;
      FStabileOrganizzazione: TEFatturaHeader_Generico_Sede;
   public
      constructor Create;
      destructor Destroy; override;

      property DatiAnagrafici: TEFatturaHeader_CessionarioCommittente_DatiAnagrafici read FDatiAnagrafici write FDatiAnagrafici;
      property Sede: TEFatturaHeader_Generico_Sede read FSede write FSede;
      property StabileOrganizzazione: TEFatturaHeader_Generico_Sede read FStabileOrganizzazione write FStabileOrganizzazione;
      property RappresentanteFiscale: TEFatturaHeader_CessionarioCommittente_RappresentanteFiscale read FRappresentanteFiscale write FRappresentanteFiscale;
   end;

   // TerzoIntermediarioOSoggettoEmittente

   { TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente_DatiAnagrafici }

   TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente_DatiAnagrafici = class(TPersistent)
   private
      FAnagrafica: TEFatturaHeader_Generico_Anagrafica;
      FCodiceFiscale: WideString;
      FIdFiscaleIVA: TEFatturaHeader_Generico_IdFiscaleIVA;
   public
      constructor Create;
      destructor Destroy; override;

      property IdFiscaleIVA: TEFatturaHeader_Generico_IdFiscaleIVA read FIdFiscaleIVA write FIdFiscaleIVA;
      property CodiceFiscale: WideString read FCodiceFiscale write FCodiceFiscale;
      property Anagrafica: TEFatturaHeader_Generico_Anagrafica read FAnagrafica write FAnagrafica;
   end;

   TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente = class(TPersistent)
   private
      FDatiAnagrafici: TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente_DatiAnagrafici;
   public
      constructor Create;
      destructor Destroy; override;

      property DatiAnagrafici: TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente_DatiAnagrafici read FDatiAnagrafici write FDatiAnagrafici;
   end;

   // TEFatturaHeader

   TEFatturaHeader = class(TPersistent)
   private
      FDatiTrasmissione: TEFatturaHeader_DatiTrasmissione;
      FCedentePrestatore: TEFatturaHeader_CedentePrestatore;
      FCessionarioCommittente: TEFatturaHeader_CessionarioCommittente;
      FTerzoIntermediarioOSoggettoEmittente: TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente;
      FSoggettoEmittente: widestring;
   public
      constructor Create;
      destructor Destroy; override;

      property DatiTrasmissione: TEFatturaHeader_DatiTrasmissione read FDatiTrasmissione write FDatiTrasmissione;
      property CedentePrestatore: TEFatturaHeader_CedentePrestatore read FCedentePrestatore write FCedentePrestatore;
      property CessionarioCommittente: TEFatturaHeader_CessionarioCommittente read FCessionarioCommittente write FCessionarioCommittente;
      property TerzoIntermediarioOSoggettoEmittente: TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente read FTerzoIntermediarioOSoggettoEmittente write FTerzoIntermediarioOSoggettoEmittente;
      property SoggettoEmittente: widestring read FSoggettoEmittente write FSoggettoEmittente;
   end;

   // ---------------------------------------------------------------------
   // TEFatturaBody
   // ---------------------------------------------------------------------

   { TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiRitenuta }

   TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiRitenuta = class(TPersistent)
   private
      FAliquotaRitenuta: extended;
      FCausalePagamento: WideString;
      FImportoRitenuta: extended;
      FTipoRitenuta: WideString;
   public
      constructor Create;
      // destructor Destroy; override;

      property TipoRitenuta: WideString read FTipoRitenuta write FTipoRitenuta;
      property ImportoRitenuta: extended read FImportoRitenuta write FImportoRitenuta;
      property AliquotaRitenuta: extended read FAliquotaRitenuta write FAliquotaRitenuta;
      property CausalePagamento: WideString read FCausalePagamento write FCausalePagamento;
   end;

   { TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiBollo }

   TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiBollo = class(TPersistent)
   private
      FBolloVirtuale: WideString;
      FImportoBollo: extended;
   public
      constructor Create;
      // destructor Destroy; override;

      property BolloVirtuale: WideString read FBolloVirtuale write FBolloVirtuale;
      property ImportoBollo: extended read FImportoBollo write FImportoBollo;
   end;

   { TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiCassaPrevidenziale }
   TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiCassaPrevidenziale = class(TPersistent)
   public
   end;

   // TEFatturaBody_DatiGeneraliDocumento

   TEFatturaBody_DatiGenerali_DatiGeneraliDocumento = class(TPersistent)
   private
      FData: TDate;
      FDatiBollo: TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiBollo;
      FDatiCassaPrevidenziale: TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiCassaPrevidenziale;
      FDatiRitenuta: TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiRitenuta;
      FDivisa: WideString;
      FImportoTotaleDocumentoAZero: boolean;
      FNumero: WideString;
      FTipoDocumento: WideString;
      FImportoTotaleDocumento: extended;
      FArrotondamento: extended;
      FCausale: TStringList;
      FArt73: WideString;
      function GetImportoTotaleDocumentoIsAssigned: boolean;
   public
      ScontoMaggiorazione_Lista: TEFatturaBody_Generico_ScontoMaggiorazione_Lista;

      property ImportoTotaleDocumentoIsAssegned: boolean read GetImportoTotaleDocumentoIsAssigned;

      property ImportoTotaleDocumentoAZero: boolean read FImportoTotaleDocumentoAZero write FImportoTotaleDocumentoAZero;
   public
      constructor Create;
      destructor Destroy; override;

      property TipoDocumento: WideString read FTipoDocumento write FTipoDocumento;
      property Divisa: WideString read FDivisa write FDivisa;
      property Data: TDate read FData write FData;
      property Numero: WideString read FNumero write FNumero;
      property DatiRitenuta: TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiRitenuta read FDatiRitenuta write FDatiRitenuta;
      property DatiBollo: TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiBollo read FDatiBollo write FDatiBollo;
      property DatiCassaPrevidenziale: TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiCassaPrevidenziale read FDatiCassaPrevidenziale write FDatiCassaPrevidenziale;
      property ImportoTotaleDocumento: extended read FImportoTotaleDocumento write FImportoTotaleDocumento;
      property Arrotondamento: extended read FArrotondamento write FArrotondamento;
      property Causale: TStringList read FCausale write FCausale;
      property Art73: WideString read FArt73 write FArt73;
   end;

   // TEFatturaBody_DatiOrdineAcquisto

   { TEFatturaBody_DatiGenerali_DatiOrdineAcquisto }

   TEFatturaBody_DatiGenerali_DatiOrdineAcquisto = class(TPersistent)
   private
      FCodiceCIG: WideString;
      FCodiceCommessaConvenzione: WideString;
      FCodiceCUP: WideString;
      FData: TDate;
      FIdDocumento: WideString;
      FNumItem: WideString;
      FRiferimentoNumeroLinea: TStringList;
      function GetAssigned: boolean;
   public
      constructor Create;
      destructor Destroy; override;

      property IsAssigned: boolean read GetAssigned;

      property RiferimentoNumeroLinea: TStringList read FRiferimentoNumeroLinea write FRiferimentoNumeroLinea;
      property IdDocumento: WideString read FIdDocumento write FIdDocumento;
      property Data: TDate read FData write FData;
      property NumItem: WideString read FNumItem write FNumItem;
      property CodiceCommessaConvenzione: WideString read FCodiceCommessaConvenzione write FCodiceCommessaConvenzione;
      property CodiceCUP: WideString read FCodiceCUP write FCodiceCUP;
      property CodiceCIG: WideString read FCodiceCIG write FCodiceCIG;
   end;

   { TEFatturaBody_DatiGenerali_DatiOrdineAcquisto_Lista }
   TEFatturaBody_DatiGenerali_DatiOrdineAcquisto_Lista = specialize TFPGObjectList<TEFatturaBody_DatiGenerali_DatiOrdineAcquisto>;

   // TEFatturaBody_DatiGenerali_DatiContratto (opzionale, ripetuto)
   // TEFatturaBody_DatiGenerali_DatiConvenzione (opzionale, ripetuto)
   // TEFatturaBody_DatiGenerali_DatiRicezione (opzionale, ripetuto)
   // TEFatturaBody_DatiGenerali_DatiFattureCollegate (opzionale, ripetuto)
   // TEFatturaBody_DatiGenerali_DatiSAL (opzionale)

   // TEFatturaBody_DatiGenerali_DatiDDT

   TEFatturaBody_DatiGenerali_DatiDDT = class(TPersistent)
   private
      FDataDDT: TDate;
      FNumeroDDT: WideString;
      FRiferimentoNumeroLinea: TStringList;
   public
      constructor Create;
      destructor Destroy; override;

      property NumeroDDT: WideString read FNumeroDDT write FNumeroDDT;
      property DataDDT: TDate read FDataDDT write FDataDDT;
      property RiferimentoNumeroLinea: TStringList read FRiferimentoNumeroLinea write FRiferimentoNumeroLinea;
   end;

   { TEFatturaBody_DatiGenerali_DatiDDT }
   TEFatturaBody_DatiGenerali_DatiDDT_Lista = specialize TFPGObjectList<TEFatturaBody_DatiGenerali_DatiDDT>;

   { TEFatturaBody_DatiGenerali_DatiTrasporto_DatiAnagraficiVettore }

   TEFatturaBody_DatiGenerali_DatiTrasporto_DatiAnagraficiVettore = class(TPersistent)
   private
      FAnagrafica: TEFatturaHeader_Generico_Anagrafica;
      FCodiceFiscale: WideString;
      FIdFiscaleIVA: TEFatturaHeader_Generico_IdFiscaleIVA;
      FNumeroLicenzaGuida: WideString;
      function GetIsAssigned: boolean;
   public
      property IsAssigned: boolean read GetIsAssigned;
   public
      constructor Create;
      destructor Destroy; override;

      property IdFiscaleIVA: TEFatturaHeader_Generico_IdFiscaleIVA read FIdFiscaleIVA write FIdFiscaleIVA;
      property CodiceFiscale: WideString read FCodiceFiscale write FCodiceFiscale;
      property Anagrafica: TEFatturaHeader_Generico_Anagrafica read FAnagrafica write FAnagrafica;
      property NumeroLicenzaGuida: WideString read FNumeroLicenzaGuida write FNumeroLicenzaGuida;
   end;

   { TEFatturaBody_DatiGenerali_DatiTrasporto }
   TEFatturaBody_DatiGenerali_DatiTrasporto = class(TPersistent)
   private
      FCausaleTrasporto: WideString;
      FDataInizioTrasporto: TDateTime;
      FDataOraConsegna: tdatetime;
      FDataOraRitiro: TDateTime;
      FDatiAnagraficiVettore: TEFatturaBody_DatiGenerali_DatiTrasporto_DatiAnagraficiVettore;
      FDescrizione: WideString;
      FIndirizzoResa: TEFatturaHeader_Generico_Sede;
      FMezzoTrasporto: WideString;
      FNumeroColli: integer;
      FPesoLordo: extended;
      FPesoNetto: extended;
      FTipoResa: WideString;
      FUnitaMisuraPeso: WideString;
      function GetIsAssigned: boolean;
   public
      property IsAssigned: boolean read GetIsAssigned;
   public
      constructor Create;
      destructor Destroy; override;

      property DatiAnagraficiVettore: TEFatturaBody_DatiGenerali_DatiTrasporto_DatiAnagraficiVettore read FDatiAnagraficiVettore write FDatiAnagraficiVettore;
      property MezzoTrasporto: WideString read FMezzoTrasporto write FMezzoTrasporto;
      property CausaleTrasporto: WideString read FCausaleTrasporto write FCausaleTrasporto;
      property NumeroColli: integer read FNumeroColli write FNumeroColli;
      property Descrizione: WideString read FDescrizione write FDescrizione;
      property UnitaMisuraPeso: WideString read FUnitaMisuraPeso write FUnitaMisuraPeso;
      property PesoLordo: extended read FPesoLordo write FPesoLordo;
      property PesoNetto: extended read FPesoNetto write FPesoNetto;
      property DataOraRitiro: TDateTime read FDataOraRitiro write FDataOraRitiro;
      property DataInizioTrasporto: TDate read FDataInizioTrasporto write FDataInizioTrasporto;
      property TipoResa: WideString read FTipoResa write FTipoResa;
      property IndirizzoResa: TEFatturaHeader_Generico_Sede read FIndirizzoResa write FIndirizzoResa;
      property DataOraConsegna: TDateTime read FDataOraConsegna write FDataOraConsegna;
   end;


   // TEFatturaBody_DatiGenerali

   TEFatturaBody_DatiGenerali = class(TPersistent)
   private
      FDatiGeneraliDocumento: TEFatturaBody_DatiGenerali_DatiGeneraliDocumento;
      FDatiTrasporto: TEFatturaBody_DatiGenerali_DatiTrasporto;
   public
      DatiOrdineAcquisto_Lista: TEFatturaBody_DatiGenerali_DatiOrdineAcquisto_Lista;
      DatiDDT_Lista: TEFatturaBody_DatiGenerali_DatiDDT_Lista;
   public
      constructor Create;
      destructor Destroy; override;

      property DatiGeneraliDocumento: TEFatturaBody_DatiGenerali_DatiGeneraliDocumento read FDatiGeneraliDocumento write FDatiGeneraliDocumento;
      // TEFatturaBody_DatiGenerali_DatiContratto (opzionale, ripetuto)
      // TEFatturaBody_DatiGenerali_DatiConvenzione (opzionale, ripetuto)
      // TEFatturaBody_DatiGenerali_DatiRicezione (opzionale, ripetuto)
      // TEFatturaBody_DatiGenerali_DatiFattureCollegate (opzionale, ripetuto)
      // TEFatturaBody_DatiGenerali_DatiSAL (opzionale)
      property DatiTrasporto: TEFatturaBody_DatiGenerali_DatiTrasporto read FDatiTrasporto write FDatiTrasporto;
   end;

   // TEFatturaBody_DatiBeniServizi_DettaglioLinee_CodiceArticolo
   TEFatturaBody_DatiBeniServizi_DettaglioLinee_CodiceArticolo = class(TPersistent)
   private
      FCodiceTipo: WideString;
      FCodiceValore: WideString;
   public
      constructor Create;

      property CodiceTipo: WideString read FCodiceTipo write FCodiceTipo;
      property CodiceValore: WideString read FCodiceValore write FCodiceValore;
   end;

   { TEFatturaBody_DatiBeniServizi_DettaglioLinee_CodiceArticolo_Lista }
   TEFatturaBody_DatiBeniServizi_DettaglioLinee_CodiceArticolo_Lista = specialize TFPGObjectList<TEFatturaBody_DatiBeniServizi_DettaglioLinee_CodiceArticolo>;

   // TEFatturaBody_DatiBeniServizi_DettaglioLinee_AltriDatiGestionali
   TEFatturaBody_DatiBeniServizi_DettaglioLinee_AltriDatiGestionali = class(TPersistent)
   private
      FRiferimentoData: TDate;
      FRiferimentoNumero: integer;
      FRiferimentoTesto: WideString;
      FTipoDato: WideString;
   public
      constructor Create;

      property TipoDato: WideString read FTipoDato write FTipoDato;
      property RiferimentoTesto: WideString read FRiferimentoTesto write FRiferimentoTesto;
      property RiferimentoNumero: integer read FRiferimentoNumero write FRiferimentoNumero;
      property RiferimentoData: TDate read FRiferimentoData write FRiferimentoData;
   end;

   { TEFatturaBody_DatiBeniServizi_DettaglioLinee_AltriDatiGestionali_Lista }
   TEFatturaBody_DatiBeniServizi_DettaglioLinee_AltriDatiGestionali_Lista = specialize TFPGObjectList<TEFatturaBody_DatiBeniServizi_DettaglioLinee_AltriDatiGestionali>;


   // TEFatturaBody_DatiBeniServizi_DettaglioLinee

   TEFatturaBody_DatiBeniServizi_DettaglioLinee = class(TPersistent)
   private
      FAliquotaIVA: extended;
      FDataFinePeriodo: TDate;
      FDataInizioPeriodo: TDate;
      FDescrizione: WideString;
      FLineaDescrittiva: boolean;
      FNatura: WideString;
      FNumeroLinea: integer;
      FPrezzoTotale: extended;
      FPrezzoUnitario: extended;
      FQuantita: extended;
      FRiferimentoAmministrazione: WideString;
      FRitenuta: WideString;
      FTipoCessionePrestazione: WideString;
      FUnitaMisura: WideString;
   public
      CodiceArticolo: TEFatturaBody_DatiBeniServizi_DettaglioLinee_CodiceArticolo_Lista;
      ScontoMaggiorazione: TEFatturaBody_Generico_ScontoMaggiorazione_Lista;
      AltriDatiGestionali: TEFatturaBody_DatiBeniServizi_DettaglioLinee_AltriDatiGestionali_Lista;

      property LineaDescrittiva: boolean read FLineaDescrittiva write FLineaDescrittiva;
   public
      constructor Create;
      destructor Destroy; override;

      property NumeroLinea: integer read FNumeroLinea write FNumeroLinea;
      property TipoCessionePrestazione: WideString read FTipoCessionePrestazione write FTipoCessionePrestazione;
      // property CodiceArticolo
      property Descrizione: WideString read FDescrizione write FDescrizione;
      property Quantita: extended read FQuantita write FQuantita;
      property UnitaMisura: WideString read FUnitaMisura write FUnitaMisura;
      property DataInizioPeriodo: TDate read FDataInizioPeriodo write FDataInizioPeriodo;
      property DataFinePeriodo: TDate read FDataFinePeriodo write FDataFinePeriodo;
      property PrezzoUnitario: extended read FPrezzoUnitario write FPrezzoUnitario;
      // property ScontoMaggiorazione
      property PrezzoTotale: extended read FPrezzoTotale write FPrezzoTotale;
      property AliquotaIVA: extended read FAliquotaIVA write FAliquotaIVA;
      property Ritenuta: WideString read FRitenuta write FRitenuta;
      property Natura: WideString read FNatura write FNatura;
      property RiferimentoAmministrazione: WideString read FRiferimentoAmministrazione write FRiferimentoAmministrazione;
      // property AltriDatiGestionali
   end;


   { TEFatturaBody_DatiBeniServizi_DettaglioLinee_Lista }
   TEFatturaBody_DatiBeniServizi_DettaglioLinee_Lista = specialize TFPGObjectList<TEFatturaBody_DatiBeniServizi_DettaglioLinee>;

   // TEFatturaBody_DatiBeniServizi_DatiRiepilogo

   TEFatturaBody_DatiBeniServizi_DatiRiepilogo = class(TPersistent)
   private
      FAliquotaIVA: extended;
      FArrotondamento: extended;
      FEsigibilitaIVA: WideString;
      FImponibileImporto: extended;
      FImposta: extended;
      FNatura: WideString;
      FRiferimentoNormativo: WideString;
      FSpeseAccessorie: extended;
   public
      constructor Create;
      // destructor Destroy; override;

      property AliquotaIVA: extended read FAliquotaIVA write FAliquotaIVA;
      property Natura: WideString read FNatura write FNatura;
      property SpeseAccessorie: extended read FSpeseAccessorie write FSpeseAccessorie;
      property Arrotondamento: extended read FArrotondamento write FArrotondamento;
      property ImponibileImporto: extended read FImponibileImporto write FImponibileImporto;
      property Imposta: extended read FImposta write FImposta;
      property EsigibilitaIVA: WideString read FEsigibilitaIVA write FEsigibilitaIVA;
      property RiferimentoNormativo: WideString read FRiferimentoNormativo write FRiferimentoNormativo;
   end;

   { TEFatturaBody_DatiBeniServizi_DatiRiepilogo_Lista }
   TEFatturaBody_DatiBeniServizi_DatiRiepilogo_Lista = specialize TFPGObjectList<TEFatturaBody_DatiBeniServizi_DatiRiepilogo>;

   // TEFatturaBody_DatiBeniServizi

   TEFatturaBody_DatiBeniServizi = class(TPersistent)
   private
      FDatiRiepilogo: TEFatturaBody_DatiBeniServizi_DatiRiepilogo_Lista;
      FDettaglioLinee: TEFatturaBody_DatiBeniServizi_DettaglioLinee_Lista;
   public
      property DettaglioLinee: TEFatturaBody_DatiBeniServizi_DettaglioLinee_Lista read FDettaglioLinee write FDettaglioLinee;
      property DatiRiepilogo: TEFatturaBody_DatiBeniServizi_DatiRiepilogo_Lista read FDatiRiepilogo write FDatiRiepilogo;
   public
      constructor Create;
      destructor Destroy; override;

   end;

   // TEFatturaBody_DatiPagamento_DettaglioPagamento

   TEFatturaBody_DatiPagamento_DettaglioPagamento = class(TPersistent)
   private
      FABI: Widestring;
      FBeneficiario: Widestring;
      FBIC: Widestring;
      FCAB: Widestring;
      FCFQuietanzante: Widestring;
      FCodicePagamento: Widestring;
      FCodUfficioPostale: Widestring;
      FCognomeQuietanzante: Widestring;
      FDataDecorrenzaPenale: TDate;
      FDataLimitePagamentoAnticipato: TDate;
      FDataRiferimentoTerminiPagamento: TDate;
      FDataScadenzaPagamento: TDate;
      FGiorniTerminiPagamento: integer;
      FIBAN: Widestring;
      FImportoPagamento: extended;
      FIstitutoFinanziario: Widestring;
      FModalitaPagamento: Widestring;
      FNomeQuietanzante: Widestring;
      FPenalitaPagamentiRitardati: extended;
      FScontoPagamentoAnticipato: extended;
      FTitoloQuietanzante: Widestring;
   public
      constructor Create;

      property Beneficiario: Widestring read FBeneficiario write FBeneficiario;
      property ModalitaPagamento: Widestring read FModalitaPagamento write FModalitaPagamento;
      property DataRiferimentoTerminiPagamento: TDate read FDataRiferimentoTerminiPagamento write FDataRiferimentoTerminiPagamento;
      property GiorniTerminiPagamento:integer read FGiorniTerminiPagamento write FGiorniTerminiPagamento;
      property DataScadenzaPagamento: TDate read FDataScadenzaPagamento write FDataScadenzaPagamento;
      property ImportoPagamento: extended read FImportoPagamento write FImportoPagamento;
      property CodUfficioPostale: Widestring read FCodUfficioPostale write FCodUfficioPostale;
      property CognomeQuietanzante: Widestring read FCognomeQuietanzante write FCognomeQuietanzante;
      property NomeQuietanzante: Widestring read FNomeQuietanzante write FNomeQuietanzante;
      property CFQuietanzante: Widestring read FCFQuietanzante write FCFQuietanzante;
      property TitoloQuietanzante: Widestring read FTitoloQuietanzante write FTitoloQuietanzante;
      property IstitutoFinanziario: Widestring read FIstitutoFinanziario write FIstitutoFinanziario;
      property IBAN: Widestring read FIBAN write FIBAN;
      property ABI: Widestring read FABI write FABI;
      property CAB: Widestring read FCAB write FCAB;
      property BIC: Widestring read FBIC write FBIC;
      property ScontoPagamentoAnticipato: extended read FScontoPagamentoAnticipato write FScontoPagamentoAnticipato;
      property DataLimitePagamentoAnticipato: TDate read FDataLimitePagamentoAnticipato write FDataLimitePagamentoAnticipato;
      property PenalitaPagamentiRitardati: extended read FPenalitaPagamentiRitardati write FPenalitaPagamentiRitardati;
      property DataDecorrenzaPenale: TDate read FDataDecorrenzaPenale write FDataDecorrenzaPenale;
      property CodicePagamento: Widestring read FCodicePagamento write FCodicePagamento;
   end;

   { TEFatturaBody_DatiPagamento_DettaglioPagamento_Lista }
   TEFatturaBody_DatiPagamento_DettaglioPagamento_Lista = specialize TFPGObjectList<TEFatturaBody_DatiPagamento_DettaglioPagamento>;

   // TEFatturaBody_DatiPagamento

   TEFatturaBody_DatiPagamento = class(TPersistent)
   private
      FCondizioniPagamento: WideString;
   public
      DettaglioPagamento_Lista: TEFatturaBody_DatiPagamento_DettaglioPagamento_Lista;
   public
      constructor Create;
      destructor Destroy; override;

      property CondizioniPagamento: WideString read FCondizioniPagamento write FCondizioniPagamento;
   end;

   { TEFatturaBody_DatiPagamento_Lista }

   TEFatturaBody_DatiPagamento_Lista = specialize TFPGObjectList<TEFatturaBody_DatiPagamento>;

   // TEFatturaBody

   TEFatturaBody = class(TPersistent)
   private
      FDatiBeniServizi: TEFatturaBody_DatiBeniServizi;
      FDatiGenerali: TEFatturaBody_DatiGenerali;
   public
      Datipagamento: TEFatturaBody_DatiPagamento_Lista;
   public
      constructor Create;
      destructor Destroy; override;

      property DatiGenerali: TEFatturaBody_DatiGenerali read FDatiGenerali write FDatiGenerali;
      property DatiBeniServizi: TEFatturaBody_DatiBeniServizi read FDatiBeniServizi write FDatiBeniServizi;
   end;

   { TEFatturaBody_Lista }

   TEFatturaBody_Lista = specialize TFPGObjectList<TEFatturaBody>;


   // TEFattura

   TEFattura=class(TPersistent)
   private
      FFatturaElettronicaHeader: TEFatturaHeader;
      FVersione: WideString;
      // FFatturaElettronicaBody: TEFatturaBody;
   public
      FatturaElettronicaBody_Lista: TEFatturaBody_Lista;
   public
      constructor Create;
      destructor Destroy; override;
   published
      property Versione: WideString read FVersione write FVersione;
      property FatturaElettronicaHeader: TEFatturaHeader read FFatturaElettronicaHeader write FFatturaElettronicaHeader;
      // property FatturaElettronicaBody: TEFatturaBody read FFatturaElettronicaBody write FFatturaElettronicaBody;
   end;


   // functions
   function eFattura_FormatDateTime(AValue: TDateTime): WideString;
   function eFattura_FormatDate(AValue: TDate): WideString;
   function eFattura_FormatImporto(AValue: extended): WideString;
   function eFattura_FormatAliquota(AValue: extended): WideString;
   function eFattura_FormatQuantita(AValue: extended): WideString;
   function eFattura_FormatPrezzoUnitario(AValue: extended): WideString;
   function eFattura_FormatScontoMagg(AValue: extended): WideString;

implementation

function eFattura_FormatDateTime(AValue: TDateTime): WideString;
begin
   result := WideString(FormatDateTime('yyyy-mm-dd', AValue)) +
             'T' +
             WideString(FormatDateTime('hh:nn:ss.000', AValue)) +
             '+02:00';
end;

function eFattura_FormatDate(AValue: TDate): WideString;
begin
   result := WideString(FormatDateTime('yyyy-mm-dd', AValue));
end;

function eFattura_FormatImporto(AValue: extended): WideString;
var fs: TFormatSettings;
begin
   fs.DecimalSeparator:='.';
   fs.ThousandSeparator:=',';
   result := WideString(FloatToStrF(AValue,ffFixed,999999999,2,fs));
end;

function eFattura_FormatAliquota(AValue: extended): WideString;
var fs: TFormatSettings;
begin
   fs.DecimalSeparator:='.';
   fs.ThousandSeparator:=',';
   // result := WideString(FloatToStr(AValue));
   result := WideString(FloatToStrF(AValue,ffFixed,9999,2,fs));
end;

function eFattura_FormatQuantita(AValue: extended): WideString;
var fs: TFormatSettings;
begin
   fs.DecimalSeparator:='.';
   fs.ThousandSeparator:=',';
   // result := WideString(FloatToStrF(AValue,ffFixed,999999999,10,fs));
   result:= WideString(FormatFloat('0.0000000#', AValue, fs));
end;

function eFattura_FormatPrezzoUnitario(AValue: extended): WideString;
var fs: TFormatSettings;
begin
   fs.DecimalSeparator:='.';
   fs.ThousandSeparator:=',';
   // result := WideString(FloatToStrF(AValue,ffFixed,999999999,10,fs));
   result:= WideString(FormatFloat('0.0000000#', AValue, fs));
end;

function eFattura_FormatScontoMagg(AValue: extended): WideString;
var fs: TFormatSettings;
begin
   fs.DecimalSeparator:='.';
   fs.ThousandSeparator:=',';
   // result := WideString(FloatToStrF(AValue,ffFixed,999999999,10,fs));
   result:= WideString(FormatFloat('0.00######', AValue, fs));
end;

{ TEFatturaBody_DatiPagamento }

constructor TEFatturaBody_DatiPagamento.Create;
begin
   DettaglioPagamento_Lista:=TEFatturaBody_DatiPagamento_DettaglioPagamento_Lista.Create(True);
end;

destructor TEFatturaBody_DatiPagamento.Destroy;
begin
   FreeAndNil(DettaglioPagamento_Lista);

   inherited Destroy;
end;

{ TEFatturaBody_DatiPagamento_DettaglioPagamento }

constructor TEFatturaBody_DatiPagamento_DettaglioPagamento.Create;
begin
   FABI:='';
   FBeneficiario:='';
   FBIC:='';
   FCAB:='';
   FCFQuietanzante:='';
   FCodicePagamento:='';
   FCodUfficioPostale:='';
   FCognomeQuietanzante:='';
   FDataDecorrenzaPenale:=0;
   FDataLimitePagamentoAnticipato:=0;
   FDataRiferimentoTerminiPagamento:=0;
   FDataScadenzaPagamento:=0;
   FGiorniTerminiPagamento:=0;
   FIBAN:='';
   FImportoPagamento:=0.0;
   FIstitutoFinanziario:='';
   FModalitaPagamento:='';
   FNomeQuietanzante:='';
   FPenalitaPagamentiRitardati:=0.0;
   FScontoPagamentoAnticipato:=0.0;
   FTitoloQuietanzante:='';
end;


{ TEFatturaBody_DatiBeniServizi_DettaglioLinee_AltriDatiGestionali }

constructor TEFatturaBody_DatiBeniServizi_DettaglioLinee_AltriDatiGestionali.Create;
begin
   FRiferimentoData:=0;
   FRiferimentoNumero:=0;
   FRiferimentoTesto:='';
   FTipoDato:='';
end;

{ TEFatturaBody_DatiBeniServizi_DettaglioLinee_CodiceArticolo }

constructor TEFatturaBody_DatiBeniServizi_DettaglioLinee_CodiceArticolo.Create;
begin
   FCodiceTipo:='';
   FCodiceValore:='';
end;

{ TEFatturaBody_DatiBeniServizi }

constructor TEFatturaBody_DatiBeniServizi.Create;
begin
   FDatiRiepilogo:=TEFatturaBody_DatiBeniServizi_DatiRiepilogo_Lista.Create(True);
   FDettaglioLinee:=TEFatturaBody_DatiBeniServizi_DettaglioLinee_Lista.Create(True);
end;

destructor TEFatturaBody_DatiBeniServizi.Destroy;
begin
   FreeAndNil(FDatiRiepilogo);
   FreeAndNil(FDettaglioLinee);

   inherited Destroy;
end;

{ TEFatturaBody_DatiBeniServizi_DatiRiepilogo }

constructor TEFatturaBody_DatiBeniServizi_DatiRiepilogo.Create;
begin
   FAliquotaIVA:=0.0;
   FArrotondamento:=0.0;
   FEsigibilitaIVA:='';
   FImponibileImporto:=0.0;
   FImposta:=0.0;
   FNatura:='';
   FRiferimentoNormativo:='';
   FSpeseAccessorie:=0.0;
end;

{ TEFatturaBody_DatiBeniServizi_DettaglioLinee }

constructor TEFatturaBody_DatiBeniServizi_DettaglioLinee.Create;
begin
   FAliquotaIVA:=0.0;
   FDataFinePeriodo:=0;
   FDataInizioPeriodo:=0;
   FDescrizione:='';
   FNatura:='';
   FNumeroLinea:=0;
   FPrezzoTotale:=0.0;
   FPrezzoUnitario:=0.0;
   FQuantita:=0.0;
   FRiferimentoAmministrazione:='';
   FRitenuta:='';
   FTipoCessionePrestazione:='';
   FUnitaMisura:='';
   FLineaDescrittiva:=False;

   CodiceArticolo:=TEFatturaBody_DatiBeniServizi_DettaglioLinee_CodiceArticolo_Lista.Create(True);
   ScontoMaggiorazione:=TEFatturaBody_Generico_ScontoMaggiorazione_Lista.Create(True);
   AltriDatiGestionali:=TEFatturaBody_DatiBeniServizi_DettaglioLinee_AltriDatiGestionali_Lista.Create(True);

end;

destructor TEFatturaBody_DatiBeniServizi_DettaglioLinee.Destroy;
begin
   FreeAndNil(CodiceArticolo);
   FreeAndNil(ScontoMaggiorazione);
   FreeAndNil(AltriDatiGestionali);

   inherited Destroy;
end;

{ TEFatturaBody_DatiGenerali_DatiTrasporto }

function TEFatturaBody_DatiGenerali_DatiTrasporto.GetIsAssigned: boolean;
begin
   result := FDatiAnagraficiVettore.IsAssigned
             or
             FIndirizzoResa.IsAssigned
             or
             (FCausaleTrasporto<>'')
             or
             (FDataInizioTrasporto<>0)
             or
             (FDataOraConsegna<>0)
             or
             (FDataOraRitiro<>0)
             or
             (FDescrizione<>'')
             or
             (FMezzoTrasporto<>'')
             or
             (FNumeroColli<>0)
             or
             (FPesoLordo<>0)
             or
             (FPesoNetto<>0)
             or
             (FTipoResa<>'')
             or
             (FUnitaMisuraPeso<>'');
end;

constructor TEFatturaBody_DatiGenerali_DatiTrasporto.Create;
begin
   FCausaleTrasporto:='';
   FDataInizioTrasporto:=0;
   FDataOraConsegna:=0;
   FDataOraRitiro:=0;
   FDescrizione:='';
   FMezzoTrasporto:='';
   FNumeroColli:=0;
   FPesoLordo:=0;
   FPesoNetto:=0;
   FTipoResa:='';
   FUnitaMisuraPeso:='';

   FIndirizzoResa:=TEFatturaHeader_Generico_Sede.Create;
   FDatiAnagraficiVettore:=TEFatturaBody_DatiGenerali_DatiTrasporto_DatiAnagraficiVettore.Create;
end;

destructor TEFatturaBody_DatiGenerali_DatiTrasporto.Destroy;
begin
   FreeAndNil(FIndirizzoResa);
   FreeAndNil(FDatiAnagraficiVettore);

   inherited Destroy;
end;

{ TEFatturaBody_DatiGenerali_DatiTrasporto_DatiAnagraficiVettore }

function TEFatturaBody_DatiGenerali_DatiTrasporto_DatiAnagraficiVettore.GetIsAssigned: boolean;
begin
   result := FAnagrafica.IsAssigned
             or
             FIdFiscaleIVA.IsAssigned
             or
             (FCodiceFiscale<>'');
end;

constructor TEFatturaBody_DatiGenerali_DatiTrasporto_DatiAnagraficiVettore.Create;
begin
   FCodiceFiscale:='';
   FNumeroLicenzaGuida:='';

   FAnagrafica:=TEFatturaHeader_Generico_Anagrafica.Create;
   FIdFiscaleIVA:=TEFatturaHeader_Generico_IdFiscaleIVA.Create;
end;

destructor TEFatturaBody_DatiGenerali_DatiTrasporto_DatiAnagraficiVettore.Destroy;
begin
   FreeAndNil(FAnagrafica);
   FreeAndNil(FIdFiscaleIVA);

   inherited Destroy;
end;

{ TEFatturaBody_DatiGenerali_DatiDDT }

constructor TEFatturaBody_DatiGenerali_DatiDDT.Create;
begin
   FDataDDT:=0;
   FNumeroDDT:='';

   FRiferimentoNumeroLinea:=TStringList.Create;
end;

destructor TEFatturaBody_DatiGenerali_DatiDDT.Destroy;
begin
   FreeAndNil(FRiferimentoNumeroLinea);

   inherited Destroy;
end;

{ TEFatturaBody_DatiGenerali }

constructor TEFatturaBody_DatiGenerali.Create;
begin
   FDatiGeneraliDocumento:=TEFatturaBody_DatiGenerali_DatiGeneraliDocumento.Create;
   FDatiTrasporto:=TEFatturaBody_DatiGenerali_DatiTrasporto.Create;

   DatiOrdineAcquisto_Lista:=TEFatturaBody_DatiGenerali_DatiOrdineAcquisto_Lista.Create(True);
   DatiDDT_Lista:=TEFatturaBody_DatiGenerali_DatiDDT_Lista.Create(True);
end;

destructor TEFatturaBody_DatiGenerali.Destroy;
begin
   FreeAndNil(DatiDDT_Lista);
   FreeAndNil(DatiOrdineAcquisto_Lista);

   FreeAndNil(FDatiTrasporto);
   FreeAndNil(FDatiGeneraliDocumento);

   inherited Destroy;
end;

{ TEFatturaBody_DatiGenerali_DatiOrdineAcquisto }

function TEFatturaBody_DatiGenerali_DatiOrdineAcquisto.GetAssigned: boolean;
begin
   result := (Trim(FCodiceCIG)<>'')
             or
             (Trim(FCodiceCommessaConvenzione)<>'')
             or
             (Trim(FCodiceCUP)<>'')
             or
             (Trim(FIdDocumento)<>'')
             ;
end;

constructor TEFatturaBody_DatiGenerali_DatiOrdineAcquisto.Create;
begin
   FCodiceCIG:='';
   FCodiceCommessaConvenzione:='';
   FCodiceCUP:='';
   FData:=0;
   FIdDocumento:='';
   FNumItem:='';

   FRiferimentoNumeroLinea:=TStringList.Create;
end;

destructor TEFatturaBody_DatiGenerali_DatiOrdineAcquisto.Destroy;
begin
   FreeAndNil(FRiferimentoNumeroLinea);

   inherited Destroy;
end;

{ TEFatturaBody_Generico_ScontoMaggiorazione }

constructor TEFatturaBody_Generico_ScontoMaggiorazione.Create;
begin
   FImporto:=0.0;
   FPercentuale:=0.0;
   FTipo:='';
end;

{ TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiBollo }

constructor TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiBollo.Create;
begin
   FBolloVirtuale:='';
   FImportoBollo:=0.0;
end;

{ TEFatturaBody_DatiGenerali_DatiGeneraliDocumento }

function TEFatturaBody_DatiGenerali_DatiGeneraliDocumento.GetImportoTotaleDocumentoIsAssigned: boolean;
begin
   result := (FImportoTotaleDocumento <> 0.0)
             or
             ((FImportoTotaleDocumento = 0.0) and FImportoTotaleDocumentoAZero);
end;

constructor TEFatturaBody_DatiGenerali_DatiGeneraliDocumento.Create;
begin
   ScontoMaggiorazione_Lista:=TEFatturaBody_Generico_ScontoMaggiorazione_Lista.Create(True);

   FData:=0.0;
   FDivisa:='';
   FNumero:='';
   FTipoDocumento:='';
   FImportoTotaleDocumento:=0.0;
   FArrotondamento:=0.0;
   FArt73:='';

   FImportoTotaleDocumentoAZero:= False;

   FDatiBollo:=TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiBollo.Create;
   FDatiCassaPrevidenziale:=TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiCassaPrevidenziale.Create;
   FDatiRitenuta:=TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiRitenuta.Create;
   FCausale:=TStringList.Create;
end;

destructor TEFatturaBody_DatiGenerali_DatiGeneraliDocumento.Destroy;
begin
   FreeAndNil(ScontoMaggiorazione_Lista);

   FreeAndNil(FCausale);
   FreeAndNil(FDatiBollo);
   FreeAndNil(FDatiCassaPrevidenziale);
   FreeAndNil(FDatiRitenuta);

   inherited Destroy;
end;

{ TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiRitenuta }

constructor TEFatturaBody_DatiGenerali_DatiGeneraliDocumento_DatiRitenuta.Create;
begin
   FAliquotaRitenuta:=0.0;
   FCausalePagamento:='';
   FImportoRitenuta:=0.0;
   FTipoRitenuta:='';
end;

{ TEFatturaBody }

constructor TEFatturaBody.Create;
begin
   FDatiGenerali:=TEFatturaBody_DatiGenerali.Create;
   FDatiBeniServizi:=TEFatturaBody_DatiBeniServizi.Create;

   Datipagamento:=TEFatturaBody_DatiPagamento_Lista.Create(True);

end;

destructor TEFatturaBody.Destroy;
begin
   FreeAndNil(FDatiGenerali);
   FreeAndNil(FDatiBeniServizi);

   FreeAndNil(Datipagamento);
   inherited Destroy;
end;

{ TEFatturaHeader_Generico_IdFiscaleIVA }

function TEFatturaHeader_Generico_IdFiscaleIVA.GetAssigned: boolean;
begin
   result := (FIdCodice <> '') and (FIdPaese <> '');
end;

constructor TEFatturaHeader_Generico_IdFiscaleIVA.Create;
begin
   FIdCodice:='';
   FIdPaese:='';
end;

{ TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente }

constructor TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente.Create;
begin
   FDatiAnagrafici:=TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente_DatiAnagrafici.Create;
end;

destructor TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente.Destroy;
begin
   FreeAndNil(FDatiAnagrafici);

   inherited Destroy;
end;

{ TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente_DatiAnagrafici }

constructor TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente_DatiAnagrafici.Create;
begin
   FCodiceFiscale:='';
   FIdFiscaleIVA:=TEFatturaHeader_Generico_IdFiscaleIVA.Create;
   FAnagrafica:=TEFatturaHeader_Generico_Anagrafica.Create;
end;

destructor TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente_DatiAnagrafici.Destroy;
begin
   FreeAndNil(FIdFiscaleIVA);
   FreeAndNil(FAnagrafica);

   inherited Destroy;
end;

{ TEFatturaHeader_CessionarioCommittente }

constructor TEFatturaHeader_CessionarioCommittente.Create;
begin
   FDatiAnagrafici:=TEFatturaHeader_CessionarioCommittente_DatiAnagrafici.Create;
   FRappresentanteFiscale:=TEFatturaHeader_CessionarioCommittente_RappresentanteFiscale.Create;
   FSede:=TEFatturaHeader_Generico_Sede.Create;
   FStabileOrganizzazione:=TEFatturaHeader_Generico_Sede.Create;
end;

destructor TEFatturaHeader_CessionarioCommittente.Destroy;
begin
   FreeAndNil(FDatiAnagrafici);
   FreeAndNil(FRappresentanteFiscale);
   FreeAndNil(FSede);
   FreeAndNil(FStabileOrganizzazione);

   inherited Destroy;
end;

{ TEFatturaHeader_CessionarioCommittente_RappresentanteFiscale }

constructor TEFatturaHeader_CessionarioCommittente_RappresentanteFiscale.Create;
begin
   FCognome:='';
   FDenominazione:='';
   FNome:='';
   FIdFiscaleIVA:=TEFatturaHeader_Generico_IdFiscaleIVA.Create;
end;

destructor TEFatturaHeader_CessionarioCommittente_RappresentanteFiscale.Destroy;
begin
   FreeAndNil(FIdFiscaleIVA);

   inherited Destroy;
end;


{ TEFatturaHeader_CessionarioCommittente_DatiAnagrafici }

constructor TEFatturaHeader_CessionarioCommittente_DatiAnagrafici.Create;
begin
   FCodiceFiscale:='';
   FAnagrafica:=TEFatturaHeader_Generico_Anagrafica.Create;
   FIdFiscaleIVA:=TEFatturaHeader_Generico_IdFiscaleIVA.Create;
end;

destructor TEFatturaHeader_CessionarioCommittente_DatiAnagrafici.Destroy;
begin
   FreeAndNil(FIdFiscaleIVA);
   FreeAndNil(FAnagrafica);

   inherited Destroy;
end;

{ TEFatturaHeader_RappresentanteFiscale }

constructor TEFatturaHeader_RappresentanteFiscale.Create;
begin
   FDatiAnagrafici:=TEFatturaHeader_RappresentanteFiscale_DatiAnagrafici.Create;
end;

destructor TEFatturaHeader_RappresentanteFiscale.Destroy;
begin
   FreeAndNil(FDatiAnagrafici);

   inherited Destroy;
end;

{ TEFatturaHeader_RappresentanteFiscale_DatiAnagrafici }

constructor TEFatturaHeader_RappresentanteFiscale_DatiAnagrafici.Create;
begin
   FRegimeFiscale:='';
   FCodiceFiscale:='';
   FAnagrafica:=TEFatturaHeader_Generico_Anagrafica.Create;
   FIdFiscaleIVA:=TEFatturaHeader_Generico_IdFiscaleIVA.Create;
end;

destructor TEFatturaHeader_RappresentanteFiscale_DatiAnagrafici.Destroy;
begin
   FreeAndNil(FIdFiscaleIVA);
   FreeAndNil(FAnagrafica);

   inherited Destroy;
end;

{ TEFatturaHeader_CedentePrestatore }

constructor TEFatturaHeader_CedentePrestatore.Create;
begin
   FRiferimentoAmministrazione:='';
   FContatti:=TEFatturaHeader_Generico_Contatti.Create;
   FDatiAnagrafici:=TEFatturaHeader_CedentePrestatore_DatiAnagrafici.Create;
   FIscrizioneREA:=TEFatturaHeader_CedentePrestatore_IscrizioneREA.Create;
   FSede:=TEFatturaHeader_Generico_Sede.Create;
   FStabileOrganizzazione:=TEFatturaHeader_Generico_Sede.Create;
end;

destructor TEFatturaHeader_CedentePrestatore.Destroy;
begin
   FreeAndNil(FContatti);
   FreeAndNil(FDatiAnagrafici);
   FreeAndNil(FIscrizioneREA);
   FreeAndNil(FSede);
   FreeAndNil(FStabileOrganizzazione);

   inherited Destroy;
end;

{ TEFatturaHeader_CedentePrestatore_IscrizioneREA }

constructor TEFatturaHeader_CedentePrestatore_IscrizioneREA.Create;
begin
   Ufficio:='';
   NumeroREA:='';
   CapitaleSociale:='';
   SocioUnico:='';
   StatoLiquidazione:='';
end;

{ TEFatturaHeader_CedentePrestatore_DatiAnagrafici }

constructor TEFatturaHeader_CedentePrestatore_DatiAnagrafici.Create;
begin
   FRegimeFiscale:='';
   FAnagrafica:=TEFatturaHeader_Generico_Anagrafica.Create;
   FIdFiscaleIVA:=TEFatturaHeader_Generico_IdFiscaleIVA.Create;
end;

destructor TEFatturaHeader_CedentePrestatore_DatiAnagrafici.Destroy;
begin
   FreeAndNil(FIdFiscaleIVA);
   FreeAndNil(FAnagrafica);

   inherited Destroy;
end;

{ TEFatturaHeader_DatiTrasmissione }


constructor TEFatturaHeader_DatiTrasmissione.Create;
begin
   FCodiceDestinatario:='';
   FFormatoTrasmissione:='';
   FPecDestinatario:='';
   FProgressivoInvio:='';

   FIdTrasmittente:=TEFatturaHeader_Generico_IdFiscaleIVA.Create;
   FContattiTrasmittente:=TEFatturaHeader_Generico_Contatti.Create;

end;

destructor TEFatturaHeader_DatiTrasmissione.Destroy;
begin
   FreeAndNil(FIdTrasmittente);
   FreeAndNil(FContattiTrasmittente);

   inherited Destroy;
end;

{ TEFatturaHeader_Generico_Sede }

function TEFatturaHeader_Generico_Sede.GetIsAssigned: boolean;
begin
   result := (FIndirizzo<>'')
             or
             (FCAP <> '')
             or
             (FComune<>'');
end;

constructor TEFatturaHeader_Generico_Sede.Create;
begin
   FIndirizzo:='';
   FNumeroCivico:='';
   FCAP:='';
   FComune:='';
   FProvincia:='';
   FNazione:='';
end;

{ TEFatturaHeader_Generico_Anagrafica }

function TEFatturaHeader_Generico_Anagrafica.GetIsAssigned: boolean;
begin
   result := (FDenominazione<>'')
             or
             (FNome<>'')
             or
             (FTitolo<>'');
end;

constructor TEFatturaHeader_Generico_Anagrafica.Create;
begin
   FDenominazione:='';
   FNome:='';
   FCognome:='';
   FTitolo:='';
   FCodEORI:='';
end;

{ TEFatturaHeader_Generico_Contatti }

function TEFatturaHeader_Generico_Contatti.GetAssigned: boolean;
begin
   result := (Femail<>'') or (FFax<>'') or (FTelefono<>'')
end;

constructor TEFatturaHeader_Generico_Contatti.Create;
begin
   Femail:='';
   FFax:='';
   FTelefono:='';
end;


{ TEFatturaHeader }

constructor TEFatturaHeader.Create;
begin
   FDatiTrasmissione:=TEFatturaHeader_DatiTrasmissione.Create;
   FCedentePrestatore:=TEFatturaHeader_CedentePrestatore.Create;
   FCessionarioCommittente:=TEFatturaHeader_CessionarioCommittente.Create;
   FTerzoIntermediarioOSoggettoEmittente:=TEFatturaHeader_TerzoIntermediarioOSoggettoEmittente.Create;
end;

destructor TEFatturaHeader.Destroy;
begin
   FreeAndNil(FDatiTrasmissione);
   FreeAndNil(FCedentePrestatore);
   FreeAndNil(FCessionarioCommittente);
   FreeAndNil(FTerzoIntermediarioOSoggettoEmittente);

   inherited Destroy;
end;


{ TEFattura }

constructor TEFattura.Create;
begin
   FFatturaElettronicaHeader:=TEFatturaHeader.Create;
   FatturaElettronicaBody_Lista:=TEFatturaBody_Lista.Create(True);
end;

destructor TEFattura.Destroy;
begin
   FatturaElettronicaBody_Lista.Clear;

   FreeAndNil(FatturaElettronicaBody_Lista);
   FreeAndNil(FFatturaElettronicaHeader);

   inherited Destroy;
end;

end.

