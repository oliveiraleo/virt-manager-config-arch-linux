# virt-manager-config-arch-linux

Quickly configure virt-manager on Arch-based distros

**TIP:** It may also work on Debian-based ones, change "pacman -S" to "apt install"

## Usage

Copy the script to the host system
```
curl -LO https://github.com/oliveiraleo/virt-manager-config-arch-linux/raw/main/virt-manager-setup.sh
```

Grant it execution permissions
```
chmod +x virt-manager-setup.sh
```

Run
```
./virt-manager-setup.sh
```

## Credits

Thanks [@gitbarnabedikartola](https://github.com/gitbarnabedikartola), the original author of the configuration script. Also, thanks [@biglinux](https://github.com/biglinux) team for sharing their source code as Free and Open Source Software (FOSS), specially the packages [biglinux-virt-manager-config](https://github.com/biglinux/biglinux-virt-manager-config/blob/main/pkgbuild/PKGBUILD) and [biglinux-improve-compatibility](https://github.com/biglinux/biglinux-improve-compatibility/blob/main/biglinux-improve-compatibility/usr/share/libalpm/scripts/biglinux-virt-manager-config-install) that inspired my script. Additionally, thanks [@rocketguedes](https://github.com/rocketguedes) for sharing on [his PR](https://github.com/biglinux/biglinux-improve-compatibility/pull/14) some ideas for improving the script that also inspired my script.

## License

This program is free software: you can redistribute it and/or modify it under the terms of the [GNU General Public License version 3](./LICENSE) as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.en.html) for more details.
