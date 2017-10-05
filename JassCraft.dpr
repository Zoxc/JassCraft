program JassCraft;

{%ToDo 'JassCraft.todo'}

uses
  Forms,
  Dialogs,
  uOneInstance in 'uOneInstance.pas',
  uMain in 'uMain.pas' {MainForm},
  uDocuments in 'uDocuments.pas',
  uMyIniFiles in 'uMyIniFiles.pas',
  uFind in 'uFind.pas' {FindDialog},
  uAbout in 'uAbout.pas' {AboutDialog},
  uReplace in 'uReplace.pas' {ReplaceDialog},
  uMRU in 'uMRU.pas',
  uGoToLine in 'uGoToLine.pas' {GoToLineDialog},
  uUtils in 'uUtils.pas',
  uFuncList in 'uFuncList.pas' {frmFuncList},
  uOptions in 'uOptions.pas' {OptionsDialog},
  uConfirmReplace in 'uConfirmReplace.pas' {ConfirmReplaceDialog},
  uExSynEdit in 'uExSynEdit.pas',
  uNativeList in 'uNativeList.pas' {frmNative},
  uMPQ in 'uMPQ.pas',
  JassUnit in 'JassUnit.pas',
  JvDockControlForm in '..\JVCL310CompleteJCL196-Build2070\jvcl\run\JvDockControlForm.pas',
  frmMPQEdit in 'MPQ\frmMPQEdit.pas' {frmMPQ},
  pMpqReadWrite in 'pMpqReadWrite.pas',
  pMpqAPI in 'MPQ\pMpqAPI.pas',
  uFuncInfo in 'uFuncInfo.pas' {TipForm},
  TBXOffice2003Theme in 'TBXOffice2003Theme.pas',
  SynMdl in 'SynMdl.pas',
  pMpqEditor in 'MPQ\pMpqEditor.pas',
  uCodeFolding in 'uCodeFolding.pas',
  SynEdit in 'SynEdit.pas',
  uSplash in 'uSplash.pas' {frmSplash},
  ccCodeBools in 'Scripting\ccCodeBools.pas',
  ccCodeFuncList in 'Scripting\ccCodeFuncList.pas',
  ccCodeFuncs in 'Scripting\ccCodeFuncs.pas',
  ccCodeMain in 'Scripting\ccCodeMain.pas',
  ccCodeNumbers in 'Scripting\ccCodeNumbers.pas',
  ccCodeStrings in 'Scripting\ccCodeStrings.pas',
  ccCodeVariables in 'Scripting\ccCodeVariables.pas',
  ccButton in 'Scripting\ccLibrary\ccButton.pas',
  ccControls in 'Scripting\ccLibrary\ccControls.pas',
  ccForms in 'Scripting\ccLibrary\ccForms.pas' {ccForm},
  ccGraphics in 'Scripting\ccLibrary\ccGraphics.pas',
  ccLabel in 'Scripting\ccLibrary\ccLabel.pas',
  ccMath in 'Scripting\ccLibrary\ccMath.pas',
  ccMenus in 'Scripting\ccLibrary\ccMenus.pas',
  uScriptingEngine in 'uScriptingEngine.pas',
  ccJassCraft in 'Scripting\ccLibrary\ccJassCraft.pas',
  SynJass in 'SynJass.pas',
  uSyntaxCheck in 'uSyntaxCheck.pas';

{$R IconDoc.res}
{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'JassCraft';
  frmSplash := TfrmSplash.Create(Application);
  frmSplash.Show;
  frmSplash.Update;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TTipForm, TipForm);
  Application.Run;
end.
