{...}: {
  config = {
    modules = {
      impermanence = {
        enable = true;
        #storageLocation = "/data";
      };
      user.password = "$y$j9T$W4KvCgdBzhRBgZDnXf9s2/$rdrtKUhstflz5ADDB/w9WZc6M/sWlwqM76vKjaG3yV/";

      editor = {
        terminal = ["neovim"];
      };

      network = {
        ssh.enable = false;
      };

      system = {
        rclone.enable = true;
        ntfs.enable = true;
        compression.enable = true;
      };

      terminal = {
        tmux.enable = true;
        shell = "zsh";
      };

      virtualisation = {
        docker.enable = true;
      };

      services = {
        invoices.enable = true;
        metrics.enable = true;
        proxy.enable = true;
        ssh.enable = true;
        nextcloud.enable = true;
        office.enable = true;
        vaultwarden.enable = true;
        builder.enable = true;
        homePage.enable = true;
        blog.enable = true;
        universe.enable = false;
        learnify.enable = true;
        notes.enable = true;
        pdf.enable = true;
      };
    };
  };
}
