{ inputs, ... }: {
  imports = [
    inputs.pre-commit-hooks-nix.flakeModule
  ];
  perSystem = { pkgs, system, config, ... }:
    {
      devShells.dev-pre-commit = config.pre-commit.devShell;
      # devShells.default = config.pre-commit.devShell;

      pre-commit = {
        settings = {
          excludes = [
            "cluster-data/"
            "src/Plutip/Launch/"
          ];

          hooks = {
            nixpkgs-fmt.enable = true;
            deadnix.enable = true;
            cabal-fmt.enable = true;
            fourmolu.enable = true;
            shellcheck.enable = true;
            hlint.enable = true;
            typos.enable = true;
            markdownlint.enable = true;
          };

          settings = {
            ormolu.cabalDefaultExtensions = true;
          };
        };
      };
    };
}
