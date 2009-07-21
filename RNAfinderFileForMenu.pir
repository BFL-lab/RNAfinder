
#
# This class represents the RNAfinderFileforMenu used by RNAfinder;
# That file stores foreach RNA model the followed information : 
#
# Name = rnpB                                                                               | Name of model used in order to run RNAfinder
#                                                                                           |
# # rnpB (RNase P RNA), generale:                                                           | A comment that appears only in the file RNAfinderFileForMenu
# Commands                                                                                  | Start of commands list
#    Item                                                                                   | List used for run erpin one time
#        erpin_arg  = "1,10 -add 2 4 -add 3 5 -add 8 9 -logzero -5 -cutoff 2.5 12 17"       | erpin arguments
#        model_name = rnpB-mito.epn                                                         | name of model file used by erpin
#        comment    = ""                                                                    | Comment that must appear in RNAfinder Usage
#    EndItem                                                                                | 
# EndCommans                                                                                | End of Commands list
#
# For tRNA user should add the position of anticodon for each item.
# To do this add this line :
#       pos_ac = "13"
# Between "Item" and "EndItem" if the anticodon is the 13 element of the model.
#
# $Id: RNAfinderFileForMenu.pir,v 1.1 2009/07/21 15:58:18 nbeck Exp $
#
# $Log: RNAfinderFileForMenu.pir,v $
# Revision 1.1  2009/07/21 15:58:18  nbeck
# Fusion between RNASpinner and RNAfinder.
#
#

- PerlClass	PirObject::RNAfinderFileForMenu
- InheritsFrom	PirObject
- FieldsTable

# Field name    		Sing/Array/Hash	Type		    Comments
#---------------------- ---------------	---------------	-----------------------
filename                single          string          optional
MenuList           	    array	        <MenuList>      Menu list

- EndFieldsTable
- Methods

our $RCS_VERSION='$Id: RNAfinderFileForMenu.pir,v 1.1 2009/07/21 15:58:18 nbeck Exp $';
our ($VERSION) = ($RCS_VERSION =~ m#,v ([\w\.]+)#);

# Sample format of text file
#
# Used for identification of tRNA
#Name = tRNA
#
#   Item
#       erpin_arg  = "-1,19 -add 1 17 18 -add 11 12 14 -add 2 3 5 7 -logzero -5 -cutoff 2.9 8 30"
#       model_name = tRNA.epn
#       pos_ac     = 13
#       comment    = ""
#   EndItem
#

sub ImportFromTextFile {
    my $self     = shift;
    my $filename = shift;

    my $class = ref($self) || $self;

    $self = $class->new() if $self eq $class;
    $self->set_filename($filename);

    my $fh = new IO::File "<$filename"
        or die "Cannot read from file '$filename': $!\n";
    my @file = <$fh>;
    $fh->close();

    my $MenuList = {};
    my $count_line = 0;
    while (@file) {
        my $line = shift(@file);
        $count_line++;
        next if $line =~ m/^\s*$|^\s*#/;
        
        # Expects "genename"
        die "Error: unparsable line '$count_line' in '$filename' (expected \"name=\"), got:\n$line"
            if ($line !~ m/^\s*name?\s*=\s*(\w+)\s*$/i);
        my $name = $1;  # potentially a list, like "abc,def"
        $name =~ s/\s+//;
        die "Error: genename '$name' line '$count_line' seen more than once in file '$filename'.\n"
            if exists $MenuList->{lc($name)};
            
        my $List = new PirObject::MenuList(
            ItemSet => {},
            OriName => $name
        );
        
        my $ItemSet = $List->get_ItemSet();
        while (@file && $file[0] =~ m/^\s*$|^\s*#/) {
            shift(@file);
            $count_line++;
        }
        my $Item_counter = 0;
        while (@file) {
            while (@file && $file[0] =~ m/^\s*$|^\s*#/){
                shift(@file);
                $count_line++;
            }
            last if !@file;
            $file[0] =~ s/\n$//;
            
            last if $file[0] !~ m/^\s*Item\s*$/i;
            shift(@file);
            $count_line++;
            
            $Item_counter++;
            my $autorized_fields = ["erpin_arg","model_file","label","pos_ac","comment","module"];
            my $Item = new PirObject::Item();
            while (@file && $file[0] !~ m/^\s*EndItem\s*$/i) {
                my $line_b = shift(@file);
                $count_line++;
                chomp($line_b);
                next if $line_b eq "";
                die "Line '$line_b' must begin with 'field =', for autorized fields see in '$filename', line '$count_line'.\n"
                    if $line_b !~ m/^\s*\w+\s*=/;
                my ($field,$value) = ($1,$2) if $line_b =~ m/^\s*(\w+)\s*=(.+)/;
                $value =~ s/^\s*//;
                $value =~ s/\s*$//;
                
                die "Field : '$field' line '$count_line' isn't autorized, line '$count_line'.\n" 
                    if !(grep(/^$field/, @$autorized_fields));
                $Item->set_erpinArg($value)  if $field eq "erpin_arg";
                $Item->set_modelFile($value) if $field eq "model_file";
                $Item->set_Label($value)     if $field eq "label";
                $Item->set_AcId($value)      if $field eq "pos_ac";
                $Item->set_module($value)    if $field eq "module";
                $Item->set_comment($value)   if $field eq "comment";
            }
            unshift(@file,"(EOF)\n") unless @file; # for error message
            my $endcomkeyword = shift(@file);
            $count_line++;
            die "Error: unparsable line '$count_line' in '$filename' (expected \"EndItem\" keyword), got:\n$endcomkeyword."
            unless $endcomkeyword =~ m/^\s*EndItem\s*$/i;
            
            die "Item$Item_counter for block '$name' haven't erpin arguments, line '$count_line'.\n" if !($Item->get_erpinArg());
            die "Item$Item_counter for block '$name' haven't model file, line'$count_line'\n."       if !($Item->get_modelFile());
            $ItemSet->{$Item_counter} = $Item;
        }
        $MenuList->{lc($name)} = $List;
    }
    $self->set_MenuList($MenuList);
    $self;
}
