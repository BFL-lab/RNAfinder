# RNAfinder

RNafinder is used to  search for and identify RNAs. It is a wrapper around a search tool called [erpin]((http://rna.igmors.u-psud.fr/Software/erpin.php))

This package is based on activities of  the [OGMP](http://megasun.bch.umontreal.ca/ogmp/) (i.e, priori to 2002), and
becomes open source as part of [MFannot](http://megasun.bch.umontreal.ca/RNAweasel/).

## Install

In order to run RNAfinder you need:

1. Install [erpin](http://rna.igmors.u-psud.fr/Software/erpin.php) on your system.  

```
wget http://rssf.i2bc.paris-saclay.fr/download/Erpin/erpin5.5.4.serv.tar.gz    
tar -xvzf erpin5.5.4.serv.tar.gz    
cd erpin5.5.4.serv
make
# Add erpin (`bin/erpin`) to $PATH
cp bin/erpin ~/bin/.
```
	
2. Install the [PirObject](https://github.com/prioux/PirObject) library.

```
git clone https://github.com/prioux/PirObject
# Add `PirObject.pm` to @INC (Perl package path)
sudo cp PirObject/lib/PirObject.pm /usr/share/perl5/.
```

3. Install all the necessary [PirModels](https://github.com/BFL-lab/PirModels).

```
sudo git clone https://github.com/BFL-lab/PirModels ~/PirModels
```

4. Install the BioPerl library [Bio::Tools::CodonTable](http://search.cpan.org/dist/BioPerl/Bio/Tools/CodonTable.pm)

```
sudo cpanm Bio::Tools::CodonTable
```

5. Copy the `DOT_RNAfinder.cfg` in your home directory under `.RNAfinder.cfg` or under the directory defined by the `RNAFINDER_CFG_PATH` environment variable.

```
cp DOT_RNAfinder.cfg .RNAfinder.cfg
echo "export RNAFINDER_CFG_PATH=`pwd`" >> ~/.bashrc
source ~/.bashrc
```

6. Copy `RNAfinder` file in one of your executable directory (e.g: a directory list in $PATH).

```
cp RNAfinder ~/bin/.
```

7. Add the models needed for the run

```
git clone https://github.com/BFL-lab/MFannot_data
echo "# MFannot data installation" >>mfannot-data
echo "export EGC=`pwd`/MFannot_data/EGC" >>mfannot-data
echo "export MFANNOT_EXT_CFG_PATH=`pwd`/MFannot_data/config" >>mfannot-data
echo "export MFANNOT_MOD_PATH=`pwd`/MFannot_data/models" >>mfannot-data
echo "export ERPIN_MOD_PATH=`pwd`/MFannot_data/models/Erpin_models" >>mfannot-data
echo "export MFANNOT_LIB_PATH=`pwd`/MFannot_data/protein_collections" >>mfannot-data
cat mfannot-data >>~/.bashrc
source ~/.bashrc
```

**Note**: At this point the installation of `RNAfinder` was only tested on Unix systems (Ubuntu and CentOS).

## Usage

In order to get the help page of RNAfinder you need to type `RNAfinder -h` in your terminal.

### Models

- rns
- tRNA
- rnpB
- rrn5
- IntronI
- IntronII

### Example

Run RNAfinder on a fungla mitocondrial genome to identify rns gene and capture the XML result in a file.

```
file=fungal_mt.fas
geneticcode=4
RNAfinder -m rns -g $geneticcode -d $file  -X - >result.xml
```

## Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) and [CONDUCT](CONDUCT.md) for details.

## Credits

- [All Contributors](https://github.com/BFL-lab/RNAfinder/graphs/contributors)

## License

GNU General Public License v3.0. Please see [License File](LICENSE.md) for more information.
