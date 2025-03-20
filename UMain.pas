unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.ComCtrls;


type
  TForm1 = class(TForm)
    pgcJira: TPageControl;
    tshProjects: TTabSheet;
    Projetos: TButton;
    mmResultProjects: TMemo;
    pnlTop: TPanel;
    edtEmail: TLabeledEdit;
    edtToken: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure ProjetosClick(Sender: TObject);
  private
    procedure ListJiraProjects(AEmail,AToken: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses REST.Client, REST.Types, System.JSON,System.NetEncoding,REST.Authenticator.Basic;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
//
end;

procedure TForm1.ListJiraProjects(AEmail,AToken: string);
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  Authenticator: THTTPBasicAuthenticator;
  JSONArray: TJSONArray;
  JSONValue: TJSONValue;
  ProjetoID, ProjetoNome, ProjetoChave: string;
begin
  RESTClient := TRESTClient.Create(nil);
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  Authenticator := THTTPBasicAuthenticator.Create(nil);
  try
    RESTClient.BaseURL := 'https://gdksoftware.atlassian.net/rest/api/3/project';
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;

    Authenticator.Username := AEmail;
    Authenticator.Password := AToken;
    RESTClient.Authenticator := Authenticator;

    RESTRequest.Method := TRESTRequestMethod.rmGET;

    RESTRequest.Execute;

    if RESTResponse.StatusCode = 200 then
    begin
      JSONArray := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONArray;
      try
        for JSONValue in JSONArray do
        begin
          ProjetoID := (JSONValue as TJSONObject).GetValue('id').Value;
          ProjetoNome := (JSONValue as TJSONObject).GetValue('name').Value;
          ProjetoChave := (JSONValue as TJSONObject).GetValue('key').Value;
          mmResultProjects.Lines.Add(Format('ID: %s, Name: %s, Key: %s', [ProjetoID, ProjetoNome, ProjetoChave]));
        end;
      finally
        JSONArray.Free;
      end;
    end
    else
    begin
      mmResultProjects.Lines.Add(Format('Error: %d - %s', [RESTResponse.StatusCode, RESTResponse.StatusText]));
    end;
  finally
    // Libera os objetos
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

procedure TForm1.ProjetosClick(Sender: TObject);
begin
  ListJiraProjects(edtEmail.Text,edtToken.Text);
end;

end.
