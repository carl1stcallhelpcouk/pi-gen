# TODO

1. Create a todo.md / wip.md to suppliment README.md with links from README.md file. (WIP)
1. Fix code-oss keyboard bug. (DONE by using microsofts version.)
1. Update `README.md`. (WIP.)
1. Impliment `postrun.sh`. (DONE.)
1. Move building of images to imitiately after stage has been built. (DONE.)
1. Fork building of imaged to background. (DONE.)
1. Resolve locale not set messages in stage0.
1. Make a config directory with symbolic links to package files.
1. New config options :-
   1. Make desktop environment configurable (ie. mate, kde, default, etc, etc.)
   1. Make arch configurable (ie. arm64, x86, etc, etc) !! problem atm with chromium/chromium-browser dependent on arch. (WIP/TESTING.)
   1. Make OS configurable (ie. ubuntu, arch, debian, etc, etc.)
   1. Enable SBCs other than PIs. (rename to sbc-gen??????)
   1. Add log verbosity option. Maybe a ```debug_log(DEBUG_LEVEL, MESSAGE)``` function (WIP/TESTING)
      1. Include STAGE / SUB_STAGE / SCRIPT / FUNCTION to logfile, depending on log verbosity option. (WIP / TESTING.)
         1. SUB_STAGE (WIP. only with verbose logging ?)
         1. Script file / function (TODO)

   1. Make source repoitories configurable. (Think its been done on github https://github.com/RPi-Distro/pi-gen/pull/445.) (WIP/TESING)

1. Add show_progress function for long running tasks (WIP.)
1. Move more otions to `config`. (WIP/TESTING.)
1. Write a `pi-gen-reconfigue.sh` to change hostname, UUIDs, etc, etc without rebuild.
1. Standardise log messages.
1. Write some documentation.
1. Make a CLI.
1. Make a GUI.
1. Document code.
1. Create a config.d type folder with symlinks to packages, config, etc. files.
1. Maybe an apache type pig2enable 'feature' to symlink apropiate files that install / enable features?
1. Split package files into logical groups.  
    1. Maybe append short description to filename, ie. 00-packages_mate, 00-packages_kde, 00-packages_vscode, etc. etc.
    1. Maybe add a RUN_SUFFIX array config option and then check for `*{packages_${RUNSUFFIX},run_${RUNSUFFIX}.sh,runon-chroot_${RUNSUFFIX}.sh}`.  eg. `RUN_SUFFIX=( arm64 (or ${ARCH}) mate firefox vscode etc.)`, then for each suffix in ${RUN_SUFFIX[@]} if the file 00-packages_${suffix} exists, install them and if 01-run_arm64.sh, run it.  (WIP.)

1. TARGET_HOSTNAME (or perhaps add a TARGET_NAME config option) specific directories.  ie stage3_rpi1, stage3_rpi2, etc. etc.
1. Home directory github repo with .config, .bashrc, etc. etc. that we can clone during build or on 1st login.
1. Remove default password? Leave blank + expire if it will work.  Blank not working with gui.  Need to investigate.
1. Integrate with apt-cacher or simular to cache apt repository.
1. Allow overide of `config.txt` options.  Easy - Set all defaults in `config`, then sed them into `config.txt`.  Harder but more flexable - for each line in `config.txt`, check for correspnding `${CONFIGTXT_config option from config.txt}` and only replace ones set/differ. eg. `if [ -z CONFIGTXT_disable_overscan ] then sed config.txt`
1. add `ufw` package to stage3?
1. add `ncat` package to stage3?
1. Allow addition of aditional partitions on ssd/hhd/sd for data storage or home dirs etc.
1. Enable background running.  This will involve the merging of log & debug_log functions to give granular logging and extend to full logging / silent STDOUT.
1. Make repeateable builds by :- 
   1. debootstrap --download-only and apt-get --download-only to local repository or
   1. debootstrap --unpack-tarball=T     acquire .debs from a tarball instead of http
          "       --make-tarball=T       download .debs and create a gzipped tarball
1. Fast mode by using mv or hardlink instead of cp / rsync in `prerun.sh`s.
1. Add stage7 for hostname specific tasks.
1. Add install games/office/firefox/chromium/etc. options.
1. Allow addidion of optional official & unofficial repositories.
1. Add OVER_VOLTAGE & ARM_FREQ config options and update `config.txt` accordingly.
1. Allow multiple parallel builds.
