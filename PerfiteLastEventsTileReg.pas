unit PerfiteLastEventsTileReg;

interface

procedure Register;

implementation

{$R PerfiteLastEventsTileReg.dcr}

uses
  System.Classes,
  DesignIntf,
  DesignEditors,
  PerfiteLastEventsTile;

procedure Register;
begin
  RegisterComponents('Perfite', [TPerfiteLastEventsTile]);
end;

end.
