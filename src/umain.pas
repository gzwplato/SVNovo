{
  This file is part of SVNovo
  Copyright (C) 2016 Marco Caselli <marcocas@gmail.com>

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
}

unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Menus, ExtCtrls, ActnList, ShellCtrls, SVNClasses, SVNTypes, formlog, ProcessRunner;

type

  { TfMain }

  TFileTreeNode = class ( TTreeNode)
    public
      BaseNode: TFileTreeNode;
      FullPath: string;
    end;

  TfMain = class(TForm)
    actCommit: TAction;
    actAdd: TAction;
    actAbout: TAction;
    actCleanup: TAction;
    actBookMarkAdd: TAction;
    actBookMarkDelete: TAction;
    actDiffHEAD: TAction;
    actBookMarkCheckout: TAction;
    actAnnotate: TAction;
    actDiff: TAction;
    actDiffBASE: TAction;
    actUpgrade: TAction;
    actMarkResolved: TAction;
    actLog: TAction;
    actRevert: TAction;
    actRefresh: TAction;
    actShowUnversioned: TAction;
    actFlatMode: TAction;
    actShowModified: TAction;
    actShowUnmodified: TAction;
    actShowConflict: TAction;
    actUpdate: TAction;
    ActionList: TActionList;
    ImageList_22x22: TImageList;
    ImageList_22x22_mask: TImageList;
    MainMenu: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    mnuPreferences: TMenuItem;
    mnuView: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    pmElements: TPopupMenu;
    pmBookmark: TPopupMenu;
    SelectDirectoryDialog: TSelectDirectoryDialog;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    StatusBar1: TStatusBar;
    SVNFileListView: TListView;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    tvBookMark: TTreeView;
    procedure actAboutExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actAnnotateExecute(Sender: TObject);
    procedure actBookMarkAddExecute(Sender: TObject);
    procedure actBookMarkCheckoutExecute(Sender: TObject);
    procedure actCleanupExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDiffBASEExecute(Sender: TObject);
    procedure actDiffExecute(Sender: TObject);
    procedure actFlatModeExecute(Sender: TObject);
    procedure actDiffHEADExecute(Sender: TObject);
    procedure ActionListUpdate(AAction: TBasicAction; var Handled: Boolean);
    procedure actLogExecute(Sender: TObject);
    procedure actMarkResolvedExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actRevertExecute(Sender: TObject);
    procedure actShowConflictExecute(Sender: TObject);
    procedure actShowModifiedExecute(Sender: TObject);
    procedure actShowUnmodifiedExecute(Sender: TObject);
    procedure actShowUnversionedExecute(Sender: TObject);
    procedure actUpdateExecute(Sender: TObject);
    procedure actUpgradeExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuPreferencesClick(Sender: TObject);
    procedure SVNFileListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure SVNFileListViewData(Sender: TObject; Item: TListItem);
    procedure SVNFileListViewDblClick(Sender: TObject);
    procedure SVNFileListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure tvBookMarkClick(Sender: TObject);
    procedure tvBookMarkCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
    procedure tvBookMarkExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
  private
    RepositoryPath: string;
    Filter: TSVNItemStatusSet;
    SavedSortItem: TStatusItemName;
    SavedSortDirection: TSortDirection;
    procedure Rundiff(const Rev1, Rev2: string);
    procedure SelectSubDir(Subdir: string);
    Procedure SetColumn(ListView: TListView; ColNo, DefaultWidth: integer; AName: string; ColAutoSize: boolean; Alignment: TAlignment);
    procedure BeginProcess(Sender: TObject);
    procedure EndProcess(Sender: TObject);
    procedure ExpandNode(Node: TTreeNode);
    procedure GetSelectedElements(Elements: Tstrings);
    procedure LoadBookmarks;
    procedure LoadTree(Node: TTreeNode; BasePath: string);
    procedure Log(Sender: TObject; const SVNMessageKind: TRunnerMessageKind; const Message: string);
    procedure UpdateFilesListView;
    Procedure ConfigToMap;
    Procedure MapToConfig;
    procedure UpdateFilter(Reload: boolean= true);

  public
    SVNClient : TSVNClient;
  end;

var
  fMain: TfMain;

