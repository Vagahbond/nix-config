for i in $(ls **/flake.nix); do sudo nix flake update $i; done
