
# This model represents the parameters for a single run of RNAfinder
# as launched by the web interface.
#
# $Id: RNAfinderWebRequest.pir,v 1.1 2009/09/25 00:34:15 riouxp Exp $
#
# $Log: RNAfinderWebRequest.pir,v $
# Revision 1.1  2009/09/25 00:34:15  riouxp
# Initial version.
#

- PerlClass	PirObject::RNAfinderWebRequest
- InheritsFrom	PirObject
- FieldsTable

# Field name		Sing/Mult	Type		Comments
#---------------------- ---------------	---------------	-----------------------
data                    single          string          basename of input file (-d)
model                   single          string          name of model(s) (-m)
code                    single          int4            genetic code (-c)
mail                    single          string          email to send result to (-a)

- EndFieldsTable

- Methods

our $RCS_VERSION='$Id: RNAfinderWebRequest.pir,v 1.1 2009/09/25 00:34:15 riouxp Exp $';
our ($VERSION) = ($RCS_VERSION =~ m#,v ([\w\.]+)#);