implementation
uses LazFileUtils, LCLProc, AsyncProcess, Config, FilesSupport, uabout,
  formupdate, formcommit, formconfig, formaddrepository, formannotate, formdiff,
  strutils;
{$R *.lfm}
type
  TEnumStatus =  specialize TEnum<TStatusItemName>;
  TEnumSort =  specialize TEnum<TSortDirection>;

{ TfMain }

procedure TfMain.UpdateFilesListView;
var
  i: integer;
  Item: TListItem;
  SVNItem: TSVNItem;
  Path: string;
  imgIdx: integer;
begin

  SVNFileListView.BeginUpdate;
  try
  SVNFileListView.Clear;
  for i := 0 to SVNClient.List.Count -1 do
    begin
      SVNItem := SVNClient.List[i];
      if not (SVNItem.ItemStatus in Filter) then
        Continue;
      Item := SVNFileListView.Items.Add;
      Item.Data:=SVNItem;

      with item do
         begin
       //checkboxes
         Caption := '';
         Checked := SVNItem.Checked;
         //path
         Path := SVNItem.Path;
         if pos(SVNClient.RepositoryPath, Path) = 1 then
           path := CreateRelativePath(path, SVNClient.RepositoryPath, false);
         SubItems.Add(SVNItem.Name);
         SubItems.Add(Path);

         if (SVNItem.ItemStatus <> sisUnversioned) and
            (SVNItem.ItemStatus <> sisAdded) then
           begin
             SubItems.Add(IntToStr(SVNItem.Revision));
             SubItems.Add(IntToStr(SVNItem.CommitRevision));
             SubItems.Add(SVNItem.Author);
             if (SVNItem.DateModified) <> 0 then
               SubItems.Add(DateTimeToStr(SVNItem.DateModified))
             else
               SubItems.Add('');
             SubItems.Add(SVNItem.Extension);
             SubItems.Add(DateTimeToStr(SVNItem.DateSVN));
           end
         else
           begin
             SubItems.Add('');
             SubItems.Add('');
             SubItems.Add('');
             if (SVNItem.DateModified) <> 0 then
               SubItems.Add(DateTimeToStr(SVNItem.DateModified))
             else
               SubItems.Add('');

             SubItems.Add(SVNItem.Extension);
             SubItems.Add('');
           end;

         //file status
         SubItems.Add(TSVNClient.ItemStatusToStatus(SVNItem.ItemStatus));
         //property status
         SubItems.Add(SVNItem.PropStatus);
         //check if file is versioned
         Case SVNItem.ItemStatus of
          sisAdded:       if SVNItem.IsFolder then imgidx :=  2 else imgidx :=  1;
          sisConflicted:  if SVNItem.IsFolder then imgidx := -1 else imgidx :=  9;
          sisDeleted:     if SVNItem.IsFolder then imgidx := 13 else imgidx := 12;
          sisExternal:    if SVNItem.IsFolder then imgidx := 15 else imgidx := -1;
          sisIgnored:     if SVNItem.IsFolder then imgidx := -1 else imgidx := -1;
          sisIncomplete:  if SVNItem.IsFolder then imgidx := -1 else imgidx := -1;
          sisMerged:      if SVNItem.IsFolder then imgidx := -1 else imgidx := 42;
          sisMissing:     if SVNItem.IsFolder then imgidx := 44 else imgidx := 43;
          sisModified:    if SVNItem.IsFolder then imgidx := 46 else imgidx := 45;
          sisNone:        if SVNItem.IsFolder then imgidx := -1 else imgidx := -1;
          sisNormal:      if SVNItem.IsFolder then imgidx := 18 else imgidx := 56;
          sisObstructed:  if SVNItem.IsFolder then imgidx := -1 else imgidx := -1;
          sisReplaced:    if SVNItem.IsFolder then imgidx := 63 else imgidx := 62;
          sisUnversioned: if SVNItem.IsFolder then imgidx := 54 else imgidx := 53;
        else
          imgidx := -1;
        end;
        ImageIndex:= imgidx;
        StateIndex:= imgidx;

       end;

    end;

  finally
    SVNFileListView.EndUpdate;
  end;

  SVNFileListView.Column[2].Visible := actFlatMode.Checked;

  // if I was sorting by path and now I hide path column, sort by name
  if not SVNFileListView.Column[2].Visible and (SVNClient.List.SortItem = siPath) then
    SVNClient.List.SortItem := siName;


  SVNFileListView.Sort;


end;

