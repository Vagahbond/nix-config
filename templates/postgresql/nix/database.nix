{ pkgs, projectName }:
{
  pgconfigure = pkgs.writeShellScriptBin "pgconfigure" ''
    psql -h $(pwd)/data -d postgres -c "CREATE USER ${projectName} WITH PASSWORD 'password';"
    psql -h $(pwd)/data -d postgres -c "CREATE DATABASE ${projectName} WITH OWNER ${projectName};";
  '';

  pgstart = pkgs.writeShellScriptBin "pgstart" ''
    pg_ctl -D data -l pglogfile start -o "-c listen_addresses=' ' -c unix_socket_directories='./'";
  '';

  pginit = pkgs.writeShellScriptBin "pginit" ''
    pg_ctl -D data init -o "-c unix_socket_directories='./'";
  '';

  pgseed = pkgs.writeShellScriptBin "pgseed" ''
    psql -h $(pwd)/data -d ${projectName} -f database.sql
  '';

  pgstop = pkgs.writeShellScriptBin "pgstop" ''
    pg_ctl -D data -l pglogfile stop -o "-c unix_socket_directories='./'";
  '';

  pgdump = pkgs.writeShellScriptBin "pgdump" ''
    pg_dump -h $(pwd)/data -f database.sql ${projectName}
  '';

}
