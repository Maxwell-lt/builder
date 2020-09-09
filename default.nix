with import ./nixpkgs {};
with stdenv;

with callPackage ./lib/lib.nix {};

let resources_12 = runLocally "resources-1.12" {
    } ''
      mkdir -p $out/resourcepacks $out/shaderpacks
      #ln -s $seus $out/shaderpacks/SEUS-v11.0.zip
      #ln -s $faithful $out/resourcepacks/F32-1.10.2.zip
      #ln -s $sphax $out/resourcepacks/Sphax.zip
    '';
   resources_10 = runLocally "resources-1.10" {
   } ''
     mkdir -p $out/resourcepacks
     #ln -s $ozocraft $out/resourcepacks/OzoCraft.zip
   '';
   resources_7 = runLocally "resources-1.7" {
   } ''
     mkdir -p $out/resourcepacks
     #ln -s $erisia $out/resourcepacks/erisia-pack.zip
   '';
   sprocket = callPackage ./lib/sprocket {};
in

rec {

  packs = {
    bc1 = buildPack bc1;
  };


  bc1 = {
    name = "LibreCirculus";
    tmuxName = "bc1";
    description = "BC1: Libre Circulus";
    ram = "12000m";
    port = 25565;
    prometheusPort = 1223;
    forge = {
      major = "1.12.2";
      minor = "14.23.5.2847";
    };
    extraDirs = [
      ./base/e24
      ./base/erisia
      ./base/bc1
    ];
    extraServerDirs = [
      ./base/server
      ./base/e24-server
      ./base/bc1-server
    ];
    extraClientDirs = [
      resources_12
      ./base/client
    ];
    manifests = [
      ./manifest/bc1.nix
    ];
    blacklist = [
    ];
  };


  ServerPack = buildServerPack rec {
    inherit packs;
    hostname = "minecraft.maxwell-lt.dev";
    urlBase = "https://minecraft.maxwell-lt.dev/pack/";
  };

  # To use:
  # (nix build -f . ServerPackLocal && cd result && python -m SimpleHTTPServer)
  ServerPackLocal = buildServerPack rec {
    inherit packs;
    hostname = "localhost:8000";
    urlBase = "http://" + hostname + "/";
  };

  web = callPackage ./web {};
}