procedure TfMain.ConfigToMap;
begin

  actFlatMode.Checked := ConfigObj.ReadBoolean('Filter/FlatMode', false);

  actShowUnversioned.Checked := ConfigObj.ReadBoolean('Filter/ShowUnversioned', True);
  actShowUnmodified.Checked := ConfigObj.ReadBoolean('Filter/ShowUnmodified', True);
  actShowModified.Checked := ConfigObj.ReadBoolean('Filter/ShowModified', True);
  actShowConflict.Checked := ConfigObj.ReadBoolean('Filter/ShowConflict', True);

  SavedSortItem:= TEnumStatus.FromString(ConfigObj.ReadString('Filter/SortItem',''), siPath);
  SavedSortDirection:= TEnumSort.FromString(ConfigObj.ReadString('Filter/SortDirection',''), sdAscending);

  UpdateFilter(False);
end;

procedure TfMain.MapToConfig;
var
   BookMark: TFileTreeNode;
begin
// Save form state
  ConfigObj.WriteInteger('FormState/Height', Height);
  ConfigObj.WriteInteger('FormState/Width', Width);
  ConfigObj.WriteInteger('FormState/Top', Top);
  ConfigObj.WriteInteger('FormState/Left', Left);

  ConfigObj.WriteBoolean('Filter/FlatMode', actFlatMode.Checked);
  ConfigObj.WriteBoolean('Filter/ShowUnversioned', actShowUnversioned.Checked);
  ConfigObj.WriteBoolean('Filter/ShowUnmodified', actShowUnmodified.Checked);
  ConfigObj.WriteBoolean('Filter/ShowModified', actShowModified.Checked);
  ConfigObj.WriteBoolean('Filter/ShowConflict', actShowConflict.Checked);

  ConfigObj.WriteString('Filter/SortItem', TEnumStatus.ToString(SVNClient.List.SortItem));
  ConfigObj.WriteString('Filter/SortDirection', TEnumSort.ToString(SVNClient.List.SortDirection));

  BookMark := TFileTreeNode(tvBookMark.Selected);
  if Assigned(BookMark) then
    begin
      ConfigObj.WriteString('LastSelected/BookMark', BookMark.BaseNode.FullPath);
      ConfigObj.WriteString('LastSelected/Path', CreateRelativePath(SVNClient.RepositoryPath, BookMark.BaseNode.FullPath));
    end;

  ConfigObj.Flush;
end;

procedure TfMain.LoadBookmarks;
var
  st: TStringList;
  i: integer;
  item: TFileTreeNode;
begin
  st := TStringList.Create;
  tvBookMark.Items[0].DeleteChildren;
  ConfigObj.ReadStrings('Repositories/Path', St);
  for i := 0 to st.Count -1 do
    begin
      item := TFileTreeNode(tvBookMark.Items.AddChild(tvBookMark.Items[0], st[i]));
      item.FullPath:= st[i];
      item.ImageIndex:= 5;
      item.StateIndex:= 5;
      item.HasChildren:=true;
      item.BaseNode := item;
    end;
  tvBookMark.Items[0].Expand(False);
  st.free;
end;

procedure TfMain.FormCreate(Sender: TObject);
var
  st: TStringList;
begin
  LoadBookmarks;

  Filter:=[sisAdded,
           sisConflicted,
           sisDeleted,
           sisExternal,
           sisIgnored,
           sisIncomplete,
           sisMerged,
           sisMissing,
           sisModified,
           sisNone,
           sisNormal,
           sisObstructed,
           sisReplaced,
           sisUnversioned];

  ConfigToMap;

  SVNClient := TSVNClient.Create();
  SVNClient.OnSVNMessage := @log;
  SVNClient.SVNExecutable := ConfigObj.ReadString('SVN/Executable', SVNClient.SVNExecutable);
  SVNClient.List.SortItem := SavedSortItem;
  SVNClient.List.SortDirection := SavedSortDirection;
  SVNClient.OnBeginProcess := @BeginProcess;
  SVNClient.OnEndProcess := @endProcess;
  SVNClient.FlatMode := actFlatMode.Checked;

  SetColumn(SVNFileListView, 0, 25, '', False, taLeftJustify);
  SetColumn(SVNFileListView, 1, 100, rsName, true, taLeftJustify);
  SetColumn(SVNFileListView, 2, 180, rsPath, true, taLeftJustify);
  SetColumn(SVNFileListView, 3, 75, rsRevision, True, taRightJustify);
  SetColumn(SVNFileListView, 4, 75, rsCommitRevision, True, taRightJustify);
  SetColumn(SVNFileListView, 9, 100, rsFileStatus, True, taLeftJustify);
  SetColumn(SVNFileListView, 5, 75, rsAuthor, True, taLeftJustify);
  SetColumn(SVNFileListView, 6, 75, rsDateModified, True, taRightJustify);
  SetColumn(SVNFileListView, 7, 75, rsExtension, True, taLeftJustify);
  SetColumn(SVNFileListView, 8, 75, rsDateSVN, True, taRightJustify);
  SetColumn(SVNFileListView, 10, 125, rsPropertyStatus, True, taLeftJustify);

  UpdateFilesListView;

  ConfigObj.Flush;

