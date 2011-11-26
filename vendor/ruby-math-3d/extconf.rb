require 'mkmf'

# Compilation workaround:
# Uncomment and modify the line below if you want to build RMath
# against "MSC version unmatch: _MSC_VER: XXXX is expected." error.

# $CFLAGS += " -D_MSC_VER=1200"

create_makefile('RMath')
