{
  alsa-lib,
  autoPatchelfHook,
  dbus,
  fetchurl,
  lib,
  libGL,
  libxcb,
  libx11,
  libxkbcommon,
  libxcursor,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  makeWrapper,
  stdenv,
  stdenvNoCC,
  vulkan-loader,
  wayland
}:
let
  manifest = builtins.fromJSON (builtins.readFile ./manifest.json);
  binary = manifest.binary.name;
  version = manifest.source.version;

  runtimeLibs = [
    alsa-lib
    dbus
    libGL
    libxcb
    libx11
    libxkbcommon
    libxcursor
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    stdenv.cc.cc.lib
    vulkan-loader
    wayland
  ];
in
stdenvNoCC.mkDerivation {
  pname = binary;
  inherit version;

  src = fetchurl {
    inherit (manifest.source) url hash;
  };

  sourceRoot = "${binary}-${version}-linux-x86_64";
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = runtimeLibs;
  runtimeDependencies = runtimeLibs;

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -a bin share "$out/"
    wrapProgram "$out/bin/${binary}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
    runHook postInstall
  '';

  meta = {
    description = manifest.meta.description;
    homepage = manifest.meta.homepage;
    license = with lib.licenses; [ mit asl20 ];
    mainProgram = binary;
    platforms = [ "x86_64-linux" ];
  };
}