end;

procedure TfMain.Log (Sender: TObject; const SVNMessageKind: TRunnerMessageKind; const Message: string);
begin

  if SVNMessageKind = ieCommand then
    DebugLn(Message)
  else
    Memo1.Lines.Add(Message);

end;

procedure TfMain.GetSelectedElements(Elements: Tstrings);
var
  i: integer;
begin
  Elements.Clear;
  if (ActiveControl = tvBookMark) and Assigned(tvBookMark.Selected) then
    Elements.Add(TFileTreeNode(tvBookMark.Selected).FullPath);

  if ActiveControl = SVNFileListView then
    for i := 0 to SVNFileListView.Items.Count -1 do
       if SVNFileListView.Items[i].Selected then
         Elements.AddObject(CreateRelativePath(TSVNItem(SVNFileListView.Items[i].Data).Path,
                                               SVNClient.RepositoryPath,  false),
                            TSVNItem(SVNFileListView.Items[i].Data));

end;

procedure TfMain.actUpdateExecute(Sender: TObject);
var
  Upd: TfUpdate;
  Elements: TstringList;
begin

  Upd := TfUpdate.Create(self);
  try
    if Upd.ShowModal = mrOK then
      begin
        Elements := TStringList.Create;
        try
          GetSelectedElements(Elements);
          if not (upd.cbLatest.Checked) and (trim(Upd.eRevision.text) <> EmptyStr) then
            SVNClient.Update(Elements, Upd.eRevision.text)
          else
            SVNClient.Update(Elements);

        finally
          Elements.free;
        end;
      end;
  finally
    Upd.Free;
  end;
  actRefresh.Execute;

end;

procedure TfMain.actUpgradeExecute(Sender: TObject);
begin
  SVNClient.Upgrade;
  actRefresh.Execute;
end;

procedure TfMain.actCommitExecute(Sender: TObject);
var
  Cmt: TfCommit;
  Elements: TStringList;
  i: integer;
begin

  Cmt := TfCommit.Create(self);
  try
    Elements := TStringList.Create;
    GetSelectedElements(Elements);
    Cmt.CheckListBox1.Items.Assign(Elements);
    for i := 0 to Cmt.CheckListBox1.Count -1 do
       Cmt.CheckListBox1.Checked[i] := True;

    if Cmt.ShowModal = mrOK then
      begin
        try
          Elements.Clear;
          for i := 0 to Cmt.CheckListBox1.Count -1 do
             if Cmt.CheckListBox1.Checked[i] then
               Elements.Add(Cmt.CheckListBox1.Items[i]);

          SVNClient.Commit(Elements, Cmt.mLogMessage.Text, true);
        finally
          Elements.free;
        end;
      end;
  finally
    Cmt.Free;
  end;
  actRefresh.Execute;
end;

procedure TfMain.actDiffBASEExecute(Sender: TObject);
begin
  Rundiff('', REV_BASE);
end;

procedure TfMain.actDiffExecute(Sender: TObject);
var
  theForm: TfDiff;
begin
  theForm := TfDiff.Create(Self);
  Theform.ShowModal;
  if theForm.ModalResult = mrOK then
    Rundiff(theForm.GetselectedRevision(1),theForm.GetselectedRevision(2));

  theForm.Free;

end;

procedure TfMain.actAddExecute(Sender: TObject);
var
  Elements: TstringList;
begin

  Elements := TStringList.Create;
  try
    GetSelectedElements(Elements);
    SVNClient.Add(Elements);
  finally
    Elements.free;
  end;

  actRefresh.Execute;


end;

