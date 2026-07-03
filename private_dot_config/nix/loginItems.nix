{ pkgsUnstable }:
let
  loginAppAgent = appPath: {
    serviceConfig = {
      ProgramArguments = [ "/usr/bin/open" appPath ];
      RunAtLoad = true;
    };
  };
in
{
  aerospace = {
    serviceConfig = {
      ProgramArguments = [ "${pkgsUnstable.aerospace}/bin/aerospace" ];
      RunAtLoad = true;
    };
  };
  alfred = loginAppAgent "/Applications/Alfred 5.app";
  flux = loginAppAgent "/Applications/Flux.app";
  hammerspoon = loginAppAgent "/Applications/Hammerspoon.app";
  stats = loginAppAgent "/Applications/Stats.app";
  thaw = loginAppAgent "/Applications/Thaw.app";
}
