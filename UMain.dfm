object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 590
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pgcJira: TPageControl
    Left = 0
    Top = 111
    Width = 624
    Height = 479
    ActivePage = tshTask
    Align = alClient
    TabOrder = 0
    object tshProjects: TTabSheet
      Caption = 'Projects'
      object Projetos: TButton
        Left = 3
        Top = 3
        Width = 75
        Height = 25
        Caption = 'List Projects'
        TabOrder = 0
        OnClick = ProjetosClick
      end
      object mmResultProjects: TMemo
        Left = 3
        Top = 34
        Width = 610
        Height = 409
        TabOrder = 1
      end
    end
    object tshTask: TTabSheet
      Caption = 'Task'
      ImageIndex = 1
      object edtProjectID: TLabeledEdit
        Left = 3
        Top = 24
        Width = 142
        Height = 23
        EditLabel.Width = 59
        EditLabel.Height = 15
        EditLabel.Caption = 'Project Key'
        TabOrder = 0
        Text = ''
      end
      object edtEpicSummary: TLabeledEdit
        Left = 3
        Top = 72
        Width = 558
        Height = 23
        EditLabel.Width = 77
        EditLabel.Height = 15
        EditLabel.Caption = 'Task Summary'
        TabOrder = 1
        Text = ''
      end
      object edtEpicDescript: TLabeledEdit
        Left = 3
        Top = 120
        Width = 558
        Height = 23
        EditLabel.Width = 86
        EditLabel.Height = 15
        EditLabel.Caption = 'Task Description'
        TabOrder = 2
        Text = ''
      end
      object Button1: TButton
        Left = 3
        Top = 387
        Width = 75
        Height = 25
        Caption = 'Create Task'
        TabOrder = 3
        OnClick = Button1Click
      end
      object edtTaskParent: TLabeledEdit
        Left = 3
        Top = 224
        Width = 158
        Height = 23
        EditLabel.Width = 60
        EditLabel.Height = 15
        EditLabel.Caption = 'Task Parent'
        TabOrder = 4
        Text = ''
      end
      object rgTaskType: TRadioGroup
        Left = 3
        Top = 149
        Width = 558
        Height = 49
        Caption = 'Task Type'
        Columns = 2
        ItemIndex = 1
        Items.Strings = (
          'Epic'
          'Task')
        TabOrder = 5
        OnClick = rgTaskTypeClick
      end
      object edtTaskKey: TLabeledEdit
        Left = 3
        Top = 296
        Width = 142
        Height = 23
        TabStop = False
        Color = clBtnFace
        EditLabel.Width = 45
        EditLabel.Height = 15
        EditLabel.Caption = 'Task Key'
        ReadOnly = True
        TabOrder = 6
        Text = ''
      end
      object edtTaskID: TLabeledEdit
        Left = 187
        Top = 296
        Width = 142
        Height = 23
        TabStop = False
        Color = clBtnFace
        EditLabel.Width = 37
        EditLabel.Height = 15
        EditLabel.Caption = 'Task ID'
        ReadOnly = True
        TabOrder = 7
        Text = ''
      end
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 111
    Align = alTop
    TabOrder = 1
    object edtEmail: TLabeledEdit
      Left = 7
      Top = 24
      Width = 297
      Height = 23
      EditLabel.Width = 29
      EditLabel.Height = 15
      EditLabel.Caption = 'Email'
      TabOrder = 0
      Text = ''
    end
    object edtToken: TLabeledEdit
      Left = 7
      Top = 72
      Width = 577
      Height = 23
      EditLabel.Width = 32
      EditLabel.Height = 15
      EditLabel.Caption = 'Token'
      TabOrder = 1
      Text = ''
    end
  end
end