procedure TfMain.actAnnotateExecute(Sender: TObject);
var
  RList: TSVNAnnotateList;
  Elements: TstringList;
  Theform: TfAnnotate;
begin
  Elements := TStringList.Create;
  try
    GetSelectedElements(Elements);

    RList := SVNClient.Annotate(SVNClient.FullFileName(Elements[0]));
    if RList.Count = 0 then
      begin
        RList.Free;
        exit;
      end;
    Theform := TfAnnotate.Create(Self);
    Theform.List := RList;
    Theform.Show;
    RList.Free;
  finally
    Elements.free;
  end;

end;

procedure TfMain.actBookMarkAddExecute(Sender: TObject);
var
  path: TFilename;
  st: TStringList;
  i: integer;
begin
//
  if not SelectDirectoryDialog.Execute then
    exit;

  path:= SelectDirectoryDialog.FileName;

  st := TStringList.Create;
  try
    ConfigObj.ReadStrings(CFG_BookMark, St);
    st.Add(path);
    ConfigObj.WriteStrings(CFG_BookMark, St);
  finally
    st.free;
  end;

  LoadBookmarks;

end;

procedure TfMain.actBookMarkCheckoutExecute(Sender: TObject);
var
  theForm : TfAddRepository;
  St: TstringList;
begin
  theForm:= TfAddRepository.create(application);
  try
  if theForm.ShowModal = mrOK then
    begin
      SVNClient.CheckOut(theForm.leRepositoryURL.Text, theForm.DirectoryEdit.Text, '');
      st := TStringList.Create;
      try
        ConfigObj.ReadStrings(CFG_BookMark, St);
        st.Add(theForm.DirectoryEdit.Text);
        ConfigObj.WriteStrings(CFG_BookMark, St);
      finally
        st.free;
      end;
      LoadBookmarks;
    end;

  finally
    theForm.Free;
  end;
end;

procedure TfMain.actCleanupExecute(Sender: TObject);
begin
  SVNClient.CleanUp;
  actRefresh.Execute;
end;


procedure TfMain.actAboutExecute(Sender: TObject);
var
  theForm : TfAbout;
begin
  theForm:= TfAbout.create(application);
  theForm.ShowModal;
end;

procedure TfMain.actFlatModeExecute(Sender: TObject);
begin
  SVNClient.FlatMode:= actFlatMode.Checked;
  UpdateFilesListView;
end;


procedure TfMain.Rundiff(const Rev1, Rev2:string);
var
  Elements: TstringList;
  TempName1, TempName2: string;
  i: integer;
begin
  Elements := TStringList.Create;
  GetSelectedElements(Elements);
  try
   For i := 0 to Elements.Count -1 do
     begin
       if Rev1 = EmptyStr then
         TempName1:= SVNClient.FullFileName(Elements[i])
       else
         TempName1 := SVNClient.Export(SVNClient.FullFileName(Elements[i]), Rev1);

       if Rev2 = EmptyStr then
         TempName2:= SVNClient.FullFileName(Elements[i])
       else
         TempName2:= SVNClient.Export(SVNClient.FullFileName(Elements[i]), Rev2);

       RunExternal(CFG_Diff,[TempName1, TempName2]);
     end;
  finally
    Elements.free;
  end;

end;

procedure TfMain.actDiffHEADExecute(Sender: TObject);
begin
  Rundiff(EmptyStr, REV_HEAD);
end;

procedure TfMain.ActionListUpdate(AAction: TBasicAction; var Handled: Boolean);
var
  Elements: TstringList;
  i: integer;
  cnt: array [TSVNItemStatus] of integer;
begin

  Elements := TStringList.Create;
  FillByte(Cnt, SizeOf(cnt),0);
  try
    GetSelectedElements(Elements);
    for i := 0 to Elements.Count - 1 do
      if Assigned(Elements.Objects[i]) then
        inc(cnt[TSVNItem(Elements.Objects[i]).ItemStatus]);

    actAdd.Enabled:= cnt[sisUnversioned] = Elements.Count;
    actLog.Enabled:= (Elements.Count = 1) and (cnt[sisUnversioned] = 0);
    actDiffHEAD.Enabled:= cnt[sisUnversioned] = 0;

  finally
    Elements.free;
  end;


end;

procedure TfMain.actLogExecute(Sender: TObject);
var
  RList: TSVNLogList;
  Elements: TstringList;
  TheLog: TfLog;
