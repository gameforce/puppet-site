# Needed for hiera v5
# Merge several arrays of class names into one array:
#lookup('classes', {merge =>  'hash'})

# node defaults
node default {
  # includes
  include common
  include mounts
}

# per-node includes
node kam1.stellarcreative.lab {
  # includes
  # include puppet
}

node box49.stellarcreative.lab {
  # includes
}

