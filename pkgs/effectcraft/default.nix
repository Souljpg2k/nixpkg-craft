{
  alsa-lib,
  autoPatchelfHook,
  fetchurl,
  dbus,
  lib,
  libglvnd,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxkbcommon,
  libxrandr,
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
    libglvnd
    libx11
    libxcursor
    libxext
    libxi
    libxkbcommon
    libxrandr
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
