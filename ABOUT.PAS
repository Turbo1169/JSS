unit About;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TAboutForm = class(TForm)
    Panel2: TPanel;
    PaintBox1: TPaintBox;
    Timer2: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    OKBtn: TBitBtn;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    Label6: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;
  lines,x1,x2,y:integer;
  texto:array[0..18] of string;

implementation

{$R *.DFM}

uses main;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
     lines:=trunc(paintbox1.height/paintbox1.canvas.textheight(':)'))+2;
     y:=Panel2.height;
     texto[0]:='Programming & Design:';
     texto[1]:='Arturo Wisbrun';
     texto[2]:='';
     texto[3]:='Engineering:';
     texto[4]:='Rogelio Molina';
     texto[5]:='Miguel Angel Orozco';
     texto[6]:='Luis Alvarez';
     texto[7]:='';
     texto[8]:='Joist Production:';
     texto[9]:='Jorge Rodallegas';
     texto[10]:='Andres Amparan';
     texto[11]:='';
     texto[12]:='Shoporders:';
     texto[13]:='Daniel Leon';
     texto[14]:='Julio Leon';
     texto[15]:='';
     texto[16]:='Sales:';
     texto[17]:='Marisa Olivares';
     texto[18]:='Miguel Angel Orozco';
     x1:=0;
end;

procedure TAboutForm.Timer2Timer(Sender: TObject);
var
   x:integer;
begin
     dec(y);
     paintbox1.repaint;
     with paintbox1.canvas do
     begin
          if y<-textheight(':)') then
          begin
               y:=-1;
               if x1=high(texto) then
               begin
                    x1:=0;
                    y:=panel2.height;
               end
               else
                   inc(x1);
          end;
          x2:=x1+lines;
          if x2>high(texto) then
             x2:=high(texto);
          for x:=x1 to x2 do
          begin
               if x<=high(texto) then
               textout(1,y+textheight(':)')*(x-x1),texto[x]);
          end;
      end;
end;

end.
