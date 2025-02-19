#!/bin/bash -xe

case "$(uname -s)" in
    "Linux")
        if [[ "$MAKER" = "deb" || -n "$APPVEYOR" ]]; then
          sudo apt-get install --yes --no-install-recommends fakeroot dpkg
        fi
        if [[ "$MAKER" = "rpm" || -n "$APPVEYOR" ]]; then
          if [[ -n $CIRCLECI ]]; then
            sudo apt-get update
          fi
          sudo apt-get install --yes --no-install-recommends rpm
        fi
        if [[ "$MAKER" = "flatpak" || -n "$APPVEYOR" ]]; then
          "$(dirname $0)"/install_flatpak_dependencies.sh
        fi
        if [[ "$MAKER" = "snap" || -n "$APPVEYOR" ]]; then
          "$(dirname $0)"/install_snap_dependencies.sh
        fi
        ;;
    "Darwin")
        "$(dirname $0)"/codesign/import-testing-cert-ci.sh
        ;;
    "Windows"|"MINGW"|"MSYS"*)
        if [[ -n $CIRCLECI ]]; then
          if [[ "$MAKER" = "wix" ]]; then
            choco install wixtoolset
            echo 'export PATH="$PATH:/c/Program Files (x86)/WiX Toolset v3.11/bin"' >> "$BASH_ENV"
          fi
        fi
        ;;
esac