begin
  Elements := TStringList.Create;
  try
    GetSelectedElements(Elements);

    RList := SVNClient.log(SVNClient.FullFileName(Elements[0]));
    if RList.Count = 0 then
      begin
        RList.Free;
        exit;
      end;
    TheLog := TfLog.Create(self);
    TheLog.CurrentFile := SVNClient.FullFileName(Elements[0]);
    TheLog.List := RList;
    TheLog.ShowModal;
    RList.Free;
  finally
    Elements.free;
  end;

end;

procedure TfMain.actMarkResolvedExecute(Sender: TObject);
var
  Elements: TstringList;
begin

  Elements := TStringList.Create;
  try
    GetSelectedElements(Elements);
    SVNClient.Resolve(Elements);
  finally
    Elements.free;
  end;
  actRefresh.Execute;

end;

procedure TfMain.actRefreshExecute(Sender: TObject);
begin
  SVNClient.LoadStatus;
  UpdateFilesListView;
end;

procedure TfMain.actRevertExecute(Sender: TObject);
var
  Elements: TstringList;
begin

  Elements := TStringList.Create;
  try
    GetSelectedElements(Elements);
    SVNClient.Revert(Elements);
  finally
    Elements.free;
  end;
  actRefresh.Execute;

end;

procedure TfMain.UpdateFilter(Reload: boolean);
begin
  if actShowConflict.Checked then
    Filter:=Filter + [sisConflicted]
  else
    Filter:=Filter - [sisConflicted];

  if actShowModified.Checked then
    Filter:=Filter + [sisAdded, sisDeleted, sisConflicted, sisModified]
  else
    Filter:=Filter - [sisAdded, sisDeleted, sisConflicted, sisModified];

  if actShowUnmodified.Checked then
    Filter:=Filter + [sisNormal]
  else
    Filter:=Filter - [sisNormal];

  if actShowUnversioned.Checked then
    Filter:=Filter + [sisUnversioned]
  else
    Filter:=Filter - [sisUnversioned];

  if Reload then
    UpdateFilesListView;

end;

procedure TfMain.actShowConflictExecute(Sender: TObject);
begin
  actShowConflict.Checked := not actShowConflict.Checked;
  UpdateFilter;
end;

procedure TfMain.actShowModifiedExecute(Sender: TObject);
begin
  actShowModified.Checked := not actShowModified.Checked;
  UpdateFilter;
end;

procedure TfMain.actShowUnmodifiedExecute(Sender: TObject);
begin
  actShowUnmodified.Checked := not actShowUnmodified.Checked;
  UpdateFilter;
end;

procedure TfMain.actShowUnversionedExecute(Sender: TObject);
begin
  actShowUnversioned.Checked := not actShowUnversioned.Checked;
  UpdateFilter;
end;

procedure TfMain.FormDestroy(Sender: TObject);
begin
  MapToConfig;
  SVNClient.Free;
end;

procedure TfMain.FormShow(Sender: TObject);
begin
  Height := ConfigObj.ReadInteger('FormState/Height', Height);
  Width := ConfigObj.ReadInteger('FormState/Width', Width);
  Top := ConfigObj.ReadInteger('FormState/Top', Top);
  Left := ConfigObj.ReadInteger('FormState/Left', Left);


end;

procedure TfMain.mnuPreferencesClick(Sender: TObject);
var
  TheForm: TfConfig;
begin
  TheForm := TfConfig.Create(Self);
  try
    TheForm.ShowModal;
    if TheForm.ModalResult = mrOK then
      ConfigObj.Flush;
  finally
    TheForm.Free;
  end;

end;

procedure TfMain.SVNFileListViewColumnClick(Sender: TObject; Column: TListColumn
  );
begin
  case Column.Index of
    0: SVNClient.List.ReverseSort(siChecked);
    1: SVNClient.List.ReverseSort(siName);
    2: SVNClient.List.ReverseSort(siPath);
    3: SVNClient.List.ReverseSort(siRevision);
    4: SVNClient.List.ReverseSort(siCommitRevision);
    5: SVNClient.List.ReverseSort(siAuthor);
    6: SVNClient.List.ReverseSort(siDateModified);
    7: SVNClient.List.ReverseSort(siExtension);
    8: SVNClient.List.ReverseSort(siDateSVN);
    9: SVNClient.List.ReverseSort(siItemStatus);
   10: SVNClient.List.ReverseSort(siPropStatus);
  end;

  UpdateFilesListView;
