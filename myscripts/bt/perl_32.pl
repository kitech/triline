#!/usr/bin/perl  
      
use MIME::Base32 qw( RFC );  
      
undef $/;  # in case stdin has newlines  
$string = <STDIN>;  
      
$encoded = MIME::Base32::encode($string);  
      
print "$encoded\n";  
