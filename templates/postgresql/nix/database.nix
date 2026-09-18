{ pkgs }:
{
  pgconfigure = pkgs.writeShellScriptBin "pgconfigure" ''
    psql -h localhost -p 5432 -d postgres -c "CREATE USER homepage WITH PASSWORD 'password';"
    psql -h localhost -p 5432 -d postgres -c "CREATE DATABASE homepage WITH OWNER homepage;";
  '';

  pgstart = pkgs.writeShellScriptBin "pgstart" ''
    pg_ctl -D data -l pglogfile start -o "-k ./";
  '';

  pginit = pkgs.writeShellScriptBin "pginit" ''
    pg_ctl -D data init;
  '';

  pgseed = pkgs.writeShellScriptBin "pgseed" ''
    psql -h localhost -p 5432 -d homepage -f database.sql
  '';

  pgstop = pkgs.writeShellScriptBin "pgstop" ''
    pg_ctl -D data -l pglogfile stop -o "-k ./";
  '';

  pgdump = pkgs.writeShellScriptBin "pgdump" ''
    pg_dump -h localhost -p 5432 -f database.sql homepage
  '';
}
