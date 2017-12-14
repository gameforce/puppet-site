# Needed for hiera v5
# Merge several arrays of class names into one array:
# lookup('classes', {merge =>  'unique'})
hiera_include(classes)
