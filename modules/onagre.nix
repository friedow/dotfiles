{ inputs, pkgs, ... }: {
  home-manager.users.christian.home = {
    # packages = [ (pkgs.hiPrio inputs.pop-launcher) inputs.onagre ];
    packages = [ (pkgs.hiPrio inputs.pop-launcher.packages."x86_64-linux".default) inputs.onagre.packages."x86_64-linux".default ];
    # file.".config/onagre/theme.scss" = {
    #   text = ''
    #     .onagre {
    #       background: #f0f0f3f3;
    #       color: #000000;
    #       --icon-theme: "Papirus";
    #       --font-family: "DejaVuSans";
    #       --icon-size: 12;
    #       border-radius: 4%;
    #       border-color: #d6d6d6;
    #       border-width: 4px;
    #       padding: 5px;

    #       .container {
    #         .rows {
    #           --height: fill-portion 6;
    #           .row {
    #             --width: 392;

    #             .icon {
    #               padding-top: 4px;
    #             }

    #             .category-icon {
    #               padding-left: 5px;
    #               --icon-size: 11;
    #             }

    #             .title {
    #               font-size: 18px;
    #             }

    #             .description {
    #               font-size: 12px;
    #             }
    #           }

    #           .row-selected {
    #             --width: 392;
    #             border-radius: 8%;
    #             background:  #c0c0c0;

    #             .icon {
    #               padding-top: 4px;
    #             }

    #             .category-icon {
    #               padding-left: 5px;
    #               --icon-size: 11;
    #             }

    #             .title {
    #               font-size: 20px;
    #             }

    #             .description {
    #               font-size: 12px;
    #             }
    #           }
    #         }

    #         .search {
    #           border-radius: 5%;
    #           background: #ffffff;
    #           --height: fill-portion 1;
    #           padding: 4px;
    #           .input {
    #             font-size: 20px;
    #           }
    #         }

    #         .scrollable {
    #           width: 2px;
    #           border-radius: 5%;
    #           background: #d6d6d6;
    #           .scroller {
    #             width: 4px;
    #             color: #a1a1a1;
    #           }
    #         }
    #       }
    #     }
    #   '';
    # };
  };
}