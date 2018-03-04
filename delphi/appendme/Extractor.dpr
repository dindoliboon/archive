program Extractor;

uses
  Windows, Classes, ShellAPI;

const
  FileSize = 60416;           // You may have to change to this number to the size
                              // of the compiled Extractor executable - minus the
                              // appended executable of course
var
  MyExtract : TFileStream;
  MyFile : TMemoryStream;
  FileExe : String;
  Buffer : array[0..260] of Char;

begin
  (* Create the memory stream which will hold a copy of this executable in memory *)
  MyFile := TMemoryStream.Create;
  try
  (* What is the name of this executable? *)
    SetString(FileExe, Buffer, GetModuleFileName(0, Buffer, SizeOf(Buffer)));
  (* Load a copy of the executable into memory *)
    MyFile.LoadFromFile(FileExe);
  (* A filestream which will eventually create the HelloWorld program *)
    MyExtract := TFileStream.Create('HelloWorld.exe', fmCreate);
    try
  (* Move the stream pointer to the start of the appended executable *)
      MyFile.Seek(FileSize, 0);
  (* Copy the appended data to our filestream buffer - this creates the file *)
      MyExtract.CopyFrom(MyFile, MyFile.Size - FileSize);
    finally
  (* Free the filestream object *)
      MyExtract.Free;
    end;
  (* Tell the user that extraction went well and ask if s/he wants to run HelloWorld *)
    if MessageBox(0, 'The ''Hello, World!'' program was successfully extracted.' +
                  #13#10 + 'Would you like to run it now?',
                  'Extraction successful!',
                  MB_YESNO + MB_ICONQUESTION) = IDYES then
  (* Run the extracted executable, HelloWorld.exe *)
      ShellExecute(0, 'open', 'HelloWorld.exe', '', '', SW_SHOW);
  finally
  (* Free the memoerystream object *)
    MyFile.Free;
  end;
end.
