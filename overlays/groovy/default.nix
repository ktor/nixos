self: super: 
{
  groovy = super.groovy.override {
    jdk = self.temurin-bin-8;
  };
}
