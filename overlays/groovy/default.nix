self: super: 
{
  groovy = super.groovy.override {
    jdk = self.adoptopenjdk-hotspot-bin-8;
  };
}
