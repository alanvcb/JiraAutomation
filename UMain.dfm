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
    ActivePage = tshProjects
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
