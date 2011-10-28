unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  sSkinManager,ShellAPI, IniFiles , sSkinProvider, CategoryButtons, ExtCtrls,
  ImgList, acAlphaImageList , imagelistfix, Commctrl, ShlObj, ToolWin, ComCtrls,
  StdCtrls, sComboBox, rEGISTRY, sCheckBox, sButton, Menus, ActnList, ExtActns,
  PlatformDefaultStyleActnCtrls, ActnMan;

type
  TForm1 = class(TForm)
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    imagenes: TsAlphaImageList;
    CategoryPanelGroup1: TCategoryPanelGroup;
    CategoryPanel1: TCategoryPanel;
    CategoryPanel2: TCategoryPanel;
    Splitter1: TSplitter;
    sCheckBox2: TsCheckBox;
    GroupBox1: TGroupBox;
    sComboBox1: TsComboBox;
    sComboBox2: TsComboBox;
    sCheckBox1: TsCheckBox;
    sButton1: TsButton;
    PopupMenu1: TPopupMenu;
    Showoptions1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    TrayIcon1: TTrayIcon;
    About1: TMenuItem;
    N2: TMenuItem;
    PopupMenu2: TPopupMenu;
    AddProgram2: TMenuItem;
    Panel: TCategoryButtons;
    OpenDialog1: TOpenDialog;
    RemoveSeccion1: TMenuItem;
    UpdateSeccion1: TMenuItem;
    N3: TMenuItem;
    aD1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure sComboBox1Exit(Sender: TObject);
    procedure sComboBox2Exit(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure Showoptions1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure sCheckBox2Click(Sender: TObject);
    procedure PanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AddProgram2Click(Sender: TObject);
    procedure RemoveSeccion1Click(Sender: TObject);
    procedure UpdateSeccion1Click(Sender: TObject);
    procedure aD1Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PROCEDURE LOAD_INFO();
    PROCEDURE OPEN_FILE(NAME,CAT:STRING);
  end;

var
  Form1: TForm1;
  Ini: Tinifile;

implementation

{$R *.dfm}


procedure AddEntryToRegistry;
var key: string;
     Reg: TRegIniFile;
begin
  key := '\Software\Microsoft\Windows\CurrentVersion\Run';
  Reg := TRegIniFile.Create;
  try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    Reg.CreateKey(Key);
    if Reg.OpenKey(Key,False) then Reg.WriteString(key, '3JTOOLBOXDEVELOPER', Application.ExeName  );
  finally
    Reg.Free;
  end;
end;

procedure RemoveEntryFromRegistry;
var key: string;
     Reg: TRegIniFile;
begin
  key := '\Software\Microsoft\Windows\CurrentVersion\Run';
  Reg:=TRegIniFile.Create;
try
  Reg.RootKey:=HKey_Local_Machine;
  if Reg.OpenKey(Key,False) then Reg.DeleteValue('3JTOOLBOXDEVELOPER');
  finally
  Reg.Free;
  end;
end;

function IsStrANumber(const S: string): Boolean;
var
  P: PChar;
begin
  P      := PChar(S);
  Result := False;
  while P^ <> #0 do
  begin
    if not (P^ in ['0'..'9']) then Exit;
    Inc(P);
  end;
  Result := True;
end;

function IsMouseButtonDown(Left: Boolean): Boolean;
begin
  if Left then
    Result := GetKeyState(VK_LBUTTON) <> 0
  else
    Result := GetKeyState(VK_RBUTTON) <> 0;
end;


PROCEDURE TForm1.OPEN_FILE(NAME,CAT:STRING);
  var
  current_url:string;
begin
  //si es click izquierdo
    current_url:=ini.ReadString(cat,name,'');
    if  FileExists(current_url) then
    begin
    ShellExecute(0, 'Open', PChar(current_url), PChar(''), PChar(''), SW_NORMAL);
    end else
    ShowMessage('Error:the file does not exist');
end;



procedure TForm1.PanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var
  cat,name:string;
  CONTINUA:Boolean;
  temp:TButtonCategory;
begin
     CONTINUA:=TRUE;
   TRY
   cat:= Panel.Categories[Panel.GetCategoryAt(x,y).Index].Caption;

   name:= Panel.GetButtonAt( x,y, Panel.GetCategoryAt(x,y) ).Hint;
   EXCEPT
     CONTINUA:=FALSE;
   END;
   if CONTINUA =TRUE then
   BEGIN
        if Button = mbLeft then begin
             OPEN_FILE(name,CAT);
        end
        else
        if Button = mbRight then
        begin
           if OpenDialog1.Execute then  begin
              ini.WriteString(cat,name,OpenDialog1.FileName);
              TRY
              Panel.Categories.Clear;
              imagenes.Clear;
              FINALLY
              LOAD_INFO();
              END;
           end;
          end;
  END;
end;





procedure TForm1.RemoveSeccion1Click(Sender: TObject);
var
  result:string;
  x:integer;
begin
  result:= InputBox('Remove Category','Write the name of the Category','') ;
  if Trim(result) <> ''  then
    begin
       if ini.SectionExists(result) then
       begin
       Ini.EraseSection(result);
       TRY
       Panel.Categories.Clear;
       imagenes.Clear;
      FINALLY
       LOAD_INFO();
       END;
       end else
       ShowMessage('Error, the selected category no exist');
  end;
end;

procedure TForm1.sButton1Click(Sender: TObject);
begin
  CategoryPanelGroup1.Hide;
end;

procedure TForm1.sCheckBox2Click(Sender: TObject);
begin
  if sCheckBox2.Checked then
  AddEntryToRegistry else
  RemoveEntryFromRegistry
end;

procedure TForm1.sComboBox1Exit(Sender: TObject);
begin
  try
    if IsStrANumber(sComboBox1.Text) then
        if StrToInt(sComboBox1.Text)<=32  then
          imagenes.Height:= StrToInt(sComboBox1.Text);
  except
  end;
end;

procedure TForm1.sComboBox2Exit(Sender: TObject);
begin
  try
    if IsStrANumber(sComboBox2.Text) then
        if StrToInt(sComboBox2.Text)<=32  then
          imagenes.Height:= StrToInt(sComboBox2.Text);
  except
  end;
end;

procedure TForm1.Showoptions1Click(Sender: TObject);
begin
CategoryPanelGroup1.Show;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
 Form1.Show;
end;

procedure TForm1.UpdateSeccion1Click(Sender: TObject);
var
  result,result2:string;
  x:integer;
begin
  result:= InputBox('Update Category ','Write the name of the Category - THIS WILL ERASE ALL INFO','') ;
  result2:= InputBox('Update Category','Write the NEW name of the Category - THIS WILL ERASE ALL INFO','') ;
  if (Trim(result) <> '') and (Trim(result2) <> '')   then
    begin
       if ini.SectionExists(result) then
       begin
       Ini.EraseSection(result);
       Ini.WriteString(result2,'','');
       TRY
       Panel.Categories.Clear;
       imagenes.Clear;
      FINALLY
       LOAD_INFO();
       END;
       end else
       ShowMessage('Error, the selected category no exist');
  end;
end;


PROCEDURE TForm1.LOAD_INFO();
VAR
  Strings: TStringList;
  I,Y,IconIndex2:integer;
  Button: TButtonCategory;
  colection:TCollection;
  subsections: TStringList;
  subitem: TButtonItem;
  MyIcon: TIcon;
  name,url:string;
  IconIndex:word;
begin
  Strings:=  TStringList.Create;
  subsections:=  TStringList.Create;
  Ini:= Tinifile.Create( ChangeFileExt( application.ExeName , '.INI' ) );
    //READ FIRST CONFI
    try
    if (IsStrANumber(Ini.ReadString('opt','w','32'))) and (StrToInt(Ini.ReadString('opt','w','32'))<=32)
    then
    sComboBox2.Text :=Ini.ReadString('opt','w','32');
    except
    end;
    try
    if (IsStrANumber(Ini.ReadString('opt','h','32'))) and (StrToInt(Ini.ReadString('opt','h','32'))<=32)
    then
    sComboBox1.Text :=Ini.ReadString('opt','h','32');
    except
    end;
    sCheckBox1.Checked:= Ini.ReadBool('opt','s',false);
    sCheckBox2.Checked:= Ini.ReadBool('opt','a',true);
    CategoryPanelGroup1.Visible:= Ini.ReadBool('opt','b',false);

     Top := Ini.ReadInteger('opt','To', form1.Top) ;
     Left := Ini.ReadInteger('opt','Le', form1.Left);
     Width := Ini.ReadInteger('opt','Wi', form1.Width);
     Height := Ini.ReadInteger('opt','He', form1.Height);

    //READ SECTIONS
     Ini.ReadSections(Strings);
     for I:= 0 to Strings.Count-1 do
     begin
        if Strings[I]='opt' then
        begin
        end else begin
          //ADD CATEGORIES
          Button:=  TButtonCategory.Create(panel.Categories);
          Button.Caption := Strings[I];
          panel.Categories.AddItem(Button,panel.Categories.Count-1 );
          //panel.Categories.
          Ini.ReadSectionValues(Strings[I],subsections);
          for Y:=0 to  subsections.Count -1 do
          begin
              //ADD BUTTONS TO CURRENT CATEGORIE
               name:=  Copy( subsections[Y] , 0 , LastDelimiter('=',subsections[Y])-1);
               url:=  Copy( subsections[Y] , LastDelimiter('=',subsections[Y])+1 );
               subitem := Panel.Categories[I-1].ITems.Add;
                subitem.HINT:= name ;
               if sCheckBox1.State= cbChecked then BEGIN
                subitem.Caption:= name ;
               END;
               if FileExists(url) then
                begin
                  MyIcon:= TIcon.Create;
                  MyIcon.Handle:=ExtractAssociatedIcon(hInstance,pchar(url), IconIndex );
                 // MyIcon.SetSize(60,60);
                  //GetIconFromFile(url,MyIcon,SHIL_EXTRALARGE);
                  IconIndex2:= imagenes.AddIcon(MyIcon);
                  subitem.ImageIndex :=IconIndex2;
                end else
                begin
                  subitem.Caption:= 'waiting' ;
                end;
               Button.Items.AddItem(subitem,Button.Items.Count-1);
          end;
          end;
     end;
end;





procedure TForm1.About1Click(Sender: TObject);
begin
  ShowMessage('Created by James Jara, please check for me in google to get more source codes.. also check for InnoSystem Software');
end;


procedure TForm1.aD1Click(Sender: TObject);
var
  result,result2:string;
  x:integer;
begin
  result:= InputBox('Add to Category ','Write of the category parent name of the new program','') ;
  if (Trim(result) <> '')    then
    begin
       if ini.SectionExists(result) then
       begin
       Ini.WriteString(result,'a'+inttostr(Random(9999)),'none');
       TRY
       Panel.Categories.Clear;
       imagenes.Clear;
      FINALLY
       LOAD_INFO();
       END;
       end else
       ShowMessage('Error, the selected category no exist');
  end;
end;

procedure TForm1.AddProgram2Click(Sender: TObject);
var
  result:string;
  Button:TButtonCategory;
begin
  result:= InputBox('Add Category','Name of the new Category','') ;
  if Trim(result) <> ''  then
    begin
       Ini.WriteString(result,'empty','');
       TRY
       Panel.Categories.Clear;
       imagenes.Clear;
      FINALLY
       LOAD_INFO();
       END;
  end;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=false;
  form1.Hide;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  LOAD_INFO();
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
        try
        if (IsStrANumber(sComboBox2.Text)) and (StrToInt(sComboBox2.Text)<=32)
        then
        Ini.WriteString('opt','w', sComboBox2.Text ) else
        Ini.WriteInteger('opt','w', 32 );
        except
        end;
        try
        if (IsStrANumber(sComboBox1.Text)) and (StrToInt(sComboBox1.Text)<=32)  then
        Ini.WriteString('opt','h', sComboBox1.Text ) else
        Ini.WriteInteger('opt','h', 32 );
        except
        end;
        Ini.WriteBool('opt','s', sCheckBox1.Checked );
        Ini.WriteBool('opt','a', sCheckBox2.Checked );
        Ini.WriteBool('opt','b', CategoryPanelGroup1.Visible );

        Ini.WriteInteger('opt','To', form1.Top) ;
        Ini.WriteInteger('opt','Le', form1.Left) ;
        Ini.WriteInteger('opt','Wi', form1.Width) ;
        Ini.WriteInteger('opt','He', form1.Height) ;
end;

end.
