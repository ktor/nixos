self: super: 
{
  maven = super.maven.override {
    jdk = self.adoptopenjdk-hotspot-bin-8;
  };
  maven11 = super.maven.override {
    jdk = self.jdk11;
  };
  maven17 = super.maven.override {
    jdk = self.jdk17;
  };
}
