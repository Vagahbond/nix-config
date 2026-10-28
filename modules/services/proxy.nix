[
  {
    targets = [ "nixosConfiguration" ];
    conf = _: {
      security.acme = {
        acceptTerms = true;
        defaults.email = "vagahbond@pm.me";
      };

      services.nginx = {
        statusPage = true;
        # recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedBrotliSettings = true;

        appendConfig = ''
          # Add HSTS header with preloading to HTTPS requests.
          # Adding this header to HTTP requests is discouraged
          map $scheme $hsts_header {
              https   "max-age=31536000; includeSubdomains; preload";
          }
          add_header Strict-Transport-Security $hsts_header;

          # Enable CSP for your services.
          add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

          # Minimize information leaked to other domains
          add_header 'Referrer-Policy' 'origin-when-cross-origin';

          # Disable embedding as a frame
          add_header X-Frame-Options DENY;

          # Prevent injection of code in other mime types (XSS Attacks)
          add_header X-Content-Type-Options nosniff;

          # This might create errors
          proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";

          add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;
          add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        '';

      };
      networking.firewall.allowedTCPPorts = [
        443
        80
      ];
    };
  }
]
