(* This program demonstrates how to append a file to an executable.
   Written by Marko Peric (lonewolf@tig.com.au) on the afternoon of 27//11/98 *)

program AppendExe;

uses
  Windows, Classes;

const
  ExeName = 'Extractor.exe';     // the base extractor executable
  FileToAdd = 'HelloWorld.exe';  // the file which we will append to the above

var
  MyFile : TFileStream;
  MyAppend : TMemoryStream;

begin
  (* Create a filestream object for the extractor executable *)
  MyFile := TFileStream.Create(ExeName, $0002{fmOpenReadWrite});
  try
  (* Create a memorystream object for the HelloWorld exe *)
    MyAppend := TMemoryStream.Create;
    try
  (* Fill the memory stream with the HelloWorld exe *)
      MyAppend.LoadFromFile(FileToAdd);
  (* Move the stream pointer to the end of the stream *)
      MyFile.Seek(0, soFromEnd);
  (* Append the HelloWorld exe to the extractor exe *)
      MyFile.CopyFrom(MyAppend, 0);
  (* Indicate success and give further instructions *)
      MessageBox(0, 'Congratulations! The ''Hello, World!'' program was successfully appended.' +
                  #13#10 + 'Now move the Extractor program to a seperate sub-directory, and run it.',
                  'File appended',
                  MB_OK + MB_ICONINFORMATION);
    finally
  (* Free the memorystream *)
      MyAppend.Free;
    end;
  finally
  (* Free the filestream *)
    MyFile.Free;
  end;
end.
