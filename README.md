# RNAfinder

RNafinder is used to  search for and identify RNAs. It is a wrapper around a search tool called [erpin]((http://rna.igmors.u-psud.fr/Software/erpin.php))

This package is based on activities of  the [OGMP](http://megasun.bch.umontreal.ca/ogmp/) (i.e, priori to 2002), and
becomes open source as part of [MFannot](http://megasun.bch.umontreal.ca/RNAweasel/).

## Install

In order to run RNAfinder you need:

1. Install [erpin](http://rna.igmors.u-psud.fr/Software/erpin.php) on your system.
2. Install the [PirObject](https://github.com/prioux/PirObject) library.
3. Install all the necessary [PirModels](https://github.com/BFL-lab/PirModels).
4. Install the BioPerl library [Bio::Tools::CodonTable](http://search.cpan.org/dist/BioPerl/Bio/Tools/CodonTable.pm)
5. Copy the `DOT_RNAfinder.cfg` in your home directory under `.RNAfinder.cfg` or under the directory defined by the `RNAFINDER_CFG_PATH` environment variable.
6. Copy `RNAfinder` file in one of your executable directory (e.g: a directory list in $PATH).

**Note**: At this point the installation of `RNAfinder` was only tested on Unix systems (Ubuntu and CentOS).

## Usage

In order to get the help page of RNAfinder you need to type `RNAfinder -h` in your terminal.

## Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) and [CONDUCT](CONDUCT.md) for details.

## Credits

- [All Contributors](https://github.com/BFL-lab/RNAfinder/graphs/contributors)

## License

GNU General Public License v3.0. Please see [License File](LICENSE.md) for more information.
