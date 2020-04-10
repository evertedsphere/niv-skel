let

  compiler = "ghc865";
  projectName = "project-name-goes-here";
  withHoogle = false;

in let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  inherit (import sources.gitignore { inherit (pkgs) lib; }) gitignoreSource;

  hsPkgs = pkgs.haskell.packages.${compiler}.override {
    overrides = hself: hsuper: {
      # "${projectName}" =
      #   hself.callCabal2nix "${projectName}" (gitignoreSource ./.) { };
    };
  };

  shell = hsPkgs.shellFor {
    packages = p: [ 
      # p."${projectName}" 
    ];

    buildInputs = with pkgs; [
      hsPkgs.cabal-install
      ghcid
      ormolu
      hlint
      (import sources.niv { }).niv
      pkgs.nixpkgs-fmt
    ];
    inherit withHoogle;
  };

  # exe = pkgs.haskell.lib.justStaticExecutables (hpkgs."${projectName}");

in {
  inherit shell;
  # inherit exe;
  inherit pkgs;
  inherit hsPkgs;
  # "${projectName}" = hpkgs."${projectName}";
}
