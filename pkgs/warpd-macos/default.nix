{ lib, pkgs, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "warpd";
  version = "unstable-2023-06-03";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "warpd";
    rev = "01650eabf70846deed057a77ada3c0bbb6d97d6e";
    sha256 = "sha256-61+kJvOi4oog0+tGucc1rWemdx2vp15wlluJE+1PzTs=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    pkgs.apple-sdk
  ];

  makeFlags = [ "PLATFORM=macos" "PREFIX=$(out)" ];

  buildPhase = ''
    mkdir -p bin
    ${stdenv.cc}/bin/clang -o bin/warpd \
      -target x86_64-apple-macos \
      -Wl,-adhoc_codesign \
      src/*.c src/platform/macos/*.m \
      -framework Cocoa -framework Carbon \
      -Wno-deprecated-declarations \
      -Wno-unused-parameter \
      -std=c99 \
      -DVERSION=\"${version}\"
  '';

  postPatch = ''
    sed -i 's/^size_t nr_boxes;/extern size_t nr_boxes;/' src/platform/macos/macos.h
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/warpd $out/bin/warpd
  '';

  meta = {
    description = "A modal keyboard-driven interface for mouse manipulation";
    homepage = "https://github.com/rvaiya/warpd";
    platforms = lib.platforms.darwin;
  };
}
