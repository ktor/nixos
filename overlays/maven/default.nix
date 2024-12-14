self: super: 
{
  maven8 = super.maven.override {
    jdk_headless = self.temurin-bin-8;
  };
  maven11 = super.maven.override {
    jdk_headless = self.jdk11;
  };
  maven17 = super.maven.override {
    jdk_headless = self.jdk17;
  };
  maven21 = super.maven.override {
    jdk_headless = self.jdk21;
  };
}
