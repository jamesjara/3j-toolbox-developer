unit imagelistfix;

interface

uses CommCtrl, Graphics, ImgList;

type
  TImageListFixer = class(TCustomImageList)
  public
    function AddIcon(Image: TIcon): Integer;
  end;

implementation

function TImageListFixer.AddIcon(Image: TIcon): Integer;
begin
  if Image = nil then
    Result := Add(nil, nil)
  else
  begin
    Result := ImageList_AddIcon(Handle, Image.Handle);
    Change;
  end;
end;

end.

