unit UTask;

interface

{$SCOPEDENUMS ON}

type TTypeTask = (Epic,Task);


TTask = class
  private
    FKey: string;
    FProjectKey: string;
    FSumarry: string;
    FParent: string;
    FID: Integer;
    FDescription: string;
    FIssueType: TTypeTask;
  published
    property Sumarry : string read FSumarry write FSumarry;
    property Description: string read FDescription write FDescription;
    property ProjectKey: string read FProjectKey write FProjectKey;
    property IssueType : TTypeTask read FIssueType write FIssueType;
    property Parent: string read FParent write FParent;
    property Key: string read FKey write FKey;
    property ID: Integer read FID write FID;

end;

implementation

{ TTask }



end.
