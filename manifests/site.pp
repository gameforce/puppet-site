# Needed for hiera v5
# Merge several arrays of class names into one array:
# lookup('classes', {merge =>  'hash'})
#hiera_include(classes)
lookup('classes', {merge =>  'hash'})
# include lookup('classes', { 'merge' => 'unique' })
#lookup('classes', Array[String], 'unique').include
