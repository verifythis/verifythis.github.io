# print '<div class="grid">';

use File::Slurp;

my $template = read_file('template.in');
# print $template;

open IN, "< Solutions.csv";
$line = <IN>;
chop $line;
@headers = split /;/, $line;

# print join " ", @headers;

while(<IN>) {
    chop $_;
#    print $_;
    $text = $template;
    @values = split /;/, $_;
    for($i = 0; $i < scalar @values; $i++) {
#       print "$i : ${values[$i]}\n";
#       print "$i : ${headers[$i]}\n";
        if($headers[$i] eq "Links" && length($values[$i]) > 0 ) {
            $with = "<ul>\n";
            foreach $x (split ", *", $values[$i]) {
                ($l, $t) = split / /, $x, 2;                
                $with .= "<li><a href=\"https://verifythis.github.io/casino/spec/$l\">$t</a>\n";
#               print "$x\n$l\n$t\n$with";
            }
            $with .= "</ul>\n";
        } else {
            $with = $values[$i];
            $with =~ s/\* +/<li>/g;
        }
        $re = qr/\$${headers[$i]}\$/;
#       print $re;
        $text =~ s/${re}/${with}/g;
    }
    print $text;
    print "\n\n";
}

# print "</div>";
