self: super: 
{
  maven = super.maven.override {
    jdk = self.adoptopenjdk-hotspot-bin-8;
  };
}
