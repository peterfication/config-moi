# Make sure no post-install scripts are run when installing packages with yarn
#
# Run the required build scripts manually like this:
#
#  YARN_ENABLE_SCRIPTS=true yarn rebuild esbuild
#
export YARN_ENABLE_SCRIPTS=false
