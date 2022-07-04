program Joist;

uses
  Forms,
  main in 'main.pas' {MainForm},
  entry in 'entry.pas' {EntryForm},
  extload in 'extload.pas' {ExtLoadForm},
  catalog in 'catalog.pas' {CatalogForm},
  customer in 'customer.pas' {CustomerForm},
  login in 'login.pas' {LoginForm},
  matprop in 'matprop.pas' {MatPropForm},
  batch in 'batch.pas' {BatchForm},
  jobinfo in 'jobinfo.pas' {JobInfoForm},
  seqprop in 'seqprop.pas' {SeqPropForm},
  tcexten in 'tcexten.pas' {TCExtenForm},
  pricetbl in 'pricetbl.pas' {PriceTblForm},
  sprink in 'sprink.pas' {SprinkForm},
  jobprop in 'jobprop.pas' {JobPropForm},
  bridg2 in 'bridg2.pas' {Bridg2Form},
  paneltc in 'paneltc.pas' {PanelTCForm},
  partial in 'partial.pas' {PartialForm},
  matreq in 'matreq.pas' {MatReqForm},
  joblook in 'joblook.pas' {JobLookForm},
  analysis in 'analysis.pas',
  output in 'output.pas',
  output2 in 'output2.pas',
  main2 in 'main2.pas',
  fixes in 'fixes.pas' {FixesForm},
  websel in 'websel.pas' {WebSelForm},
  entry2 in 'entry2.pas',
  concload in 'concload.pas' {ConcLoadForm},
  bridging in 'bridging.pas' {BridgingForm},
  jsubst in 'jsubst.pas' {JSubstForm},
  about in 'about.pas' {AboutForm},
  joistrep in 'joistrep.pas' {joistrepForm},
  exportjobs in 'exportjobs.pas' {ExportJobsForm},
  gpanel in 'gpanel.pas' {GPanelForm},
  Import in 'Import.pas' {ImportForm},
  PSI in 'PSI.pas' {PSIForm},
  NetSec in 'NetSec.pas' {SecurityForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ISP Joist Design';
  Application.HelpFile := 'Joist.hlp';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
