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
		print $out $_;
		last if $. >= @_[0];
	}
	my $nextLine = <$in>;
	print $out $nextLine;
	print $out "\n";
	$datestring = localtime();
	print $out ("### [$datestring]" . @_[1] . "\n");
	while (<$in>) {
		print $out $_;
	}
	close $out;
	system("mv $filename.new $filename");
}

sub InsertQuestion {
	use integer;
	open my $in, '<', $filename or die $!;
	open my $out, '>', "$filename.new" or die $!;
	my $foundIt = 0;
	my $lineNumber = -1;
	while (<$in>) {
		print $out $_;
		chomp $_;
		$lineNumber = $.;
		if ($_ ne @_[0]) {
			$foundIt = 0;
		} else {
			$foundIt = 1;
			last;
		}
	}
	if ($foundIt == 1) {
		system("rm $filename.new");
		return($lineNumber - 1);
	} else {
		print $out "\n";
		print $out @_[0];
		system("mv $filename.new $filename");
		return($lineNumber + 1);
	}
}


@WORDS = ("die Arbeitsstelle", "Geld verdienen", "der Antrag");


# for repl.it usage, since they don't have nano
if ("$^O" eq "MSWin32") {
	print(" < using notepad > \n");
	$EDITOR = "notepad";
} elsif (qx/command -v nano/ ne -1) {
    print(" < using nano > \n");
    $EDITOR = "nano";
} else {
    print(" < using vim > \n");
    $EDITOR = "vim";
}

say("loading questions");
say("~~~ Wie heißt du?");
$name = <STDIN>;

while () {


# questions start with ~~~, answers start with ###.
open('FH', '<', $filename) or die $!;
@lines = ();
@questionLines = ();
while(<FH>) {
	push @lines, $_;
	if ($_ =~ m/^\~\~\~/) {
		push @questionLines, ($. - 1);
	}
}
close(FH);

$index = rand @questionLines;
$lineNumber = @questionLines[$index];
$line = @lines[$lineNumber];
chomp $line;

$addQuestion = rand 1;
$word = @WORDS[rand @WORDS];

$doRandomWord = (0) < 1;
if ($doRandomWord) {
	$line = "[*] Was bedeutet \"$word\"?";
	$lineNumber = (scalar @lines) * 2;
}

open $fileCreation, '>', $tempFile or die $!;
print $fileCreation ("The following line is the question. Replace it with a single \% to remove and abort and \! to only abort. Otherwise, edit the question, leaving the triple ~" . "\n");
print $fileCreation ($line . "\n");
print $fileCreation ("+++" . "\n");
close $fileCreation;


$startTime = time();

system("$EDITOR $tempFile");

open $in, '<', $tempFile or die $!;
$header = <$in>;
$questionLine = <$in>;
$question = $questionLine if (not($doRandomWord));
$question = $line if ($doRandomWord);
$blankLine = <$in>;
$answer = "";
while(<$in>) {
	$answer .= $_;
}

$elapsedTime = time() - $startTime;

chomp $question;
chomp $answer;
if ($question eq "\%") {
	ReplaceLine($lineNumber, "removed question $line");
} elsif (not($doRandomWord)) {
	if ($question !~ /^(\~){3}(.*)$/) {
		$question = ("~" x 3) . $2;
	}
	ReplaceLine($lineNumber, $question);
}
if ($doRandomWord) {
	$lineNumber = InsertQuestion($question);
}
if ($question ne "\!" and $question ne "\%") {
	InsertAnswer($lineNumber, $answer);
}


$elapsedMinutes = int($elapsedTime / 60);
$elapsedSeconds = $elapsedTime % 60;
say($question);
printf("This question took you %d:%0.2f !\n", $elapsedMinutes, $elapsedSeconds);
# printf("%0.1f milliseconds\n", $elapsed * 1000);
# printf("%d microseconds\n", $elapsed * 1000 * 1000);
# printf("%d nanoseconds\n", $elapsed * 1000 * 1000 * 1000);

$continuing = <STDIN>;

if ($addQuestion < 1) {
	say("=" x 25);
	print("type a question! (\% to cancel) > ");
	$question = <STDIN>;
	chomp $question;
	if ($question !~ /^(\~){3}(.*)$/) {
#		print("You're asking me\n");
#		@questionFrag = /^(\~)+(.*)$/;
#		print($questionFrag[1]);
		$question = "~~~ $question";
	}
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
