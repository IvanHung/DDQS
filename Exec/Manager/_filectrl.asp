<%
  var sfs = Server.CreateObject("Scripting.FileSystemObject");

  function LoadFromFile(FileName)
  {
    var infile = sfs.OpenTextFile(FileName, 1);
    var AllData = '' + infile.ReadAll();
    infile.Close();
    infile = null;

    return AllData;
  }

  function SaveToFile(FileName, Data)
  {
    var outfile = sfs.OpenTextFile(SysLogFilePath, 8, true);
    outfile.WriteLine('' + Data);
    outfile.Close();
    outfile = null;
  }

  function FileExists(FileName)
  {
    return sfs.FileExists(FileName);
  }

  function FileRename(OldFileName, NewFileName)
  {
    sfs.MoveFile(OldFileName, NewFileName);
    return sfs.FileExists(NewFileName);
  }

  function MkDir(Dir)
  {
    if (!sfs.FolderExists(Dir))
      sfs.CreateFolder(Dir)
  }

  function DirExists(Dir)
  {
    return sfs.FolderExists(Dir);
  }

  function DeleteFile(FileName)
  {
    try
    {
      sfs.DeleteFile(FileName, true);
    }
    catch (e)
    {
    }
  }

  function ExtractFileName(filespec)
  {
    return '' + sfs.GetFileName(filespec);
  }

  function ExtractFileExtName(filespec)
  {
    return '' + sfs.GetExtensionName(filespec);
  }

  function ExtractFilePath(path)
  {
    return '' + sfs.GetParentFolderName(path);
  }

  function ToRealFilePath(path)
  {
    if (path.substring(path.length - 1, 1) != '/')
      path = path + '/';

    return (Server.MapPath(path));
  }

  function CurrentUrl()
  {
    return (Request.ServerVariables("URL"));
  }

  function GetRealPath()
  {
    return '' + ToRealFilePath(ExtractFilePath(CurrentUrl()));
  }

  function GetDirFileList(dir)
  {
    var RetFileArray = new Array();

    var fso, f, fc, s;

    fso = new ActiveXObject("Scripting.FileSystemObject");

    f = fso.GetFolder(dir);
    fc = new Enumerator(f.files);

    var tt;

    for (var i=0; !fc.atEnd(); fc.moveNext())
    {
      s = "" + fc.item();
      FileName = ExtractFileName(s);
      RetFileArray[i++] = FileName;
    }

    return (RetFileArray);
  }
%>