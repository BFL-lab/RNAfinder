
#
# This class represents the content of a configuration
# file used by XXX; that file stores a list of commands
# that are used to detected RNAs genes.
#
# $Id: RNAfinderConfigFile.pir,v 1.1 2008/10/28 21:57:23 nbeck Exp $
#
# $Log: RNAfinderConfigFile.pir,v $
# Revision 1.1  2008/10/28 21:57:23  nbeck
# Initial check-in.
#
#

- PerlClass	PirObject::RNAfinderConfigFile
- InheritsFrom	PirObject
- FieldsTable

# Field name		    Sing/Array/Hash	Type		              Comments
#---------------------- ---------------	-----------------------   -----------------------
filename		        single		    string		              optional
geneprogs		        hash		    <GeneCommandSet>          # genename => what to run

- EndFieldsTable
- Methods

our $RCS_VERSION='$Id: RNAfinderConfigFile.pir,v 1.1 2008/10/28 21:57:23 nbeck Exp $';
our ($VERSION) = ($RCS_VERSION =~ m#,v ([\w\.]+)#);

# Sample format of text file
#
# # comment
# GeneName=rnl
# Commands                 # one or many such blocks
#   blah blah blah line 1
#   blah blah blah line 2
# EndCommands

sub ImportFromTextFile {
    my $self = shift;
    my $filename = shift;

    my $class = ref($self) || $self;

    $self = $class->new() if $self eq $class;
    $self->set_filename($filename);
    
    my $fh = new IO::File "<$filename"
        or die "Cannot read from file '$filename': $!\n";
    my @file = <$fh>;
    $fh->close();
    
    my $genecoms = {};
    while (@file) {
        my $line = shift(@file);
        next if $line =~ m/^\s*$|^\s*#/;
        
        # Expects "genename"
        if ($line !~ m/^\s*genenames?\s*=\s*(\w+)\s*$/i) {
            die "Error: unparsable line in '$filename' (expected \"genename=\"), got:\n$line";
        }
        
        my $genename = $1;
        $genename =~ s/\s+//;
        die "Error: genename '$genename' seen more than once in file '$filename'.\n"
            if exists $genecoms->{$genename};
            
         my $genecom = new PirObject::GeneCommandSet(
            genename     => $genename,
            intel        => "minimal",
            modelList    => {},
            commandList  => {}
        );
        
        my $commandset  = $genecom->get_modelList();
        my $commandList = $genecom->get_commandList();
        
        shift(@file) while @file && $file[0] =~ m/^\s*$|^\s*#/;
        
        while (@file) {
            shift(@file) while @file && $file[0] =~ m/^\s*$|^\s*#/;
            last if !@file;

            # Expect "Int", optional
            $genecom->set_intel($1)  if $file[0] =~ m/^\s*int?\s*=\s*(\w+)\s*$/i;
            die "Error: expected value 'minimal' or 'full' for Int field in $genename block\n"
                   if $genecom->get_intel() ne "minimal" && $genecom->get_intel() ne "full";
            shift(@file)             if $file[0] =~ m/^\s*int?\s*=\s*(\w+)\s*$/i;
            shift(@file) while @file && $file[0] =~ m/^\s*$|^\s*#/;            

            # Expect "ModelList"
            last if $file[0] =~ m/^\s*genenames?\s*=\s*(\w+)\s*$/i;
            die "Error: unparsable line in '$filename' (expected \"ModelList\" keyword),for gene : $genename\n"  
                if $file[0] !~ m/^\s*modelList\s*$/i;
            shift(@file);

            while (@file && $file[0] !~ m/^\s*endmodelList\s*$/i) {
                my $line = shift(@file);
                next if $line =~ m/^\s*$|^\s*#/;
                chomp($line);
                # Expected "EndModelList"
                die "Error: expected \"EndModelList\" keyword before \"CommandList\" keyword.\n"
                   if $line =~ m/^\s*commandList\s*$/i;
                die "Line : '$line' isn't in the right format.\nExpected : 'model_name : command list seperated by comma (exemple : command1,comand2)'\n"
                                              if $line !~ /^(\w+)\s+:\s+([\w,]+)\s*$/;
                my ($name,$commandlist) = ($1,$2) if $line =~ /^(\w+)\s+:\s+([\w,]+)\s*$/;
                $commandset->{$name} = $commandlist;
            }
            
            shift(@file) if    @file && $file[0] =~ m/^\s*endmodelList\s*$/i;
            shift(@file) while @file && $file[0] =~ m/^\s*$|^\s*#/;
            last if !@file;
            
            # Expected "CommandList"
            die "Error: unparsable line in '$filename' (expected \"CommandList\" keyword),for gene : $genename\n"
                if $file[0] !~ m/^\s*commandList\s*$/i;
            shift(@file);
           
            while (@file && $file[0] !~ m/^\s*endcommandList\s*$/i) {
                my $line = shift(@file);
                next if $line =~ m/^\s*$|^\s*#/;
                chomp($line);
                #Expected "EndCommandList"
                die "Error: expected \"EndCommandList\" keyword before \"GeneName=\" keyword.\n"
                   if $line =~  m/^\s*genenames?\s*=\s*(\w+)\s*$/i;
                die "Line : '$line' isn't in the right format.\nExpected : 'command_name : command'\n"
                                              if $line !~ /^(.+):(.+)$/;
                my ($command_name,$command) = ($1,$2) if $line =~ /^(.+):(.+)$/;
                # cas de la continuation de commande
                while ($command =~ m/\\s*$/) {
                    chomp($command);
                    $line = shift(@file);
                    $command .=  "$line";
                }
                $command_name =~ s/\s*//g;
                $command      =~ s/^\s*//;
                $command      =~ s/\\//g;
                $commandList->{$command_name} = $command;
            }

            unshift(@file,"(EOF)\n") unless @file; # for error message
            my $endcomkeyword = shift(@file);
            die "Error: unparsable line in '$filename' (expected \"EndCommandList\" keyword), got:\n$endcomkeyword"
                unless $endcomkeyword =~ m/^\s*endcommandList\s*$/i;
            
            last if $file[0] =~ m/^\s*genenames?\s*=\s*(\w+)\s*$/i;
            shift(@file) while @file && $file[0] =~ m/^\s*$|^\s*#/;
            last if !@file;
            
            # Expected "genename"
            my $tmp_line = $file[0];
            die "Error: unparsable line in '$filename' (expected \"genename=\"), got:\n$tmp_line" 
                if $file[0] !~ m/^\s*genenames?\s*=\s*\w+\s*$/i;
        }
        $genecoms->{$genename} = $genecom;
    }

    $self->set_geneprogs($genecoms);
    
    &makeValidation($self,$filename);
    
    $self;
}

sub makeValidation {
    my $self     = shift;
    my $filename = shift;
    
    my $genecomsets     = $self->get_geneprogs(); 
    
     while ( my ($name, $gene_hash) = each(%$genecomsets) ) {
         my $genename    = $gene_hash->get_genename();
         my $modelList   = $gene_hash->get_modelList();
         my $commandList = $gene_hash->get_commandList();
         
         # Check if ModelList block isn't empty
         die "Error in '$filename', ModelList block is empty for $genename?!?\n"
             if !%$modelList;
         
         # Check if CommandList block isn't empty
         die "Error in '$filename', CommandList block is empty for $genename?!?\n"
             if !%$commandList;
         
         # Check if all command present in ModelList block are on CommanList block
         while (my ($model_name, $list_of_commands) = each(%$modelList)) {
            my @command_tab = split(/,/, $list_of_commands);
            foreach my $command (@command_tab) {
                die "Error in '$filename', the command '$command' doesn't exist in CommandList for $genename.\n"
                    if !$commandList->{$command};
            }
         }
    }
}
