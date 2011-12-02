#!/usr/bin/env perl
use Text::Markdown 'markdown';
local $/;
my $file = <>;
$file =~ s{(.*;)$}{## $1\n\n    $1}g; # Passe les protos de fonction en code
$file =~ s{^//\s}{}g;        # Vire les symboles de commentaires

print <<END;
<!DOCTYPE HTML>
<html lang="en">
  <head>
  </head>
  <body>
  <section>
  <article>
END

print markdown($file);
  

print <<END;
  </article>
  </section>
  <footer>
  <p>Generated with perl</p>
  </footer>
  </body>
</html>
END
