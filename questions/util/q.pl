#!/usr/bin/perl
use FindBin;
use feature qw(say);
use Time::HiRes qw(time);

$filename = "$FindBin::Bin/../questions";
$tempFile = "$FindBin::Bin/../tmp.tmp";
sub ReplaceLine {
        use integer;
        open my $in, '<', $filename or die $!;
        open my $out, '>', "$filename.new" or die $!;
        while (<$in>) {
                print $out $_ if @_[0] != 0;
                last if $. >= @_[0];
        }
        my $skip = <$in> if @_[0] != 0;
        print $out (@_[1]."\n") if (@_[1] ne "\%remove\%");
        while (<$in>) {
                print $out $_;
        }
        close $out;
        system("mv $filename.new $filename");
}

sub InsertAnswer {
	use integer;
	open my $in, '<', $filename or die $!;
	open my $out, '>', "$filename.new" or die $!;
	while (<$in>) {
		print $out $_ if @_[0] != 0;
		last if $. >= @_[0];
	}
	print $out <$in>;
	print $out "\n";
	$datestring = localtime();
	print $out ("### [$datestring]" . @_[1] . "\n");
	while (<$in>) {
		print $out $_;
	}
	close $out;
	system("mv $filename.new $filename");
}


# for repl.it usage, since they don't have nano
if (system("command -v nano") != -1) {
    print(" < using nano > \n");
    $EDITOR = "nano";
} else {
    print(" < using vi > \n");
    $EDITOR = "vim";
}

system("rm $tempFile");
while () {# for repl.it usage, since they don't have nano
if (system("command -v nano") != -1) {
    print(" < using nano > \n");
    $EDITOR = "nano";
} else {
    print(" < using vi > \n");
    $EDITOR = "vim";
}



# questions start with ~~~, answers start with ###.
open('FH', '<', $filename) or die $!;
@lines = ();
@questionLines = ();
while(<FH>) {
	push @lines, $_;
	if ($_ =~ /^\~\~\~$/) {
		push @questionLines, ($. - 1);
	}
}
close(FH);

$index = rand @questionLines;
$lineNumber = @questionLines[$index];
$line = @lines[$lineNumber];
chomp $line;

$addQuestion = rand 3;


open $fileCreation, '>>', $tempFile or die $!;
print $fileCreation ("The following line is the question. Replace it with a single \% to remove and abort and \! to only abort. Otherwise, edit the question, leaving the triple ~" . "\n");
print $fileCreation ($line . "\n");
print $fileCreation ("+++" . "\n");
close $fileCreation;


$startTime = time();

system("$editor $tempFile");

open $in, '<', $tempFile or die $!;
$header = <$in>;
$question = <$in>;
$blankLine = <$in>;
$answer = "";
while(<$in>) {
	$answer .= $_;
}

$elapsedTime = time() - $startTime;

chomp $question;
chomp $answer;
if ($question eq "\%") {
	ReplaceLine($lineNumber, "removed question " . $line);
} elsif {
	if ($question !~ /^(\~){3}(.*)$/) {
		$question = ("~" x 3) . $2;
	}
	ReplaceLine($lineNumber, $question);
}
if ($question ne "\!" and $question ne "\%") {
	InsertAnswer($lineNumber, $answer)
}



$elapsedMinutes = int($elapsedTime / 60);
$elapsedSeconds = $elapsedTime % 60;
printf("This question took you %d:%0.2f !\n", $elapsedMinutes, $elapsedSeconds);
# printf("%0.1f milliseconds\n", $elapsed * 1000);
# printf("%d microseconds\n", $elapsed * 1000 * 1000);
# printf("%d nanoseconds\n", $elapsed * 1000 * 1000 * 1000);


if ($addQuestion < 1) {
	say("=" x 25);
	print("type a question! (\% to cancel) > ");
	$question = <STDIN>;
	chomp $question;
	if ($question ne "\%") {
		open $out, '>>', $filename or die $!;
		print $out "\n";
		print $out "\n";
		print $out ($question . "\n");
		close $out;
	}
	say("=" x 25);
	say("");
}



	
}
