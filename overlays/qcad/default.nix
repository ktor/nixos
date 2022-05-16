self: super:
{
  qcad = super.qcad.overrideAttrs (old: {
    version = "3.27.1.8";
    src = super.fetchFromGitHub {
      owner = "qcad";
      repo = "qcad";
      rev = "v3.27.1.8";
      sha256 = "sha256-OWAc7g8DiJR3z6dUF5D0Yo3wnRKd1Xe7D1eq15NRW5c=";
    };
  });
}
