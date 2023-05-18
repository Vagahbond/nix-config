{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    notion-app-enhanced
  ];
}
