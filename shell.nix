{
  pkgs,
  ...
}:
let

  createLivePersistentPartition = pkgs.writeShellScriptBin "create_live_persistent_partition" ''
    set -euo pipefail
    export PATH=${
      pkgs.lib.makeBinPath (
        with pkgs;
        [
          coreutils
          gawk
          gnugrep
          util-linux
          parted
          gptfdisk
          e2fsprogs
          systemd
        ]
      )
    }:$PATH

    label="live-persist"

    die() {
      echo "error: $*" >&2
      exit 1
    }

    [ "$#" -eq 1 ] || die "usage: create_live_persistent_partition /dev/<disk>"
    disk="$1"

    [ "$(id -u)" -eq 0 ] || die "must be run as root"
    [ -b "$disk" ] || die "$disk is not a block device"
    [ "$(lsblk -dno TYPE "$disk")" = "disk" ] || die "$disk is not a whole disk"

    if lsblk -nro MOUNTPOINTS "$disk" | grep -q .; then
      die "$disk (or one of its partitions) is mounted"
    fi

    if lsblk -nro PARTLABEL,LABEL "$disk" | grep -qw "$label"; then
      die "$disk already has a partition labelled $label"
    fi

    pttype="$(blkid -o value -s PTTYPE "$disk" || true)"
    case "$pttype" in
      gpt)
        # Images written with dd leave the backup GPT header before the end of the disk.
        sgdisk -e "$disk" >/dev/null
        ;;
      dos) ;;
      *) die "unsupported or missing partition table on $disk: '$pttype'" ;;
    esac

    sector_size="$(blockdev --getss "$disk")"
    align=$((1048576 / sector_size))

    last_line="$(parted -s -m "$disk" unit s print free | tail -n 1)"
    echo "$last_line" | grep -q ':free;$' || die "no unoccupied space at the end of $disk"

    free_start="$(echo "$last_line" | cut -d: -f2 | tr -d s)"
    free_end="$(echo "$last_line" | cut -d: -f3 | tr -d s)"
    start=$(((free_start + align - 1) / align * align))
    [ $((free_end - start + 1)) -ge $((align * 8)) ] || die "less than 8MiB free at the end of $disk"

    echo "About to create an ext4 partition '$label' on $disk"
    echo "from sector $start to $free_end ($(((free_end - start + 1) / align)) MiB)."
    read -r -p "Type YES to continue: " answer
    [ "$answer" = "YES" ] || die "aborted"

    before="$(lsblk -lnpo NAME,TYPE "$disk" | awk '$2 == "part" { print $1 }' | sort)"

    if [ "$pttype" = "gpt" ]; then
      parted -s "$disk" unit s mkpart "$label" ext4 "$start" "$free_end"
    else
      parted -s "$disk" unit s mkpart primary ext4 "$start" "$free_end"
    fi

    partprobe "$disk" || true
    udevadm settle

    after="$(lsblk -lnpo NAME,TYPE "$disk" | awk '$2 == "part" { print $1 }' | sort)"
    part="$(comm -13 <(echo "$before") <(echo "$after") | head -n 1)"
    [ -n "$part" ] || die "could not find the newly created partition"

    mkfs.ext4 -F -L "$label" "$part"
    udevadm settle

    echo "Created $part (label: $label)"
  '';

  flashLiveIso = pkgs.writeShellScriptBin "flash_live_iso" ''
    set -euo pipefail
    [ "$#" -eq 1 ] || { echo "usage: flash_live_iso /dev/<disk>" >&2; exit 1; }
    iso=("result/iso/"*.iso)
    [ "''${#[@]}" -eq 1 ] && [ -f "''${iso[0]}" ] || { echo "error: expected exactly one ISO in result/iso" >&2; exit 1; }
    ${pkgs.coreutils}/bin/dd if="''${iso[0]}" of="$1" bs=4M status=progress oflag=sync
  '';

  # TODO: make it use its own SSH key, porovided as a secret to any host that is allowed to build the lvie env.
  /*
    injectCurrentHostSshKey = pkgs.writeShellScriptBin "inject_current_host_ssh_key" ''
      set -euo pipefail
      [ "$#" -eq 1 ] || { echo "usage: inject_current_host_ssh_key /dev/<disk>" >&2; exit 1; }

      disk="$1"

      mount /dev/disk/by-label/live-persist /mnt/live-persist

      cp -r /etc/nixos/secrets/ssh-keys/ed25519 /mnt/live-persist/home/.ssh/

      umount /mnt/live-persist

      echo "Added current host's SSH key to /mnt/live-persist/home/.ssh/ed25519"
      "
    '';
  */
in
{
  buildInputs = [
    pkgs.mermaid-cli
    pkgs.entr
    flashLiveIso
    # injectCurrentHostSshKey
  ]
  ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    createLivePersistentPartition
  ];

  shellHook = ''
    echo "This dev shell is for various aspects of this flake.

    ###############################################################
    # Testing live ISOs                                           #
    ###############################################################

    1) flash_live_iso <disk>: flash the live ISO to <disk>

    2) create_live_persistent_partition <disk>: ${
      if pkgs.stdenv.hostPlatform.isLinux then
        "create a persistent partition on <disk>"
      else
        "Not available on MacOS host"
    } 

    Caution: The main SSH key to decifer secrets will have to be added manually. 
    "
  '';
}
