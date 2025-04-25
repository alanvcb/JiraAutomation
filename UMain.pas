unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,System.JSON,
  Vcl.ComCtrls,REST.Client, REST.Types, UTask;


type
  TForm1 = class(TForm)
    pgcJira: TPageControl;
    tshProjects: TTabSheet;
    Projetos: TButton;
    mmResultProjects: TMemo;
    pnlTop: TPanel;
    edtEmail: TLabeledEdit;
    edtToken: TLabeledEdit;
    tshTask: TTabSheet;
    edtProjectID: TLabeledEdit;
    edtEpicSummary: TLabeledEdit;
    edtEpicDescript: TLabeledEdit;
    Button1: TButton;
    edtTaskParent: TLabeledEdit;
    rgTaskType: TRadioGroup;
    edtTaskKey: TLabeledEdit;
    edtTaskID: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure ProjetosClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure rgTaskTypeClick(Sender: TObject);
  private
    procedure CreateRest(out ARESTClient: TRESTClient;
                        out ARESTRequest: TRESTRequest;
                        out ARESTResponse: TRESTResponse;
                        const AEmail, AToken: string);

    function CreateJsonObject(Pairs: array of TJSONPair): TJSONObject;
    procedure ListJiraProjects(AEmail,AToken: string);
    function CreateJiraTask(AEmail,AToken: String;ATask:TTask): TTask;
    procedure ListIssueTypes(AEmail,AToken,AProjectKey: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses System.NetEncoding,REST.Authenticator.Basic;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var task: TTask;
begin
  task := TTask.Create;
  task.ProjectKey := edtProjectID.Text;
  task.Sumarry := edtEpicSummary.Text;
  if rgTaskType.ItemIndex = 1 then
  begin
    task.Parent := edtTaskParent.Text;
    task.IssueType := TTypeTask.Task;
  end
  else
    task.IssueType := TTypeTask.Epic;

  task.Description := edtEpicDescript.Text;

  task := CreateJiraTask(edtEmail.Text,edtToken.Text,task);

  edtTaskKey.Text := task.Key;
  edtTaskID.Text := task.ID.ToString;

end;

function TForm1.CreateJiraTask(AEmail, AToken: String;ATask:TTask) : TTask;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  Authenticator: THTTPBasicAuthenticator;
  JSONBody, JSONFields, JSONProject, JSONIssueType,JsonDescript,JsonParent: TJSONObject;
  JSONResponse: TJSONObject;
  JsonContent1,JsonContent2: TJSONArray;
begin
  Result := nil;
  try
    // Configura o cliente REST
    CreateRest(RESTClient,RESTRequest,RESTResponse,AEmail,AToken);
    RESTClient.BaseURL := 'https://gdksoftware.atlassian.net/rest/api/3/issue';
    RESTRequest.Method := TRESTRequestMethod.rmPOST;

    JSONBody := TJSONObject.Create;
    JSONFields := TJSONObject.Create;
    JSONProject := TJSONObject.Create;
    JSONIssueType := TJSONObject.Create;
    JsonParent := nil;
    try
      // Configura o projeto
      JSONProject.AddPair('key', ATask.ProjectKey); // Substitua 'PROJ' pela chave do projeto

      // Configura o tipo de issue (Epic)
      case ATask.IssueType of
        TTypeTask.Epic: JSONIssueType.AddPair('name', 'Epic');
        TTypeTask.Task:
        begin
          JSONIssueType.AddPair('name', 'Task');
          if ATask.Parent <> '' then
            JsonParent := TJSONObject.Create(TJSONPair.Create('key',ATask.Parent))
        end;
      end;
//
      JSONFields.AddPair('issuetype', JSONIssueType);

      // Configura os campos da issue
      JSONFields.AddPair('project', JSONProject);
      JSONFields.AddPair('summary',ATask.Sumarry); // Título do Epic

      JsonContent2 := TJSONArray.Create(CreateJsonObject([TJSONPair.Create('type','text'),
                                                          TJSONPair.Create('text',ATask.Description)]));
      JsonContent1 := TJSONArray.Create(
      CreateJsonObject([TJSONPair.Create('type','paragraph'),
                        TJSONPair.Create('content',JsonContent2)]));

      JsonDescript := CreateJsonObject([TJSONPair.Create('type','doc'),
                                        TJSONPair.Create('version',1),
                                        TJSONPair.Create('content',JsonContent1)]);

      JSONFields.AddPair('description', JsonDescript); // Descrição do Epic
      if Assigned(JsonParent) then
        JSONFields.AddPair('parent',JsonParent);


      // Adiciona os campos ao corpo da requisição
      JSONBody.AddPair('fields', JSONFields);

      // Define o corpo da requisição
      RESTRequest.AddBody(JSONBody.ToString, TRESTContentType.ctAPPLICATION_JSON);
    finally
    end;

    // Executa a requisição
    RESTRequest.Execute;

    // Verifica se a requisição foi bem-sucedida
    if RESTResponse.StatusCode = 201 then
    begin
      // Processa a resposta JSON
      JSONResponse := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
      try
        Result := ATask;
        Result.Key := JSONResponse.GetValue('key').Value;
        Result.ID := JSONResponse.GetValue('id').Value.ToInteger;
      finally
        JSONResponse.Free;
      end;
    end
    else
      Raise Exception.Create('Erro : '+RESTResponse.Content);
  finally
    // Libera os objetos
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
    Authenticator.Free;
  end;
end;


function TForm1.CreateJsonObject(Pairs: array of TJSONPair): TJSONObject;
begin
  Result := TJSONObject.Create;
  for var I := Low(Pairs) to High(Pairs) do
    Result.AddPair(Pairs[i]);
end;

procedure TForm1.CreateRest(out ARESTClient: TRESTClient;
  out ARESTRequest: TRESTRequest; out ARESTResponse: TRESTResponse;
  const AEmail, AToken: string);
var Authenticator: THTTPBasicAuthenticator;
begin
  ARESTClient := TRESTClient.Create(nil);
  ARESTRequest := TRESTRequest.Create(nil);
  ARESTResponse := TRESTResponse.Create(nil);
  Authenticator := THTTPBasicAuthenticator.Create(nil);

  ARESTRequest.Client := ARESTClient;
  ARESTRequest.Response := ARESTResponse;

  Authenticator.Username := AEmail;
  Authenticator.Password := AToken;
  ARESTClient.Authenticator := Authenticator;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
//
end;

procedure TForm1.ListIssueTypes(AEmail, AToken, AProjectKey: string);
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  Authenticator: THTTPBasicAuthenticator;
  JSONArray: TJSONArray;
  JSONValue: TJSONValue;
  ProjetoID, ProjetoNome, ProjetoChave: string;
begin
  try
    CreateRest(RESTClient,RESTRequest,RESTResponse,AEmail,AToken);
    RESTClient.BaseURL := 'https://gdksoftware.atlassian.net/rest/api/3/issue/createmeta/'+AProjectKey+'/issuetypes';
    RESTRequest.Method := TRESTRequestMethod.rmGET;

    RESTRequest.Execute;

    if RESTResponse.StatusCode = 200 then
    begin
      mmResultProjects.Text := RESTResponse.JSONText;
    end;

  finally
    // Libera os objetos
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
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
  try
    CreateRest(RESTClient,RESTRequest,RESTResponse,AEmail,AToken);
    RESTClient.BaseURL := 'https://gdksoftware.atlassian.net/rest/api/3/project';
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
  ListIssueTypes(edtEmail.Text,edtToken.Text,'TJA');
end;

procedure TForm1.rgTaskTypeClick(Sender: TObject);
begin
  edtTaskParent.Enabled := rgTaskType.ItemIndex = 1;
end;

end.
