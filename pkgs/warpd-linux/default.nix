{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  withWayland ? true,
  cairo,
  libxkbcommon,
  wayland,
  withX ? true,
  libxi,
  libxinerama,
  libxft,
  libxfixes,
  libxtst,
  libx11,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "warpd";
  version = "unstable";
  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "warpd";
    rev = "HEAD";
    hash = "sha256-kNoaOfDXsiQc2yGVgYK/iS8azP2jgoX1g4v9ZrgLYUI=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ git ];

  buildInputs =
    lib.optionals withWayland [
      cairo
      libxkbcommon
      wayland
    ]
    ++ lib.optionals withX [
      libxi
      libxinerama
      libxft
      libxfixes
      libxtst
      libx11
      libxext
    ];

  makeFlags = [
    "PREFIX=$(out)"
  ]
  ++ lib.optional (!withWayland) "DISABLE_WAYLAND=y"
  ++ lib.optional (!withX) "DISABLE_X=y";
  postPatch = ''
    substituteInPlace mk/linux.mk \
      --replace '-m644' '-Dm644' \
      --replace '-m755' '-Dm755' \
      --replace 'warpd.1.gz $(DESTDIR)' 'warpd.1.gz -t $(DESTDIR)' \
      --replace 'bin/warpd $(DESTDIR)' 'bin/warpd -t $(DESTDIR)'
  '';

  preBuild = ''
    sed -i 's/input_evnet/input_event/g' src/platform/linux/X/input.c
  '';

  meta = {
    description = "Modal keyboard driven interface for mouse manipulation";
    homepage = "https://github.com/rvaiya/warpd";
    changelog = "https://github.com/rvaiya/warpd/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ hhydraa iwnuplynottyan ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "warpd";
  };
})