end;

procedure TfMain.SVNFileListViewData(Sender: TObject; Item: TListItem);
var
  StatusItem : TSVNItem;
  Path: string;
  imgidx: integer;
begin
  StatusItem := SVNClient.List.Items[item.index];

end;


procedure TfMain.SVNFileListViewDblClick(Sender: TObject);
var
  Elements: TstringList;
  CurrentFile: string;

begin
  Elements := TStringList.Create;
  try
    GetSelectedElements(Elements);
    CurrentFile:= SVNClient.FullFileName(Elements[0]);
    if (Elements.Count = 1) then
      begin
        if DirectoryExists(CurrentFile) then
          SelectSubDir(CurrentFile)
        else
          if FileExists(CurrentFile) then
            RunExternal(CFG_Editor, [CurrentFile]);
      end;

  finally
    Elements.free;
  end;
  actRefresh.Execute;

end;

procedure TfMain.SVNFileListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Assigned(Item.Data) then
    TSVNItem(Item.Data).Selected := Selected;

end;

procedure TfMain.LoadTree(Node: TTreeNode; BasePath: string);
var
  St:TstringList;
  i: integer;
  NewNode: TFileTreeNode;
begin
  St:= TStringList.Create;
  BuildFolderList(IncludeTrailingPathDelimiter(BasePath) , St, false);
  For i := 0 to St.Count-1 do
    begin
      NewNode := TFileTreeNode(Node.Owner.AddChild(Node, CreateRelativePath(St[i], BasePath, false)));
      if NewNode.Text = '' then
        NewNode.Text:= '.';
      NewNode.BaseNode := TFileTreeNode(node).BaseNode;
      NewNode.FullPath:= St[i];
      NewNode.ImageIndex:= 18;
      NewNode.StateIndex:= 18;
      NewNode.SelectedIndex:= 57;
      if Assigned(SVNClient.List.LocateByPath(St[i])) then
        LoadTree(NewNode, St[i]);
    end;
  st.free;

end;

procedure TfMain.tvBookMarkClick(Sender: TObject);
begin
  ExpandNode(tvBookMark.Selected);
end;

procedure TfMain.SelectSubDir(Subdir: string);
var
  i: integer;
begin
  for i := 0  to tvBookMark.Selected.Count -1 do
    begin
      if TFileTreeNode(tvBookMark.Selected.Items[i]).FullPath = Subdir then
        begin
          tvBookMark.Select(tvBookMark.Selected.Items[i]);
          ExpandNode(tvBookMark.Selected);
        end;
    end;

end;


procedure TfMain.ExpandNode(Node: TTreeNode);
Var
  BookMark: TFileTreeNode;
  i: integer;
begin
  if not Assigned(Node) then
      exit;

  BookMark := TFileTreeNode(Node);
  if BookMark.AbsoluteIndex = 0 then  exit;

  if (BookMark.Level = 1) and (BookMark.Count = 0) then
    begin
      SVNClient.RepositoryPath := BookMark.FullPath;
      BookMark.DeleteChildren;
      LoadTree(BookMark, BookMark.Text);
    end
  else
    SVNClient.RepositoryPath := BookMark.FullPath;

  UpdateFilesListView;

end;

procedure TfMain.tvBookMarkCreateNodeClass(Sender: TCustomTreeView;
var NodeClass: TTreeNodeClass);
begin
  NodeClass := TFileTreeNode;
end;

procedure TfMain.tvBookMarkExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  tvBookMark.Select(Node);
  ExpandNode(Node);

end;

procedure TfMain.SetColumn(ListView: TListView; ColNo, DefaultWidth: integer;
  AName: string; ColAutoSize: boolean; Alignment: TAlignment);
begin
  ListView.Column[ColNo].Caption:=AName;
  ListView.Column[ColNo].AutoSize:=ColAutoSize;
  ListView.Column[ColNo].Width:=DefaultWidth;
  ListView.Column[ColNo].Alignment:=Alignment;
end;

procedure TfMain.BeginProcess(Sender: TObject);
begin
  Screen.Cursor:= crHourGlass;
  Application.ProcessMessages;

end;

procedure TfMain.EndProcess(Sender: TObject);
begin
  Screen.Cursor:= crDefault;
  Application.ProcessMessages;

end;

end.

