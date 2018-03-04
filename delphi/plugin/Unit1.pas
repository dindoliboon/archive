unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Plugin1: TMenuItem;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadPlugIns;
    procedure FreePlugIns;
    procedure PlugInClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

var
	Plugins: TList;

type
  //plug in object
	TTestPlugIn = class
  	Name: String;
    Address: Integer;
    Call: Pointer;
  end;

  //type cast of plug in functions
  GetNameFunction = function : PChar;
  InserText = procedure;
  //HInstance is the application's histance, send it to the
  //plugin so it can use the exports function from here.
	PlugInInit = procedure (Owner: Integer);

var
	StopSearch: Boolean;
  
procedure SearchFileExt(const Dir, Ext: String; Files: TStrings);
var
	Found: TSearchRec;
  Sub: String;
  i : Integer;
  Dirs: TStrings; //Store sub-directories
  Finished : Integer; //Result of Finding
begin
	StopSearch := False;
	Dirs := TStringList.Create;
	Finished := FindFirst(Dir + '*.*', 63, Found);
  while (Finished = 0) and not (StopSearch) do
  begin
  	//Check if the name is valid.
  	if (Found.Name[1] <> '.') then
 		begin
    //Check if file is a directory
    	if (Found.Attr and faDirectory = faDirectory) then
      	Dirs.Add(Dir + Found.Name)  //Add to the directories list.
    	else
   			if Pos(UpperCase(Ext), UpperCase(Found.Name))>0 then
      		Files.Add(Dir + Found.Name);
    end;
		Finished := FindNext(Found);
  end;
  //end the search process.
  FindClose(Found);
  //Check if any sub-directories found
	if not StopSearch then
  	for i := 0 to Dirs.Count - 1 do
    	//If sub-dirs then search agian ~>~>~> on and on, until it is done.
			SearchFileExt(Dirs[i], Ext, Files);

  //Clear the memories.
  Dirs.Free;
end;


{$R *.DFM}
procedure TForm1.LoadPlugIns;
var
	Files: TStrings;
  i: Integer;
  TestPlugIn : TTestPlugIn;
  NewMenu: TMenuItem;
begin
	Files := TStringList.Create;
  Plugins := TList.Create;
  //Search what ever is in the app's dir
	SearchFileExt(ExtractFilepath(Application.Exename) + '\', '.dll', Files);
	for i := 0 to Files.Count-1 do
  begin
  	//create a new plug in
    TestPlugIn := TTestPlugIn.Create;
		TestPlugIn.Address := LoadLibrary(PChar(Files[i]));
    //Initialize the plugin give your app instance (and the handle if necessary)
    PlugInInit(GetProcAddress(TestPlugIn.Address, 'Init'))(HInstance);
    //get the a menu item
    TestPlugIn.Name := GetNameFunction(GetProcAddress(TestPlugIn.Address, 'GetName'));
    //get the function insert text
    TestPlugIn.Call := GetProcAddress(TestPlugIn.Address, 'InsertText');
    PlugIns.Add(TestPlugIn);
		//add the plug menu item
    NewMenu := TMenuItem.Create(Self);
    NewMenu.Caption := TestPlugIn.Name;
    NewMenu.OnClick := PlugInClick;
    NewMenu.Tag := i;
    PlugIn1.Add(NewMenu);
  end;
  Files.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
	LoadPlugIns;
end;

procedure TForm1.PlugInClick(Sender: TObject);
begin
	//call the typecasted function InsertTtext
	InserText(TTestPlugIn(PlugIns[TMenuItem(Sender).Tag]).Call);
end;

procedure TForm1.FreePlugIns;
var
	i: Integer;
begin
	for i := 0 to PlugIns.Count-1 do
  begin
    //Run finalize function in the plugin before you unload it.
    //Because it is not applicable here so it is ignored.
  	//free every loaded plugins
  	FreeLibrary(TTestPlugIn(PlugIns[i]).Address);
  end;
	PlugIns.Free;
end;

end.
