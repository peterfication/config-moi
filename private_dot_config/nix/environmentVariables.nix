pkgs: with pkgs; {
  PKG_CONFIG_PATH = "${pkgs.icu.dev}/lib/pkgconfig:${pkgs.openssl.dev}/lib/pkgconfig";
  CFLAGS = "-I${pkgs.icu.dev}/include -I${pkgs.openssl.dev}/include";
  LDFLAGS = "-L${pkgs.icu.dev}/lib -L${pkgs.openssl.dev}/lib";

  PG16_BIN = "${pkgs.postgresql_16}/bin";
  PG17_BIN = "${pkgs.postgresql_17}/bin";

  # Use it with bundler like this:
  #
  #   BUNDLE_BUILD__PG=$RUBY_PG16_FLAGS  bundle install
  #
  RUBY_PG16_FLAGS = "--with-pg-include=${pkgs.postgresql_16.dev}/include --with-pg-lib=${pkgs.postgresql_16.lib}/lib";
  RUBY_PG17_FLAGS = "--with-pg-include=${pkgs.postgresql_17.dev}/include --with-pg-lib=${pkgs.postgresql_17.lib}/lib";
}
